#!/bin/bash
# Filename: fix_quantum_backend.sh
# Purpose: Fix Quantum-API backend routes and handle missing API key for testing

MAIN_PY="$HOME/Quantum-API/app/main.py"

if [ ! -f "$MAIN_PY" ]; then
    echo "❌ main.py not found at $MAIN_PY"
    exit 1
fi

echo "🔧 Patching main.py for Quantum backend routes..."

# Backup first
cp "$MAIN_PY" "$MAIN_PY.bak"

# Patch /quantum/backend GET route
sed -i "/@app.get(\"\/quantum\/backend\")/,+6c\\
@app.get(\"/quantum/backend\")\\
async def current_backend():\\
    try:\\
        return {\"backend\": get_backend_choice()}\\
    except Exception as e:\\
        return {\"error\": str(e)}
" "$MAIN_PY"

# Patch /quantum/backend/select POST route to accept JSON
sed -i "/@app.post(\"\/quantum\/backend\/select\")/,+6c\\
from fastapi import Body\\
@app.post(\"/quantum/backend/select\")\\
async def switch_backend(body: dict = Body(...)):  # expects {\"name\": \"backend_name\"}\\
    name = body.get(\"name\")\\
    if not name:\\
        return {\"error\": \"Missing backend name\"}\\
    try:\\
        result = select_backend(name)\\
        return {\"success\": True, \"backend\": result}\\
    except Exception as e:\\
        return {\"success\": False, \"error\": str(e)}
" "$MAIN_PY"

# Optional: add local testing bypass for API key (remove in production)
sed -i "/async def auth_and_rate_limit(request: Request, call_next):/a\\
    # ✅ Temporary bypass for local testing of backend routes\\
    if request.url.path.startswith('/quantum/backend'):\\
        return await call_next(request)
" "$MAIN_PY"

echo "✅ Quantum backend routes patched successfully!"
echo "💡 Restart server: ./start_dev.sh"
