#!/usr/bin/env bash
# Lab 1 — confirm the resource group you created in the portal exists and is tagged.
# Optional: the lab itself is done entirely in the portal. Run this in Cloud Shell
# afterwards to verify your work.
#   bash verify-lab01.sh
set -euo pipefail

RG="rg-az900-labs"

if ! az group exists --name "$RG" | grep -q true; then
  echo "FAIL: resource group '$RG' not found."
  echo "Go back to the portal and create it in region 'Southeast Asia'."
  exit 1
fi

echo "PASS: resource group '$RG' exists."
az group show --name "$RG" --query "{Name:name, Location:location, State:properties.provisioningState, Tags:tags}" -o json

LOC=$(az group show --name "$RG" --query location -o tsv)
[[ "$LOC" == "southeastasia" ]] \
  && echo "PASS: location is southeastasia." \
  || echo "NOTE: location is '$LOC' (the labs assume southeastasia)."

TAG=$(az group show --name "$RG" --query "tags.course" -o tsv 2>/dev/null || true)
[[ "$TAG" == "az900" ]] \
  && echo "PASS: tag course=az900 is set." \
  || echo "NOTE: tag course=az900 not set — add it in the portal under Tags."
