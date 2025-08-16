#!/usr/bin/env bash
set -euo pipefail

echo "🛰  Hyper-setup for Quantum-API starting in: $(pwd)"

# 0) sanity checks
if [ ! -d .git ]; then
  echo "❌ This isn't a git repo. Run inside ~/Quantum-API."
  exit 1
fi

# 1) minimal deps (apt + pip + node cli for Redoc only if available)
echo "📦 Installing lightweight tools (jq, curl)..."
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y jq curl
fi

# Optional: Redocly CLI for pretty docs (skip if npm not available)
if command -v npm >/dev/null 2>&1; then
  echo "📦 Installing @redocly/cli globally..."
  sudo npm i -g @redocly/cli >/dev/null 2>&1 || true
else
  echo "ℹ️ npm not found; will fall back to SwaggerUI HTML client (no static Redoc build)."
fi

# 2) create config.json (idempotent)
echo "📝 Writing config.json ..."
cat > config.json << 'JSON'
{
  "app": {
    "name": "Quantum-API",
    "version": "1.0.0",
    "default_env": "development",
    "docs_route": "/docs",
    "redoc_route": "/redoc",
    "root_redirect_to_docs": true
  },

  "environments": {
    "development": {
      "host": "127.0.0.1",
      "port": 8000,
      "reload": true,
      "debug": true,
      "cors_origins": ["http://127.0.0.1:3000", "http://localhost:3000", "http://127.0.0.1:8000", "http://localhost:8000"],
      "api_base_url": "http://127.0.0.1:8000"
    },
    "staging": {
      "host": "0.0.0.0",
      "port": 8000,
      "reload": false,
      "debug": false,
      "cors_origins": ["https://staging.quantum-api.subatomicERROR.dev"],
      "api_base_url": "https://staging.quantum-api.subatomicERROR.dev"
    },
    "production": {
      "host": "0.0.0.0",
      "port": 8000,
      "reload": false,
      "debug": false,
      "cors_origins": ["https://subatomicERROR.github.io"],
      "api_base_url": "https://api.subatomicerror.dev"
    }
  },

  "security": {
    "api_key_header": "X-API-Key",
    "jwt_algorithm": "HS256",
    "rate_limit_per_minute": 60,
    "allow_anonymous_routes": ["/", "/health", "/openapi.json", "/docs", "/redoc"]
  },

  "quantum_backends": {
    "default": "pennylane.lightning.qubit",
    "options": {
      "pennylane.lightning.qubit": {
        "type": "simulator",
        "shots": 1000
      },
      "qiskit.aer": {
        "type": "simulator",
        "shots": 1024
      },
      "ibmq.manila": {
        "type": "hardware",
        "provider": "IBM Quantum Experience",
        "token_env": "IBMQ_TOKEN"
      }
    }
  }
}
JSON

# 3) .env templates
echo "📝 Writing .env files ..."
cat > .env.example << 'ENVX'
APP_ENV=development
API_KEY=changeme-local-dev-key
JWT_SECRET=change_this_to_a_long_random_string_for_dev
IBMQ_TOKEN=
ENVX

# Only create .env if not present (avoid overwriting secrets)
if [ ! -f .env ]; then
  cp .env.example .env
fi

# 4) Python dependencies (only the minimal ones if missing)
echo "🐍 Ensuring Python deps ..."
if [ -z "${VIRTUAL_ENV:-}" ]; then
  echo "ℹ️ No venv active. Trying to use existing qapi_env..."
  if [ -d "qapi_env" ]; then
    source qapi_env/bin/activate
  else
    python3 -m venv qapi_env
    source qapi_env/bin/activate
  fi
fi
pip install --upgrade pip >/dev/null
pip install fastapi uvicorn[standard] python-multipart >/dev/null
pip install 'pydantic<3' >/dev/null

# 5) Create app modules if missing
mkdir -p app/routers app/middleware app/security app/services

# 5a) app/config.py
echo "🧠 Writing app/config.py ..."
cat > app/config.py << 'PY'
import json, os
from typing import Any, Dict

def load_config() -> Dict[str, Any]:
    with open("config.json") as f:
        cfg = json.load(f)
    env = os.getenv("APP_ENV", cfg["app"]["default_env"])
    settings = cfg["environments"][env]
    return {"cfg": cfg, "env": env, "settings": settings}

CONF = load_config()
PY

# 5b) app/security/api_key.py
echo "🔐 Writing app/security/api_key.py ..."
cat > app/security/api_key.py << 'PY'
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
PY

