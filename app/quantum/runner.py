def run_quantum(qubits: int, operation: str):
    try:
        import pennylane as qml
        dev = qml.device("default.qubit", wires=qubits)

        @qml.qnode(dev)
        def circuit():
            for i in range(qubits):
                qml.Hadamard(wires=i)
            return [qml.expval(qml.PauliZ(i)) for i in range(qubits)]

        return circuit().tolist()
    except Exception as e:
        return {"error": str(e)}
