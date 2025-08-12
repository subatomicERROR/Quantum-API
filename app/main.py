from fastapi import FastAPI
from app.api.routes import api_router

app = FastAPI(title="Quantum-API", version="0.2.0")
app.include_router(api_router)

@app.get("/health")
async def health():
    return {"status": "ok"}
