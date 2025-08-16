import time
from typing import Dict, Set
from fastapi import Header, HTTPException, Request
from app.config import CONF

API_HEADER = CONF["cfg"]["security"]["api_key_header"]
ALLOW_ANON: Set[str] = set(CONF["cfg"]["security"]["allow_anonymous_routes"])
RATE_LIMIT = int(CONF["cfg"]["security"]["rate_limit_per_minute"])

# naive in-memory rate limiter: ip -> [window_start_ts, count]
_rate: Dict[str, tuple] = {}

async def require_api_key(request: Request, **headers):
    # allow a handful of routes without API key
    if request.url.path in ALLOW_ANON:
        return

    api_key = headers.get(API_HEADER) or request.headers.get(API_HEADER)
    if not api_key:
        raise HTTPException(status_code=401, detail="Missing API key")

    # lightweight RL by client ip
    client_ip = request.client.host if request.client else "unknown"
    now = int(time.time())
    window = now // 60
    key = f"{client_ip}:{window}"
    count = 0
    if key in _rate:
        w, c = _rate[key]
        if w == window:
            count = c
    if count + 1 > RATE_LIMIT:
        raise HTTPException(status_code=429, detail="Rate limit exceeded")
    _rate[key] = (window, count + 1)
