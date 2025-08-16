#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

export $(grep -v '^#' .env | xargs -d '\n' -I {} echo {}) >/dev/null 2>&1 || true
ENV="${APP_ENV:-development}"

HOST=$(jq -r ".environments.\"$ENV\".host" config.json)
PORT=$(jq -r ".environments.\"$ENV\".port" config.json)
RELOAD=$(jq -r ".environments.\"$ENV\".reload" config.json)

echo "🔌 Uvicorn on $HOST:$PORT (env=$ENV, reload=$RELOAD)"
exec uvicorn app.main:app --host "$HOST" --port "$PORT" $( [ "$RELOAD" = "true" ] && echo --reload )
