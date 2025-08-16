#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "⚡ Quantum-API Auto Launcher"

# --- Load .env safely ---
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs -d '\n' -I {} echo {}) >/dev/null 2>&1 || true
fi

# --- Default environment ---
ENV="${APP_ENV:-development}"

# --- Load config.json safely ---
if [ -f config.json ]; then
    HOST=$(jq -r ".environments.\"$ENV\".host" config.json)
    PORT=$(jq -r ".environments.\"$ENV\".port" config.json)
    RELOAD=$(jq -r ".environments.\"$ENV\".reload" config.json)
else
    HOST="127.0.0.1"
    PORT=8000
    RELOAD="true"
fi

# --- Generate QUANTUM_API_KEY if missing ---
if [ -z "${QUANTUM_API_KEY:-}" ]; then
    export QUANTUM_API_KEY=$(openssl rand -hex 16)
    echo "🔑 Generated QUANTUM_API_KEY: $QUANTUM_API_KEY"
fi

# --- Create a .env for FastAPI auto-load ---
echo "QUANTUM_API_KEY=$QUANTUM_API_KEY" > .env

# --- Robust port cleanup ---
echo "⚡ Cleaning port $PORT..."
pids=$(lsof -t -i :"$PORT" || true)
if [ -n "$pids" ]; then
    echo "⛔ Killing processes on port $PORT: $pids"
    for pid in $pids; do
        sudo kill -9 $pid || true
        children=$(pgrep -P $pid || true)
        for c in $children; do sudo kill -9 $c || true; done
    done
fi

# --- Ensure Python dependencies ---
echo "📦 Installing/upgrading dependencies..."
pip install --upgrade pip >/dev/null
for pkg in fastapi uvicorn pennylane qiskit pydantic jq python-dotenv; do
    pip show $pkg >/dev/null 2>&1 || pip install --upgrade $pkg
done

# --- Start Uvicorn server ---
if [ -f app/main.py ]; then
    ASGI_APP="app.main:app"
elif [ -f main.py ]; then
    ASGI_APP="main:app"
else
    echo "❌ Cannot find main.py or app/main.py. Exiting."
    exit 1
fi

echo "🔌 Launching Quantum-API on $HOST:$PORT (env=$ENV, reload=$RELOAD)"
if [ "$RELOAD" = "true" ]; then
    exec uvicorn "$ASGI_APP" --host "$HOST" --port "$PORT" --reload --env-file .env --log-level info
else
    exec uvicorn "$ASGI_APP" --host "$HOST" --port "$PORT" --env-file .env --log-level info
fi
