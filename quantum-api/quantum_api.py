# quantum-api/quantum_api.py

import pennylane as qml

# Define a quantum device
dev = qml.device("default.qubit", wires=2)

@qml.qnode(dev)
def quantum_function(x):
    # A simple quantum circuit
    qml.Hadamard(wires=0)
    qml.CNOT(wires=[0, 1])
    return qml.expval(qml.PauliZ(0))

def run_quantum_ml_task(x):
    result = quantum_function(x)
    return result
