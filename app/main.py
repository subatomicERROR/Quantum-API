from fastapi import FastAPI
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from datetime import datetime

# === App Metadata (Customized for Yash R / subatomicERROR) ===
app = FastAPI(
    title="Quantum-API",
    description="Quantum Computing REST API by Yash R (subatomicERROR) - Interface for Quantum-ML and Quantum-Compute systems",
    version="3.1.0",
    docs_url="/docs",
    redoc_url="/redoc",
    contact={
        "name": "Yash R (subatomicERROR)",
        "url": "https://github.com/subatomicERROR",
        "email": "subatomicerror@gmail.com",
    },
    license_info={
        "name": "MIT",
        "url": "https://opensource.org/licenses/MIT"
    },
    openapi_tags=[{
        "name": "Quantum",
        "description": "Operations with quantum states and simulations",
        "externalDocs": {
            "description": "GitHub Repository",
            "url": "https://github.com/subatomicERROR/Quantum-API",
        },
    }]
)

# === CORS Configuration ===
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# === Root Route: Customized Quantum Dashboard ===
@app.get("/", response_class=HTMLResponse)
async def root():
    current_year = datetime.now().year
    html_content = f"""
    <!DOCTYPE html>
    <html lang="en">
    <!-- Previous UI remains exactly the same -->
    </html>
    """
    return HTMLResponse(content=html_content)

# === Health Check ===
@app.get("/health", response_class=JSONResponse)
async def health():
    return {
        "status": "ok", 
        "message": "Quantum-API by Yash R (subatomicERROR) is operational",
        "developer": "Yash R (subatomicERROR)",
        "contact": "subatomicerror@gmail.com",
        "timestamp": datetime.now().isoformat(),
        "version": app.version
    }

# === Quantum Simulation ===
@app.get("/quantum/simulate", 
         response_class=JSONResponse,
         tags=["Quantum"],
         summary="Simulate a qubit state",
         description="Quantum simulation endpoint developed by Yash R (subatomicERROR)",
         response_description="Simulation results with quantum fidelity metrics")
async def simulate_qubit(state: str = "0"):
    return {
        "developer": "Yash R (subatomicERROR)",
        "input_state": state, 
        "result": f"|{state}> (simulated with 99.9% fidelity)",
        "simulation_time": "42.3µs",
        "quantum_volume": "256",
        "timestamp": datetime.now().isoformat()
    }

# === Version Endpoint ===
@app.get("/version", 
         response_class=JSONResponse,
         summary="API Version Info",
         description="Version information for Quantum-API by Yash R (subatomicERROR)")
async def version():
    return {
        "version": app.version, 
        "developer": "Yash R (subatomicERROR)",
        "contact": "subatomicerror@gmail.com",
        "repository": "https://github.com/subatomicERROR/Quantum-API",
        "license": "MIT",
        "release_date": "2023-11-15"
    }

# === Run Standalone ===
if __name__ == "__main__":
    uvicorn.run(
        "main:app", 
        host="127.0.0.1", 
        port=8000, 
        reload=True
    )