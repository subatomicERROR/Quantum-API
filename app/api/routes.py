from fastapi import APIRouter
from pydantic import BaseModel
from app.quantum.runner import run_quantum

api_router = APIRouter(prefix="/api")

class QuantumRequest(BaseModel):
    qubits: int = 2
    operation: str = "hadamard"

@api_router.post("/quantum")
async def quantum_endpoint(req: QuantumRequest):
    return {"result": run_quantum(req.qubits, req.operation)}
