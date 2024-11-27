from fastapi import FastAPI
from typing import Optional

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Welcome to Quantum-API!"}

@app.get("/quantum-endpoint")
def quantum_endpoint(data: Optional[str] = None):
    # Simulate some processing, you can integrate it with your Quantum-ML model here.
    result = f"Processed quantum data: {data}"
    return {"result": result}
