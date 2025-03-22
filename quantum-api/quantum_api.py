import pennylane as qml
import sys
import json

# Print to verify if the script is being executed
print("Quantum API script started")

# Define a quantum device
dev = qml.device("default.qubit", wires=2)

# Define the quantum function
@qml.qnode(dev)
def quantum_function(x):
    # A simple quantum circuit
    qml.Hadamard(wires=0)
    qml.CNOT(wires=[0, 1])
    
    # Use 'x' to modify the quantum computation, here we're using it to scale an operation
    qml.RX(x, wires=0)  # Apply a rotation based on the input 'x'
    
    return qml.expval(qml.PauliZ(0))  # Return expectation value of PauliZ on qubit 0

def run_quantum_ml_task(x):
    result = quantum_function(x)
    return result

# Check if the script is being run as the main program
if __name__ == "__main__":
    # Print to check if we are inside the main execution
    print("Inside main execution block")

    # Get the input from the POST request data (instead of sys.argv)
    input_data = sys.stdin.read()  # Read the data passed in the POST request body
    print(f"Received input data: {input_data}")

    try:
        # Parse the incoming JSON data
        data = json.loads(input_data)
        x = float(data.get('data', 0))  # Use default value of 0 if no 'data' key exists
        print(f"Parsed value of x: {x}")
    except json.JSONDecodeError:
        print("Error: Invalid JSON data.")
        sys.exit(1)
    except ValueError:
        print("Error: Invalid input data.")
        sys.exit(1)
    
    # Run the quantum task and print the result
    result = run_quantum_ml_task(x)
    print(f"Quantum result: {result}")
