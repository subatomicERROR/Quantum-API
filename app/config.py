import json, os
from typing import Any, Dict

def load_config() -> Dict[str, Any]:
    with open("config.json") as f:
        cfg = json.load(f)
    env = os.getenv("APP_ENV", cfg["app"]["default_env"])
    settings = cfg["environments"][env]
    return {"cfg": cfg, "env": env, "settings": settings}

CONF = load_config()
