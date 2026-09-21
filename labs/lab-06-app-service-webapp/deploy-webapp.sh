#!/usr/bin/env bash
# Lab 6 — zip-deploy index.html to your App Service web app.
# Usage (in Cloud Shell, from this folder):
#   bash deploy-webapp.sh app-az900-abc1234
set -euo pipefail

RG="rg-az900-labs"
APP="${1:-}"

if [[ -z "$APP" ]]; then
  echo "Usage: bash deploy-webapp.sh <your-web-app-name>"
  echo "  e.g. bash deploy-webapp.sh app-az900-abc1234"
  exit 1
fi

echo "== Packaging site =="
rm -f site.zip
zip -q site.zip index.html

echo "== Deploying to '$APP' =="
az webapp deploy \
  --resource-group "$RG" \
  --name "$APP" \
  --src-path site.zip \
  --type zip \
  -o none

URL=$(az webapp show -g "$RG" -n "$APP" --query defaultHostName -o tsv)
echo
echo "Deployed. Browse to:  https://$URL"
