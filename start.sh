#!/bin/bash

echo "🚀 Starting Quantum-API Server..."

# Auto-activate qvenv virtual environment if it exists
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
    uvicorn main:app --host 0.0.0.0 --port 7860 --reload
else
    echo "❌ ERROR: main.py not found!"
    exit 1
fi
