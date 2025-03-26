import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
import pennylane as qml
import numpy as np

app = FastAPI()

# ✅ Enable CORS to allow frontend communication
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change this to your frontend URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ Custom middleware to set COEP & COOP headers
@app.middleware("http")
async def add_coep_coop_headers(request, call_next):
    response = await call_next(request)
    response.headers["Cross-Origin-Embedder-Policy"] = "require-corp"
    response.headers["Cross-Origin-Opener-Policy"] = "same-origin"
    response.headers["Cross-Origin-Resource-Policy"] = "cross-origin"
    return response

@app.get("/")
async def root():
    return JSONResponse(
        content={"message": "Welcome to the Quantum API on Hugging Face! Use /quantum-ai/predict for predictions."},
        headers={
            "Cross-Origin-Embedder-Policy": "require-corp",
            "Cross-Origin-Opener-Policy": "same-origin",
            "Cross-Origin-Resource-Policy": "cross-origin"
        }
    )

# Quantum Circuit for Decision-Making
def quantum_decision_making():
    """Simulates quantum decision making using PennyLane."""
    dev = qml.device("default.qubit", wires=3)

    @qml.qnode(dev)
    def circuit():
        qml.Hadamard(wires=0)  # Superposition
        qml.Hadamard(wires=1)
        qml.CNOT(wires=[0, 2])  # Entanglement
        qml.CNOT(wires=[1, 2])
        qml.PhaseShift(np.pi / 2, wires=2)  # Phase shift for interference
        return qml.expval(qml.PauliZ(0)), qml.expval(qml.PauliZ(1)), qml.expval(qml.PauliZ(2))

    return circuit()

# Prediction Request Model
class PredictionRequest(BaseModel):
    input_data: str

@app.post("/quantum-ai/predict")
async def predict(request: PredictionRequest):
    """
    Predicts quantum decisions using quantum physics principles.
    """
    try:
        quantum_results = quantum_decision_making()
        decision = ""

        if quantum_results[0] > 0 and quantum_results[1] > 0:
            decision = "Proceed with optimal quantum path: Positive interference detected."
        elif quantum_results[2] < 0:
            decision = "Warning: Negative quantum state detected. Reevaluate."
        else:
            decision = "Neutral quantum state detected."

        return JSONResponse(
            content={"quantum_results": quantum_results, "decision": decision},
            headers={
                "Cross-Origin-Embedder-Policy": "require-corp",
                "Cross-Origin-Opener-Policy": "same-origin",
                "Cross-Origin-Resource-Policy": "cross-origin"
            }
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
