#!/usr/bin/env bash
# Lab 13 — apply governance tags and a CanNotDelete lock to the lab resource group.
# Run in Azure Cloud Shell (Bash):  bash apply-tags-locks.sh
set -euo pipefail

RG="rg-az900-labs"
LOCK="lock-az900-nodelete"

echo "== Applying tags =="
# --set merges a single tag; it does not replace the whole tag set.
az group update --name "$RG" --set tags.project=az900-course -o none
az group update --name "$RG" --set tags.owner=training      -o none
az group update --name "$RG" --set tags.env=lab             -o none

az group show --name "$RG" --query tags -o json

echo
echo "== Applying CanNotDelete lock '$LOCK' =="
az lock create \
  --name "$LOCK" \
  --resource-group "$RG" \
  --lock-type CanNotDelete \
  --notes "AZ-900 lab - prevents accidental deletion" \
  -o none

az lock list --resource-group "$RG" -o table

echo
echo "The group is now protected. Try deleting it in the portal — Azure will refuse."
echo "Remove the lock with:  az lock delete --name $LOCK --resource-group $RG"
