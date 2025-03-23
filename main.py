import uvicorn
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import pennylane as qml
import numpy as np

app = FastAPI()

# Enable CORS to prevent browser security issues
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all domains (change if needed)
    allow_credentials=True,
    allow_methods=["*"],  # Allow all HTTP methods
    allow_headers=["*"],  # Allow all headers
)

@app.get("/")
async def root():
    return {"message": "Welcome to the Quantum API on Hugging Face! Use /quantum-ai/predict for predictions."}

# Quantum circuit for decision-making
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

# Request model
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
            decision = "Quantum uncertainty detected: Explore alternate quantum possibilities."
        else:
            decision = "Quantum decision is inconclusive: Further analysis required."

        return {
            "quantum_results": {
                "qubit_0": quantum_results[0],
                "qubit_1": quantum_results[1],
                "qubit_2": quantum_results[2],
            },
            "decision": decision
        }
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Quantum processing error: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=7860)
