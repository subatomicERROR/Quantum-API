from fastapi import FastAPI
from pydantic import BaseModel
from main import quantum_decision

app = FastAPI()

class InputData(BaseModel):
    input_data: str

@app.get("/")
def read_root():
    return {"message": "Welcome to Quantum-API, powered by PennyLane & FastAPI!"}

@app.post("/quantum-ai/predict")
def predict(data: InputData):
    result, decision = quantum_decision(data.input_data)
    return {"quantum_result": result, "decision": decision}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=5000)
