#!/bin/bash
# upgrade_uiux.sh
# 🔧 Upgrade Quantum-API Landing Page UI/UX with interactive bio-neural-network background

MAIN_PY="$HOME/Quantum-API/app/main.py"
BACKUP_PY="$HOME/Quantum-API/app/main.py.bak"

echo "🔧 Backing up current main.py..."
if [ -f "$MAIN_PY" ]; then
    cp "$MAIN_PY" "$BACKUP_PY"
    echo "✅ Backup created at main.py.bak"
else
    echo "⚠️ main.py not found! Make sure you are in the correct folder."
    exit 1
fi

echo "🚀 Writing upgraded main.py with professional UI/UX..."

cat > "$MAIN_PY" << 'EOF'
import os
from fastapi import FastAPI, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse

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

# --- CORS Middleware ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings["cors_origins"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- API Key middleware ---
@app.middleware("http")
async def auth_and_rate_limit(request: Request, call_next):
    api_key = request.headers.get("x-api-key") or os.environ.get("QUANTUM_API_KEY")
    if not api_key:
        raise HTTPException(status_code=401, detail="Missing API key")
    await require_api_key(request, override_key=api_key)
    return await call_next(request)

# --- Professional Landing Page ---
@app.get("/", response_class=HTMLResponse)
def landing_page():
    return f"""
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quantum-API | Hyper-Intelligent Backend</title>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');

            html, body {{
                margin: 0;
                padding: 0;
                height: 100%;
                width: 100%;
                font-family: 'Roboto', sans-serif;
                overflow: hidden;
                background: #0b0c10;
                color: #c5c6c7;
            }}

            canvas {{
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 0;
            }}

            .container {{
                position: relative;
                z-index: 1;
                height: 100%;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                text-align: center;
                color: #66fcf1;
            }}

            h1 {{
                font-size: 4em;
                margin: 0;
                letter-spacing: 2px;
            }}

            p {{
                font-size: 1.5em;
                color: #45a29e;
            }}

            a {{
                display: inline-block;
                margin-top: 2em;
                padding: 1em 2em;
                font-size: 1.2em;
                color: #0b0c10;
                background: #66fcf1;
                border-radius: 10px;
                text-decoration: none;
                transition: 0.3s ease;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            }}

            a:hover {{
                background: #45a29e;
                color: #fff;
                transform: translateY(-2px);
            }}
        </style>
    </head>
    <body>
        <canvas id="network"></canvas>
        <div class="container">
            <h1>Quantum-API</h1>
            <p>Hyper-Intelligent Quantum Backend</p>
            <p>Environment: {env}</p>
            <a href="/docs">Explore API Docs</a>
        </div>
        <script>
            const canvas = document.getElementById('network');
            const ctx = canvas.getContext('2d');
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;

            const nodes = [];
            const nodeCount = 80;

            for(let i=0;i<nodeCount;i++){{
                nodes.push({{
                    x: Math.random()*canvas.width,
                    y: Math.random()*canvas.height,
                    vx: (Math.random()-0.5)*0.7,
                    vy: (Math.random()-0.5)*0.7,
                    radius: Math.random()*2+1
                }});
            }}

            function connectNodes() {{
                for(let i=0;i<nodes.length;i++){{
                    for(let j=i+1;j<nodes.length;j++){{
                        const dx = nodes[i].x-nodes[j].x;
                        const dy = nodes[i].y-nodes[j].y;
                        const dist = Math.sqrt(dx*dx+dy*dy);
                        if(dist<150){{
                            ctx.beginPath();
                            ctx.strokeStyle='rgba(102,252,241,'+(1-dist/150)+')';
                            ctx.moveTo(nodes[i].x,nodes[i].y);
                            ctx.lineTo(nodes[j].x,nodes[j].y);
                            ctx.stroke();
                        }}
                    }}
                }}
            }}

            function animate(){{
                ctx.clearRect(0,0,canvas.width,canvas.height);
                nodes.forEach(n=>{{
                    n.x+=n.vx;
                    n.y+=n.vy;
                    if(n.x<0||n.x>canvas.width) n.vx*=-1;
                    if(n.y<0||n.y>canvas.height) n.vy*=-1;
                    ctx.beginPath();
                    ctx.arc(n.x,n.y,n.radius,0,Math.PI*2);
                    ctx.fillStyle='#66fcf1';
                    ctx.fill();
                }});
                connectNodes();
                requestAnimationFrame(animate);
            }}
            animate();

            window.addEventListener('mousemove', e => {{
                nodes.forEach(n=>{{
                    const dx = n.x - e.clientX;
                    const dy = n.y - e.clientY;
                    const dist = Math.sqrt(dx*dx+dy*dy);
                    if(dist < 100){{
                        n.vx += dx*0.0005;
                        n.vy += dy*0.0005;
                    }}
                }});
            }});

            window.addEventListener('resize', ()=>{{
                canvas.width=window.innerWidth;
                canvas.height=window.innerHeight;
            }});
        </script>
    </body>
    </html>
    """

# --- Quantum backend routes ---
@app.get("/quantum/backend")
def current_backend():
    return get_backend_choice()

@app.post("/quantum/backend/select")
def switch_backend(name: str):
    return select_backend(name)

# --- Health & other routers ---
app.include_router(health_router)
EOF

echo "✅ main.py upgraded with professional UI/UX and live bio-neural-network background."
echo "💡 Restart server: ./start_dev.sh"
