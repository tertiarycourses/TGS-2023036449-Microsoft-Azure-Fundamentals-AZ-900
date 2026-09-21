#!/usr/bin/env bash
# Lab 2 — verify your Cloud Shell environment is ready for the AZ-900 labs.
# Run in Azure Cloud Shell (Bash):  bash verify-setup.sh
set -euo pipefail

RG="rg-az900-labs"
LOCATION="southeastasia"

echo "== Azure CLI version =="
az version --query '"azure-cli"' -o tsv

echo
echo "== Signed-in subscription =="
az account show --query "{Subscription:name, Id:id, User:user.name}" -o table

echo
echo "== Ensuring resource group '$RG' exists in '$LOCATION' =="
# ARM is idempotent: safe to re-run on an existing group.
az group create --name "$RG" --location "$LOCATION" --tags course=az900 -o none
az group show --name "$RG" -o table

echo
echo "== Resources currently in '$RG' =="
az resource list --resource-group "$RG" -o table

echo
echo "Environment OK — you are ready for the remaining labs."
