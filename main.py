import uvicorn
from app import app  # Import the FastAPI app instance from app.py
import pennylane as qml
import numpy as np

# Quantum circuit for decision-making
def quantum_decision_making():
    # Define a quantum device with 2 qubits
    dev = qml.device('default.qubit', wires=2)

    @qml.qnode(dev)
    def circuit():
        # Apply quantum gates to simulate decision making
        qml.Hadamard(wires=0)  # Put qubit 0 in superposition
        qml.CNOT(wires=[0, 1])  # Entangle qubits 0 and 1
        return qml.expval(qml.PauliZ(0))  # Measure qubit 0

    # Run the quantum circuit and interpret the result
    result = circuit()
    print(f"Quantum decision outcome: {result}")
    return result

if __name__ == "__main__":
    # Get a quantum-enhanced decision before starting the app
    quantum_result = quantum_decision_making()

    # Based on the quantum result, we could make some intelligent decision
    if quantum_result > 0:
        print("Decision: Proceed with optimal path based on quantum insight.")
    else:
        print("Decision: Explore alternative paths based on quantum insight.")

    uvicorn.run(app, host="0.0.0.0", port=5000)  # Start FastAPI server
