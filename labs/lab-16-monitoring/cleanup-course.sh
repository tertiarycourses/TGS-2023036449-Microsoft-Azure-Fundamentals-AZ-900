#!/usr/bin/env bash
# Lab 16 — FULL COURSE CLEAN-UP.
#
# WARNING: this deletes the resource group 'rg-az900-labs' and EVERYTHING in it.
# Run this only at the very end of the course. It asks for confirmation first.
#
# Run in Azure Cloud Shell (Bash):  bash cleanup-course.sh
set -euo pipefail

RG="rg-az900-labs"
LOCK="lock-az900-nodelete"

if ! az group exists --name "$RG" | grep -q true; then
  echo "Resource group '$RG' does not exist — nothing to clean up."
  exit 0
fi

echo "== Resources that will be DELETED from '$RG' =="
az resource list --resource-group "$RG" -o table
echo

read -r -p "Type the resource group name to confirm deletion: " CONFIRM
if [[ "$CONFIRM" != "$RG" ]]; then
  echo "Confirmation did not match — nothing was deleted."
  exit 1
fi

echo
echo "== Removing any resource locks (a lock blocks deletion) =="
az lock list --resource-group "$RG" -o table
az lock delete --name "$LOCK" --resource-group "$RG" -o none 2>/dev/null || true

echo "== Deleting resource group '$RG' =="
az group delete --name "$RG" --yes --no-wait

echo
echo "Deletion started in the background (it takes a few minutes)."
echo "Check progress with:  az group exists --name $RG"
echo
echo "Reminder — these are NOT in the resource group and must be removed separately:"
echo "  * Entra ID user/group from Lab 11:"
echo "      az ad user delete --id az900.learner@<yourtenant>.onmicrosoft.com"
echo "      az ad group delete --group grp-az900-learners"
echo "  * Budget from Lab 15 (portal: Cost Management > Budgets)"
echo "  * Cloud Shell storage account 'cloud-shell-storage-southeastasia' (optional, costs cents/month)"
