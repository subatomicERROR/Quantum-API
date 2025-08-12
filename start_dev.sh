#!/bin/bash
PORT=8000

# Kill any existing process using the port
if lsof -ti :$PORT >/dev/null; then
    echo "Killing old process on port $PORT..."
    kill -9 $(lsof -ti :$PORT)
fi

# Start uvicorn in foreground mode
echo "Starting Quantum-API on http://127.0.0.1:$PORT"
exec uvicorn app.main:app --host 127.0.0.1 --port $PORT --reload

