#!/bin/bash

echo "🚀 Starting Quantum-API Server and Frontend..."

# Auto-activate qvenv virtual environment
if [ -d "qvenv" ]; then
    echo "🔄 Activating virtual environment (qvenv)..."
    source qvenv/bin/activate
else
    echo "❌ ERROR: qvenv virtual environment not found!"
    exit 1
fi

# Ensure pip and dependencies are installed
if [ -f "requirements.txt" ]; then
    echo "📦 Checking and installing dependencies..."
    pip install --upgrade pip
    pip install -r requirements.txt
else
    echo "⚠️ Warning: No requirements.txt file found!"
fi

# Check if main.py exists before running FastAPI
if [ -f "main.py" ]; then
    echo "🚀 Launching FastAPI..."
    uvicorn main:app --host 0.0.0.0 --port 7860 --reload &
else
    echo "❌ ERROR: main.py not found!"
    exit 1
fi

# Navigate to frontend directory and start Next.js
if [ -d "frontend" ]; then
    echo "🌐 Starting Next.js Frontend..."
    cd frontend
    npm install  # Ensure dependencies are installed
    npm run build  # Build frontend
    npm start &  # Start Next.js server
else
    echo "⚠️ Warning: Frontend folder not found! Skipping..."
fi

# Wait for all background processes
wait