# 5c) app/services/quantum_backend.py
echo "⚛️ Writing app/services/quantum_backend.py ..."
cat > app/services/quantum_backend.py << 'PY'
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
PY

# 5d) app/routers/health.py
echo "❤️ Writing app/routers/health.py ..."
cat > app/routers/health.py << 'PY'
from fastapi import APIRouter
from app.config import CONF

router = APIRouter()

@router.get("/health")
def health():
    return {
        "status": "ok",
        "app": CONF["cfg"]["app"]["name"],
        "env": CONF["env"],
        "version": CONF["cfg"]["app"]["version"]
    }
PY

# 5e) app/main.py
echo "🛠  Patching app/main.py ..."
cat > app/main.py << 'PY'
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
PY

# 6) Start script (dev) that respects APP_ENV and config.json
echo "🖥  Writing start_dev.sh ..."
cat > start_dev.sh << 'SH'
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

export $(grep -v '^#' .env | xargs -d '\n' -I {} echo {}) >/dev/null 2>&1 || true
ENV="${APP_ENV:-development}"

HOST=$(jq -r ".environments.\"$ENV\".host" config.json)
PORT=$(jq -r ".environments.\"$ENV\".port" config.json)
RELOAD=$(jq -r ".environments.\"$ENV\".reload" config.json)

echo "🔌 Uvicorn on $HOST:$PORT (env=$ENV, reload=$RELOAD)"
exec uvicorn app.main:app --host "$HOST" --port "$PORT" $( [ "$RELOAD" = "true" ] && echo --reload )
SH
chmod +x start_dev.sh

# 7) Create a tiny static Swagger UI client for GH Pages
echo "🌐 Building GH Pages client ..."
mkdir -p site
cat > site/config.js << 'JS'
window.APP_CONFIG = {
  API_BASE: "{{API_BASE}}",        // replaced at deploy
  API_KEY: ""                      // optionally hardcode for demo, else leave empty and set in browser console
};
JS

cat > site/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <title>Quantum-API • GUI</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet"
    href="https://unpkg.com/swagger-ui-dist/swagger-ui.css" />
  <style>
    body { margin:0; background:#0b0b0f; color:#eaeaea; }
    .topbar { display:none !important; }
    #header {
      padding:16px 20px; font-family: ui-sans-serif, system-ui;
      background: #0f1115; border-bottom: 1px solid #222;
      display:flex; gap:10px; align-items:center; flex-wrap: wrap;
    }
    input, button, select {
      background:#0f1115; color:#eaeaea; border:1px solid #333; border-radius:10px; padding:8px 10px;
    }
    button { cursor:pointer; }
  </style>
</head>
<body>
  <div id="header">
    <strong>Quantum-API GUI</strong>
    <label>API Base:
      <input id="apiBase" size="40" />
    </label>
    <label>API Key:
      <input id="apiKey" size="30" placeholder="X-API-Key" />
    </label>
    <button id="apply">Apply</button>
    <a id="docsLink" target="_blank" style="margin-left:auto; color:#9bd;">Open FastAPI /docs</a>
  </div>
  <div id="swagger"></div>

  <script src="config.js"></script>
  <script src="https://unpkg.com/swagger-ui-dist/swagger-ui-bundle.js"></script>
  <script>
    const state = {
      apiBase: window.APP_CONFIG.API_BASE || "",
      apiKey: window.APP_CONFIG.API_KEY || ""
    };
    const apiBaseInput = document.getElementById('apiBase');
    const apiKeyInput  = document.getElementById('apiKey');
    const applyBtn     = document.getElementById('apply');
    const docsLink     = document.getElementById('docsLink');

    function renderSwagger() {
      docsLink.href = state.apiBase + "/docs";
      window.ui = SwaggerUIBundle({
        url: state.apiBase + "/openapi.json",
        dom_id: '#swagger',
        requestInterceptor: (req) => {
          if (state.apiKey) {
            req.headers['X-API-Key'] = state.apiKey;
          }
          return req;
        }
      });
    }

    function load() {
      apiBaseInput.value = state.apiBase;
      apiKeyInput.value = state.apiKey;
      renderSwagger();
    }

    applyBtn.onclick = () => {
      state.apiBase = apiBaseInput.value.trim();
      state.apiKey  = apiKeyInput.value.trim();
      renderSwagger();
    };

    load();
  </script>
</body>
</html>
HTML

