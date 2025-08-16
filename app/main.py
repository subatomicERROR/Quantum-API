import os
from fastapi import FastAPI, Request, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, RedirectResponse

from app.config import CONF
from app.security.api_key import require_api_key
from app.routers.health import router as health_router
from app.services.quantum_backend import get_backend_choice, select_backend

cfg, env, settings = CONF["cfg"], CONF["env"], CONF["settings"]

app = FastAPI(
    title=cfg["app"]["name"],
    version=cfg["app"]["version"],
    debug=settings["debug"],
    docs_url=cfg["app"]["docs_route"],
    redoc_url=cfg["app"]["redoc_route"]
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings["cors_origins"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global dependency for API key + simple rate limit
@app.middleware("http")
async def auth_and_rate_limit(request: Request, call_next):
    # delegate to security module (allows anonymous for some routes)
    await require_api_key(request)
    return await call_next(request)

@app.get("/", response_class=HTMLResponse)
def root():
    if cfg["app"]["root_redirect_to_docs"]:
        return RedirectResponse(url=cfg["app"]["docs_route"])
    return f"<h1>{cfg['app']['name']}</h1><p>Environment: {env}</p>"

# Example: current backend
@app.get("/quantum/backend")
def current_backend():
    return get_backend_choice()

# Example: switch backend via query (?name=qiskit.aer)
@app.post("/quantum/backend/select")
def switch_backend(name: str):
    return select_backend(name)

# Plug routers
app.include_router(health_router)
