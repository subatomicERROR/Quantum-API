from typing import Dict, Any
from app.config import CONF

def get_backend_choice() -> Dict[str, Any]:
    cfg = CONF["cfg"]["quantum_backends"]
    default = cfg["default"]
    meta = cfg["options"][default]
    return {"name": default, **meta}

def select_backend(name: str) -> Dict[str, Any]:
    opts = CONF["cfg"]["quantum_backends"]["options"]
    if name not in opts:
        raise ValueError(f"Unknown backend: {name}")
    return {"name": name, **opts[name]}
