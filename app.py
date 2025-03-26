from fastapi import FastAPI, HTTPException, Request, APIRouter
from fastapi.staticfiles import StaticFiles
from starlette.responses import FileResponse, HTMLResponse, JSONResponse, RedirectResponse
from fastapi.openapi.utils import get_openapi
from pydantic import BaseModel
from typing import Optional
import logging
import os

# Custom StaticFiles class to provide a fallback to index.html for SPA routes
class SPAStaticFiles(StaticFiles):
    async def get_response(self, path: str, scope):
        response = await super().get_response(path, scope)
        if response.status_code == 404:
            index_path = os.path.join(self.directory, "index.html")
            if os.path.exists(index_path):
                return FileResponse(index_path)
        return response

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

# Serve the Next.js frontend on a subpath (/gui) using the SPAStaticFiles class
FRONTEND_BUILD_DIR = "frontend-build"
if os.path.exists(FRONTEND_BUILD_DIR):
    app.mount("/gui", SPAStaticFiles(directory=FRONTEND_BUILD_DIR, html=True), name="frontend")
    logger.info("✅ Next.js frontend detected & mounted at /gui.")
else:
    logger.warning("⚠️ Frontend build directory not found.")

# Serve static files
if os.path.exists("static"):
    app.mount("/static", StaticFiles(directory="static"), name="static")

# Quantum Data Model
class QuantumData(BaseModel):
    data: str
    quantum_factor: Optional[float] = 1.0  # Quantum computation parameter

# API Router for better structure
router = APIRouter()

# Root route now redirects to the Next.js GUI at /gui
@router.get("/", response_class=HTMLResponse)
def home():
    return RedirectResponse(url="/gui")

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
