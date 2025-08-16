#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Fixing GitHub Pages deployment from $(pwd)"

# 0) Sanity
if [ ! -d .git ]; then
  echo "❌ Not a git repo. Run inside ~/Quantum-API"; exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq required. Run: sudo apt-get update && sudo apt-get install -y jq"; exit 1
fi

# 1) Ensure GH Pages can call local API (CORS allow github.io in dev)
echo "🛡  Patching CORS for development to allow GH Pages origin..."
tmpcfg=$(mktemp)
jq '
  .environments.development.cors_origins += ["https://subatomicERROR.github.io"] |
  .environments.staging.cors_origins     += ["https://subatomicERROR.github.io"] |
  .environments.production.cors_origins  += ["https://subatomicERROR.github.io"]
' config.json > "$tmpcfg" && mv "$tmpcfg" config.json

# 2) Make GUI’s API_BASE default to empty (so you can type it on the page)
#    This replaces the template token {{API_BASE}} with an empty string if still present.
if grep -q "{{API_BASE}}" site/config.js 2>/dev/null; then
  echo "🧼 Cleaning placeholder in site/config.js ..."
  sed -i 's/{{API_BASE}}//' site/config.js
fi

# 3) Ensure docs minimal redirect exists (if Redoc not generated yet)
mkdir -p docs
if [ ! -f docs/index.html ]; then
  echo "ℹ️ Creating minimal docs index redirect → /site/"
  echo '<!doctype html><meta http-equiv="refresh" content="0; url=../site/index.html">' > docs/index.html
fi

# 4) Create GitHub Pages workflow (Actions → Pages)
echo "🤖 Writing .github/workflows/pages.yml ..."
mkdir -p .github/workflows
cat > .github/workflows/pages.yml <<'YML'
name: Deploy GitHub Pages
on:
  push:
    branches: [ main ]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - name: Build static site (site + docs)
        run: |
          rm -rf public
          mkdir -p public
          # root = site
          if [ -d site ]; then cp -r site/* public/; fi
          # docs under /docs
          if [ -d docs ]; then mkdir -p public/docs && cp -r docs/* public/docs/; fi
          # root fallback if index is missing
          if [ ! -f public/index.html ]; then
            printf '<!doctype html><meta http-equiv="refresh" content="0; url=./index.html">' > public/index.html
          fi
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: public
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
YML

# 5) Commit + push
git add -A
git commit -m "fix(pages): enable GitHub Pages via Actions, CORS + GUI base" || true
git push

echo "✅ Workflow pushed. GitHub Actions will publish your site."
echo "➡  Open: https://github.com/subatomicERROR/Quantum-API/actions"
echo "   Run 'Deploy GitHub Pages' if it’s not already running."
echo "🌍 When it finishes, visit: https://subatomicERROR.github.io/Quantum-API/"
echo ""
echo "ℹ️ Tip: In the GUI, set API Base to your running API (e.g. http://127.0.0.1:8000) and X-API-Key from .env"
