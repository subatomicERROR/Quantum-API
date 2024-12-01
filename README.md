# Quantum-API

Quantum-API is a web API built using **FastAPI** and **PennyLane**, providing quantum-enhanced decision-making capabilities. The API exposes a simple quantum circuit that performs decision-making tasks based on quantum computation. This API is part of a larger quantum machine learning system that integrates with other services like Quantum-Compute for quantum computation and Quantum-ML for model training.

## Features

- Quantum decision-making using **PennyLane** and **Quantum Circuit**.
- Exposes an endpoint to predict a quantum-enhanced decision.
- Built with **FastAPI** for high performance and asynchronous support.
- Can be integrated with other quantum systems and microservices.

## Requirements

- Python 3.8+
- `pip install -r requirements.txt`

## Installation

### Clone the repository

```bash
git clone https://github.com/subatomicERROR/Quantum-API.git
cd Quantum-API
```

### Set up a virtual environment

```bash
python3 -m venv quantum-env
source quantum-env/bin/activate  # On Windows: quantum-env\Scripts\activate
```

### Install the dependencies

```bash
pip install -r requirements.txt
```

## Running the API

Once the dependencies are installed, you can run the API using **Uvicorn**:

```bash
uvicorn main:app --host 0.0.0.0 --port 5000
```

This will start the FastAPI application, and it will be available at `http://localhost:5000`.

## Endpoints

### `GET /`

The root endpoint returns a simple confirmation message indicating the API is running.

### `POST /quantum-ai/predict`

This endpoint performs quantum-enhanced decision-making based on the result of a quantum circuit simulation.

#### Request Body:

```json
{
  "input_data": "your_data_here"
}
```

#### Response:

The response includes the quantum result and the decision based on the result.

```json
{
  "quantum_result": 0.0,
  "decision": "Explore alternative paths based on quantum insight."
}
```

### Quantum Decision Logic

The quantum decision-making function runs a quantum circuit with 2 qubits. It applies the following gates:
- **Hadamard Gate** on qubit 0 (creating superposition).
- **CNOT Gate** between qubits 0 and 1 (entangling the qubits).
- **Pauli Z Measurement** on qubit 0 to measure the quantum state.

Based on the measurement outcome:
- If the result is positive (`> 0`), the decision is to proceed with the optimal path.
- If the result is negative (`<= 0`), the decision is to explore alternative paths.

## Example Usage

### Send a Request to `/quantum-ai/predict`

You can test the prediction endpoint using `curl`:

```bash
curl -X 'POST' 'http://localhost:5000/quantum-ai/predict' -H 'Content-Type: application/json' -d '{
  "input_data": "your_data_here"
}'
```

#### Example Response:

```json
{
  "quantum_result": 0.0,
  "decision": "Explore alternative paths based on quantum insight."
}
```

## Contributing

Feel free to contribute by submitting pull requests. All contributions are welcome, whether they are bug fixes, new features, or improvements to documentation.

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a new Pull Request.

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgments

- **FastAPI** for providing the framework to build fast and scalable APIs.
- **PennyLane** for enabling quantum machine learning and quantum computing simulations.
- **Uvicorn** for serving the FastAPI application with high performance.

```
made by subatomicERROR [ Yash Ramteke ]
