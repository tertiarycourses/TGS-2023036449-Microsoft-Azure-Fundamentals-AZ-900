#!/usr/bin/env bash
# Lab 12 — inspect the role assignments you created in the portal.
# Run in Azure Cloud Shell (Bash):  bash check-rbac.sh
set -euo pipefail

RG="rg-az900-labs"
SCOPE=$(az group show --name "$RG" --query id -o tsv)

echo "== Role assignments scoped to '$RG' =="
az role assignment list \
  --resource-group "$RG" \
  --query "[].{Principal:principalName, Role:roleDefinitionName, Scope:scope}" \
  -o table

echo
echo "== Assignments INHERITED from the subscription =="
az role assignment list \
  --scope "$SCOPE" \
  --include-inherited \
  --query "[?scope!='$SCOPE'].{Principal:principalName, Role:roleDefinitionName, InheritedFrom:scope}" \
  -o table

echo
echo "== What the 'Reader' role actually permits =="
az role definition list --name Reader \
  --query "[0].permissions[0].{Actions:actions, NotActions:notActions}" -o json

echo
echo "== A few common built-in roles =="
az role definition list \
  --query "[?roleName=='Owner' || roleName=='Contributor' || roleName=='Reader' || roleName=='User Access Administrator'].{Role:roleName, Description:description}" \
  -o table

echo
echo "Key idea: RBAC assignments inherit DOWN the scope hierarchy"
echo "(management group > subscription > resource group > resource)."
