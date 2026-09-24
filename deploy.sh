#!/bin/zsh
set -euo pipefail

# Build and deploy Alexandria's Notes digital garden.
#
# Preview is the default. Production requires --prod, because every production
# deploy is retained by Vercel permanently at ~100 MB and the Hobby plan's
# 10 GB limit therefore holds only about 100 of them, lifetime.

VAULT_PATH="/Users/alexandriarohn/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes-vault"

if [[ "${1:-}" == "--prod" ]]; then
  echo "Building Quartz from vault..."
  npx quartz build --directory "$VAULT_PATH"

  echo "Deploying to production..."
  vercel --prod --yes

  echo "Done! Reclaim old deploys with: vercel rm alexandriathylane-notes --safe"
else
  echo "Preview at http://localhost:8080 — pass --prod to deploy for real."
  npx quartz build --serve --directory "$VAULT_PATH"
fi
