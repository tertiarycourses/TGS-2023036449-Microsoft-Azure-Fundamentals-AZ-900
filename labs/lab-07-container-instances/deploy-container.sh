#!/usr/bin/env bash
# Lab 7 — run a public container image on Azure Container Instances.
# Usage (in Cloud Shell):  bash deploy-container.sh <unique-dns-label>
#   e.g. bash deploy-container.sh az900-abc1234
set -euo pipefail

RG="rg-az900-labs"
LOCATION="southeastasia"
NAME="aci-az900-hello"
DNS="${1:-}"

if [[ -z "$DNS" ]]; then
  echo "Usage: bash deploy-container.sh <unique-dns-label>"
  echo "  The label must be globally unique, e.g. az900-abc1234"
  exit 1
fi

az group create --name "$RG" --location "$LOCATION" --tags course=az900 -o none

echo "== Creating container group '$NAME' =="
az container create \
  --resource-group "$RG" \
  --name "$NAME" \
  --image mcr.microsoft.com/azuredocs/aci-helloworld \
  --dns-name-label "$DNS" \
  --ports 80 \
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
  -o none

FQDN=$(az container show -g "$RG" -n "$NAME" --query ipAddress.fqdn -o tsv)
STATE=$(az container show -g "$RG" -n "$NAME" --query instanceView.state -o tsv)

echo
echo "Container state : $STATE"
echo "Browse to       : http://$FQDN"
echo
echo "View logs with  : az container logs -g $RG -n $NAME"
echo "Delete with     : az container delete -g $RG -n $NAME --yes"
