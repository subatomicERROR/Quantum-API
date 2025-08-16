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
