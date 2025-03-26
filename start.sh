#!/bin/bash

echo "🚀 Starting Quantum-API Server and Frontend..."

# ✅ Activate the correct virtual environment (qvenv)
if [ -d "qvenv" ]; then
    echo "🔄 Activating virtual environment (qvenv)..."
    source qvenv/bin/activate
else
    echo "❌ ERROR: qvenv virtual environment not found!"
    exit 1
fi

# ✅ Install backend dependencies
if [ -f "requirements.txt" ]; then
    echo "📦 Installing backend dependencies..."
    pip install --upgrade pip
    pip install -r requirements.txt
else
    echo "⚠️ Warning: No requirements.txt file found!"
fi

# ✅ Start FastAPI Backend
if [ -f "main.py" ]; then
    echo "🚀 Launching FastAPI Backend..."
    uvicorn main:app --host 0.0.0.0 --port 7860 --reload &
else
    echo "❌ ERROR: main.py not found!"
    exit 1
fi

# ✅ Navigate to frontend and start Next.js
FRONTEND_DIR="frontend"
if [ -d "$FRONTEND_DIR" ]; then
    echo "🌐 Starting Next.js Frontend..."
    cd "$FRONTEND_DIR"
    npm install
    npm run build
    npm start &
else
    echo "⚠️ Warning: Frontend folder not found! Skipping..."
fi

# ✅ Wait for all processes to run
wait
