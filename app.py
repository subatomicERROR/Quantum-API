from fastapi import FastAPI

# Initialize FastAPI app
app = FastAPI(title="Quantum-API", description="An API for Quantum Machine Learning tasks using PennyLane and PyTorch.")

@app.get("/")
def read_root():
    return {"message": "Welcome to Quantum-API hosted on Hugging Face Spaces!"}

# Example quantum endpoint placeholder
@app.get("/quantum-task")
def quantum_task():
    return {"result": "Quantum computation placeholder"}

# Run the app when executed directly
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=7860)
