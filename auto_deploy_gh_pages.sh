#!/bin/bash
# auto_deploy_gh_pages.sh
# Hyper-intelligent full automation for React build + GitHub Pages deployment

set -e

# === 1️⃣ Ensure we are in the repo root ===
REPO_DIR=~/Quantum-API
cd "$REPO_DIR"

# === 2️⃣ Update React homepage automatically ===
CLIENT_DIR="$REPO_DIR/client"
GITHUB_USER="subatomicERROR"
REPO_NAME="Quantum-API"
HOMEPAGE_URL="https://$GITHUB_USER.github.io/$REPO_NAME"

echo "🔹 Setting React homepage to $HOMEPAGE_URL..."
jq --arg homepage "$HOMEPAGE_URL" '.homepage = $homepage' "$CLIENT_DIR/package.json" > tmp.json && mv tmp.json "$CLIENT_DIR/package.json"

# === 3️⃣ Build React app ===
echo "🔹 Building React app..."
cd "$CLIENT_DIR"
npm install
npm run build

# === 4️⃣ Move build to docs folder ===
echo "🔹 Updating docs/ folder..."
cd "$REPO_DIR"
rm -rf docs
mv client/build docs

# === 5️⃣ Stage changes for GitHub ===
echo "🔹 Staging docs/ folder and other scripts..."
git add docs/ app/main.py start_dev.sh app/main.py.bak fix_quantum_backend.sh upgrade_uiux.sh auto_deploy_gh_pages.sh

# === 6️⃣ Commit changes ===
read -p "Enter commit message for deployment: " COMMIT_MSG
git commit -m "$COMMIT_MSG"

# === 7️⃣ Pull latest changes to avoid conflicts ===
echo "🔹 Pulling latest changes from GitHub..."
git pull origin main --rebase

# === 8️⃣ Push to GitHub ===
echo "🔹 Pushing docs/ and repo changes to GitHub..."
git push origin main

# === 9️⃣ Done & Open GitHub Pages ===
echo "✅ Deployment complete!"
echo "Your GitHub Pages URL: $HOMEPAGE_URL"

read -p "Open in browser now? (y/n) " OPEN_BROWSER
if [ "$OPEN_BROWSER" == "y" ] || [ "$OPEN_BROWSER" == "Y" ]; then
    xdg-open "$HOMEPAGE_URL" || echo "Please open manually: $HOMEPAGE_URL"
fi
