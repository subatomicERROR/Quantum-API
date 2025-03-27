---
title: Quantum-API
emoji: 🚀
colorFrom: green
colorTo: indigo
sdk: docker
python_version: 3.1
sdk_version: latest
suggested_hardware: cpu-basic
suggested_storage: small
app_file: app.py
app_port: 7860
base_path: /
fullWidth: true
header: default
short_description: Quantum-AI API for machine learning and quantum computing.
models:
- openai-community/gpt2
datasets:
- mozilla-foundation/common_voice_13_0
tags:
- quantum-ai
- machine-learning
- docker
thumbnail: >-
  https://cdn-uploads.huggingface.co/production/uploads/66ee940c0989ae1ac1383839/MseLCVmNge3tBJzqDbN1c.jpeg
pinned: true
hf_oauth: false
disable_embedding: false
startup_duration_timeout: 30m
custom_headers:
  cross-origin-embedder-policy: require-corp
  cross-origin-opener-policy: same-origin
  cross-origin-resource-policy: cross-origin
preload_from_hub:
- openai-community/gpt2 config.json
license: mit
---

# Quantum-API

## Overview
Quantum-API is a FastAPI-powered Quantum Computing API integrated with PennyLane. It provides a powerful backend for quantum processing while serving a **Gradio** frontend.

## Features
- **FastAPI Backend**: A lightweight, high-performance API framework.
- **Quantum Processing**: Handles quantum computations with PennyLane.
- **Gradio Frontend**: Interactive UI for testing API endpoints.
- **SEO Optimized**: Metadata for better search engine visibility.
- **Health Check Endpoint**: Ensures the API is running smoothly.

## Installation
To set up and run Quantum-API on your system, follow these steps:

### 1. Clone the Repository
```bash
git clone https://github.com/subatomicERROR/Quantum-API.git
cd Quantum-API
```

### 2. Create a Virtual Environment (Optional but Recommended)
```bash
python3 -m venv qapi_env
source qapi_env/bin/activate  # On Linux/macOS
qapi_env\Scripts\activate  # On Windows
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Run the API
```bash
uvicorn app:app --host 0.0.0.0 --port 7860 --reload
```
The API will be accessible at: `http://localhost:7860`

## API Endpoints

### Root Endpoint (HTML Response)
```http
GET /
```
Returns an SEO-optimized HTML welcome page.

### Quantum Processing Endpoint
```http
POST /quantum-endpoint
```
**Request Body (JSON):**
```json
{
  "data": "your_data_here",
  "quantum_factor": 1.0
}
```
**Response (JSON):**
```json
{
  "status": "success",
  "quantum_result": "Processed your_data_here with quantum factor 1.0"
}
```

### Health Check
```http
GET /health
```
Returns the API status.

### OpenAPI Schema
```http
GET /openapi.json
```
Provides the OpenAPI schema for API documentation.

## Gradio Frontend
- The **Gradio** frontend provides an interactive UI for testing the API endpoints.
- Run the Gradio app separately using:
  ```bash
  python gradio_ui.py
  ```
- Access the Gradio interface at `http://localhost:7860`

## Logging
Logs are enabled with INFO level logging:
```bash
2025-03-27 12:00:00 - INFO - Quantum-API started successfully.
```

## Deployment
To deploy on Hugging Face Spaces:
1. Ensure all dependencies are listed in `requirements.txt`.
2. Configure the Hugging Face Space runtime to use `uvicorn app:app --host 0.0.0.0 --port 7860`.
3. Push the code to your Hugging Face repository.

## Author
Developed by **subatomicERROR** (Yash R).

## 🛠️ Deployment
- Hosted on Hugging Face Spaces.
- Built with **Gradio** for UI interaction.

📌 **Created by**: [subatomicERROR](https://github.com/subatomicERROR)

