# main.py
import uvicorn
from app import app  # Importing the FastAPI app instance from app.py

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000)
