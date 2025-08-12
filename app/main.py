from fastapi import FastAPI
from fastapi.responses import HTMLResponse, JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

# Create the FastAPI app
app = FastAPI(
    title="Quantum-API",
    description="REST API interface for Quantum-ML and Quantum-Compute systems",
    version="2.0.0"
)

# Allow cross-origin requests (useful for frontend integration)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change "*" to allowed domains for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Default root route
@app.get("/", response_class=HTMLResponse)
async def root():
    return """
    <html>
        <head>
            <title>Quantum-API</title>
        </head>
        <body>
            <h1>🚀 Quantum-API is running!</h1>
            <p>Use <a href='/docs'>Swagger Docs</a> to explore the API.</p>
            <p>Version: 2.0.0</p>
        </body>
    </html>
    """

# Example endpoint for health check
@app.get("/health", response_class=JSONResponse)
async def health():
    return {"status": "ok", "message": "Quantum-API is operational"}

# Example quantum computation route
@app.get("/quantum/simulate", response_class=JSONResponse)
async def simulate_qubit(state: str = "0"):
    # Placeholder simulation logic
    return {"input_state": state, "result": f"Simulated quantum state |{state}>"}

# If running standalone
if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, reload=True)

