#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_URL="https://github.com/subatomicERROR/Quantum-API.git"
REMOTE_NAME="origin"
BRANCH="main"

echo "1) Cleaning up unwanted files..."
echo "__pycache__/" >> .gitignore
echo "qapi_env/" >> .gitignore
git rm -r --cached __pycache__ qapi_env || true
git add .gitignore
git commit -m "chore: Remove cache and venv, add .gitignore" || true

echo "2) Committing current state..."
git add .
git commit -m "chore: initial commit - quantum API setup"

# Check if remote exists
if git remote get-url $REMOTE_NAME >/dev/null 2>&1; then
  echo "Remote '$REMOTE_NAME' already exists"
else
  echo "Adding remote: $REPO_URL"
  git remote add $REMOTE_NAME "$REPO_URL"
fi

# Push to GitHub
echo "3) Pushing to GitHub ($REMOTE_NAME/$BRANCH)..."
git branch -M $BRANCH
git push -u $REMOTE_NAME $BRANCH

echo "Done! Your project is now pushed to GitHub."
