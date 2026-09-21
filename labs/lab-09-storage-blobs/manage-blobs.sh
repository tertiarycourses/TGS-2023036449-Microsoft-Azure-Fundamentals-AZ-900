#!/usr/bin/env bash
# Lab 9 — upload, list and download blobs with the Azure CLI.
# Usage (in Cloud Shell):  bash manage-blobs.sh <your-storage-account-name>
#   e.g. bash manage-blobs.sh staz900abc1234
set -euo pipefail

RG="rg-az900-labs"
CONTAINER="labfiles"
ACCOUNT="${1:-}"

if [[ -z "$ACCOUNT" ]]; then
  echo "Usage: bash manage-blobs.sh <your-storage-account-name>"
  echo "  Find it with: az storage account list -g $RG --query '[].name' -o tsv"
  exit 1
fi

echo "== Creating a sample file =="
echo "AZ-900 Lab 9 - uploaded $(date -u +%Y-%m-%dT%H:%M:%SZ)" > az900-sample.txt
cat az900-sample.txt

echo
echo "== Uploading to container '$CONTAINER' (Entra ID auth) =="
# --auth-mode login uses your signed-in identity + RBAC, not the account keys.
az storage blob upload \
  --account-name "$ACCOUNT" \
  --container-name "$CONTAINER" \
  --name az900-sample.txt \
  --file az900-sample.txt \
  --auth-mode login \
  --overwrite \
  -o none

echo "== Blobs in '$CONTAINER' =="
az storage blob list \
  --account-name "$ACCOUNT" \
  --container-name "$CONTAINER" \
  --auth-mode login \
  --query "[].{Name:name, Tier:properties.blobTier, Size:properties.contentLength}" \
  -o table

echo
echo "== Downloading it back as az900-downloaded.txt =="
az storage blob download \
  --account-name "$ACCOUNT" \
  --container-name "$CONTAINER" \
  --name az900-sample.txt \
  --file az900-downloaded.txt \
  --auth-mode login \
  -o none
cat az900-downloaded.txt

echo
echo "Tip: if 'auth-mode login' is denied, you need the 'Storage Blob Data Contributor'"
echo "role on the account — RBAC on the data plane is separate from the control plane."