# 8) Local deploy script to build GUI to gh-pages
echo "🚀 Writing deploy_gui.sh ..."
cat > deploy_gui.sh << 'SH'
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

export $(grep -v '^#' .env | xargs -d '\n' -I {} echo {}) >/dev/null 2>&1 || true
ENV="${APP_ENV:-development}"

API_BASE=$(jq -r ".environments.\"$ENV\".api_base_url" config.json)

mkdir -p docs
# If redocly exists, produce pretty Redoc docs; else fallback to a simple copy
if command -v redocly >/dev/null 2>&1; then
  echo "📄 Fetching OpenAPI and building Redoc..."
  curl -sS "$API_BASE/openapi.json" -o openapi.json
  redocly build-docs openapi.json --output=docs/index.html
else
  echo "ℹ️ redocly not available; generating a basic docs index that points to Swagger via site client."
  echo "<!doctype html><meta http-equiv='refresh' content='0; url=../site/index.html'>" > docs/index.html
fi

# prepare site/config.js with current API_BASE
sed "s|{{API_BASE}}|$API_BASE|g" site/config.js > site/config.gen.js && mv site/config.gen.js site/config.js

# commit to gh-pages branch
TMPDIR=$(mktemp -d)
cp -r site "$TMPDIR/site"
cp -r docs "$TMPDIR/docs"

# Use worktree for clean gh-pages updates
if ! git rev-parse --verify gh-pages >/dev/null 2>&1; then
  git checkout --orphan gh-pages
  git reset --hard
  echo "<!doctype html><meta http-equiv='refresh' content='0; url=site/index.html'>" > index.html
  git add index.html
  git commit -m "bootstrap gh-pages"
  git push origin gh-pages
  git checkout -
fi

git worktree add -f .gh-pages gh-pages
rsync -a --delete "$TMPDIR/site/" .gh-pages/site/
rsync -a --delete "$TMPDIR/docs/" .gh-pages/docs/
cd .gh-pages
git add -A
git commit -m "Deploy GUI & docs"
git push origin gh-pages
cd ..
git worktree remove .gh-pages --force
rm -rf "$TMPDIR"

echo "✅ Deployed to: https://subatomicERROR.github.io/Quantum-API/site/"
echo "✅ Redoc (if built): https://subatomicERROR.github.io/Quantum-API/docs/"
SH
chmod +x deploy_gui.sh

# 9) GitHub Actions for auto deploy on push to main (static client only)
echo "🤖 Writing GitHub Actions workflow ..."
mkdir -p .github/workflows
cat > .github/workflows/deploy-gh-pages.yml << 'YML'
name: Deploy GH Pages (client)
on:
  push:
    branches: [ main ]
permissions:
  contents: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Prepare site
        run: |
          mkdir -p site
          if [ ! -f site/index.html ]; then
            echo '<!doctype html><meta http-equiv="refresh" content="0; url=site/index.html">' > index.html
          fi
      - name: Push to gh-pages
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git branch gh-pages || true
          git checkout gh-pages
          git checkout main -- site
          echo '<!doctype html><meta http-equiv="refresh" content="0; url=site/index.html">' > index.html
          git add -A
          git commit -m "Update site" || true
          git push origin gh-pages
YML

# 10) Git attributes to keep pages small
echo "⚙️  Writing .gitattributes ..."
cat > .gitattributes << 'GA'
*.png binary
*.jpg binary
*.webp binary
*.pdf binary
GA

echo "🧹 Creating .gitignore entries ..."
grep -qxF "qapi_env/" .gitignore || echo "qapi_env/" >> .gitignore
grep -qxF "__pycache__/" .gitignore || echo "__pycache__/" >> .gitignore
grep -qxF ".gh-pages/" .gitignore || echo ".gh-pages/" >> .gitignore
grep -qxF "openapi.json" .gitignore || echo "openapi.json" >> .gitignore

# 11) Final commit
echo "💾 Committing changes ..."
git add -A
git commit -m "hyper-setup: config, security, GUI, deploy tooling" || true

echo ""
echo "🎉 All set!"
echo "Next steps:"
echo "1) Run API:    source qapi_env/bin/activate && ./start_dev.sh"
echo "2) Deploy GUI: ./deploy_gui.sh"
echo "   - Visit GUI: https://subatomicERROR.github.io/Quantum-API/site/"
echo "   - Redoc:     https://subatomicERROR.github.io/Quantum-API/docs/ (if built)"
