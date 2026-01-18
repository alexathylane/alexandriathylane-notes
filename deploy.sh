#!/bin/zsh

# Build and deploy Alexandria's Notes digital garden

VAULT_PATH="/Users/alexandriarohn/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes-vault"

echo "Building Quartz from vault..."
npx quartz build --directory "$VAULT_PATH"

echo "Deploying to Vercel..."
vercel --prod --yes

echo "Done!"
