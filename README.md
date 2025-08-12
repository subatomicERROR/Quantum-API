# Quantum-API

Quantum-API is a RESTful API delivering **quantum computing capabilities** through an easy-to-use developer interface.  
It leverages **PennyLane**, **Qiskit**, and **FastAPI** to enable hybrid quantum-classical ML workflows, simulations, and real hardware execution.

## 🚀 Features
- Quantum simulation endpoints
- Hybrid classical-quantum ML models
-  monitoring endpoint
- API documentation at `/docs`
- Production-ready with FastAPI + Uvicorn

## 📦 Installation
```bash
git clone https://github.com/subatomicERROR/Quantum-API.git
cd Quantum-API
python3 -m venv qapi_env
source qapi_env/bin/activate
pip install -r requirements.txt
```

## ▶️ Running the API
```bash
source qapi_env/bin/activate
./start_dev.sh
```
API: [http://127.0.0.1:8000](http://127.0.0.1:8000)  
Docs: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

## 📡 Example Requests
**Health Check**
```bash
curl http://127.0.0.1:8000/health
```

**Quantum Simulation**
```bash
curl "http://127.0.0.1:8000/quantum/simulate?state=0"
```

## 🛠 Development Workflow
1. Create feature branch  
2. Test locally with `./start_dev.sh`  
3. Push changes to GitHub

## 📜 License
This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.

---
💡 Built by [subatomicERROR](https://github.com/subatomicERROR)
