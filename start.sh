#!/bin/bash

echo "🚀 Starting Quantum-API Server..."

# Auto-activate virtual environment if it exists
if [ -d "venv" ]; then
    echo "🔄 Activating virtual environment..."
    source venv/bin/activate
else
    echo "⚠️ Virtual environment not found. Skipping..."
fi

# Install dependencies if missing
if [ -f "requirements.txt" ]; then
    echo "📦 Installing dependencies..."
    pip install -r requirements.txt
else
    echo "⚠️ Warning: No requirements.txt file found!"
fi

# Check if main.py exists
if [ -f "main.py" ]; then
    echo "🚀 Launching FastAPI..."
    uvicorn main:app --reload --host 0.0.0.0 --port 5000
else
    echo "❌ ERROR: main.py not found!"
    exit 1
fi
