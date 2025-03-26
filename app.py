from fastapi import FastAPI, HTTPException, Request, APIRouter
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.openapi.utils import get_openapi
from pydantic import BaseModel
from typing import Optional
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Quantum-API",
    description="Quantum-API powered by FastAPI and PennyLane",
    version="1.1",
    docs_url="/docs",
    redoc_url="/redoc",
    openapi_url="/openapi.json"
)

# Serve the Next.js frontend
FRONTEND_BUILD_DIR = "frontend-build"
if os.path.exists(FRONTEND_BUILD_DIR):
    app.mount("/", StaticFiles(directory=FRONTEND_BUILD_DIR, html=True), name="frontend")
    logger.info("✅ Next.js frontend detected & mounted successfully.")

# Serve static files
if os.path.exists("static"):
    app.mount("/static", StaticFiles(directory="static"), name="static")

# Quantum Data Model
class QuantumData(BaseModel):
    data: str
    quantum_factor: Optional[float] = 1.0  # Quantum computation parameter

# API Router for better structure
router = APIRouter()

# Root HTML Response with SEO Optimization
@router.get("/", response_class=HTMLResponse)
def home():
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Quantum-API powered by FastAPI and PennyLane. The future of quantum computing.">
        <meta name="keywords" content="Quantum Computing, FastAPI, AI, PennyLane, Quantum-API">
        <meta name="author" content="subatomicERROR">
        <meta property="og:title" content="Quantum-API">
        <meta property="og:description" content="Next-generation Quantum Computing API">
        <meta property="og:image" content="/static/quantum-logo.png">
        <meta property="og:type" content="website">
        <meta property="og:url" content="https://huggingface.co/spaces/subatomicERROR/Quantum-API">
        <meta name="twitter:card" content="summary_large_image">
        <meta name="twitter:title" content="Quantum-API">
        <meta name="twitter:description" content="Explore Quantum Computing with our API.">
        <meta name="twitter:image" content="/static/quantum-logo.png">
        <title>Quantum-API</title>
        <link rel="icon" href="/static/favicon.ico" type="image/x-icon">
    </head>
    <body>
        <h1>🚀 Welcome to the Quantum API!</h1>
        <p>Hosted on Hugging Face Spaces, powered by FastAPI and PennyLane.</p>
    </body>
    </html>
    """

# Quantum Processing Endpoint
@router.post("/quantum-endpoint")
async def quantum_process(data: QuantumData):
    try:
        logger.info(f"Processing quantum data: {data.data} with factor {data.quantum_factor}")
        quantum_result = f"Processed {data.data} with quantum factor {data.quantum_factor}"
        return {"status": "success", "quantum_result": quantum_result}
    except Exception as e:
        logger.error(f"Quantum processing error: {str(e)}")
        raise HTTPException(status_code=500, detail="An error occurred while processing quantum data.")

# API Health Check
@router.get("/health")
def health_check():
    return {"status": "running", "message": "Quantum-API is operational!"}

# Custom Error Handling
@app.exception_handler(404)
async def not_found_handler(request: Request, exc: HTTPException):
    return JSONResponse(status_code=404, content={"error": "Resource not found"})

@app.exception_handler(500)
async def server_error_handler(request: Request, exc: HTTPException):
    return JSONResponse(status_code=500, content={"error": "Internal server error"})

# Enable OpenAPI Schema
@app.get("/openapi.json")
def get_open_api_endpoint():
    return get_openapi(title="Quantum-API", version="1.1", routes=app.routes)

# Include API Router
app.include_router(router)
