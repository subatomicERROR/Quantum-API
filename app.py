from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import Optional
import logging
import os
from fastapi.responses import HTMLResponse
from fastapi.openapi.utils import get_openapi

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Quantum-API",
    description="Quantum-API powered by FastAPI and PennyLane",
    version="1.0",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json"
)

# Serve static files (for Hugging Face compatibility)
if os.path.exists("static"):
    app.mount("/static", StaticFiles(directory="static"), name="static")

# Quantum Data Model
class QuantumData(BaseModel):
    data: str
    quantum_factor: Optional[float] = 1.0  # Quantum computation parameter

# Root HTML Response
@app.get("/", response_class=HTMLResponse)
def home():
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quantum-API</title>
    </head>
    <body>
        <h1>Welcome to the Quantum API!</h1>
        <p>Hosted on Hugging Face Spaces, powered by FastAPI and PennyLane.</p>
    </body>
    </html>
    """

# Quantum Processing Endpoint
@app.post("/quantum-endpoint")
async def quantum_process(data: QuantumData):
    logger.info(f"Processing quantum data: {data.data} with factor {data.quantum_factor}")
    
    # Placeholder quantum computation
    quantum_result = f"Processed {data.data} with quantum factor {data.quantum_factor}"
    
    return {"quantum_result": quantum_result}

# Enable OpenAPI schema
@app.get("/openapi.json")
def get_open_api_endpoint():
    return get_openapi(title="Quantum-API", version="1.0", routes=app.routes)
