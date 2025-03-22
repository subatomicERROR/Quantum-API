#!/bin/bash

echo "🚀 Starting Hugging Face Space..."

# Step 1: Check if requirements.txt exists and install dependencies
if [ -f "requirements.txt" ]; then
    echo "📦 Installing dependencies..."
    pip install -r requirements.txt
else
    echo "⚠️ Warning: No requirements.txt file found!"
fi

# Step 2: Detect and Start FastAPI if main.py exists
if [ -f "main.py" ]; then
    echo "🚀 Starting FastAPI server..."
    uvicorn main:app --reload --host 0.0.0.0 --port 5000
else
    echo "❌ ERROR: main.py not found!"
    exit 1
fi
