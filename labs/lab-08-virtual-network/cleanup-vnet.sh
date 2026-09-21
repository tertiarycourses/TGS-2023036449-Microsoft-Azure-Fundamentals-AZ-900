#!/usr/bin/env bash
# Lab 8 — remove both VMs, their NICs/NSGs/public IP/disks, then the VNet.
# Run in Azure Cloud Shell (Bash):  bash cleanup-vnet.sh
set -euo pipefail

RG="rg-az900-labs"

echo "== Deleting VMs =="
az vm delete --resource-group "$RG" --name vm-az900-web --yes -o none || true
az vm delete --resource-group "$RG" --name vm-az900-db  --yes -o none || true

echo "== Deleting NICs, NSGs and public IP =="
az network nic delete -g "$RG" -n vm-az900-webVMNic -o none || true
az network nic delete -g "$RG" -n vm-az900-dbVMNic  -o none || true
az network nsg delete -g "$RG" -n vm-az900-webNSG   -o none || true
az network nsg delete -g "$RG" -n vm-az900-dbNSG    -o none || true
az network public-ip delete -g "$RG" -n vm-az900-webPublicIP -o none || true

echo "== Deleting orphaned disks =="
az disk list -g "$RG" --query "[?contains(name,'az900-web') || contains(name,'az900-db')].name" -o tsv \
  | xargs -r -I{} az disk delete -g "$RG" -n {} --yes -o none || true

echo "== Deleting VNet =="
az network vnet delete --resource-group "$RG" --name vnet-az900 -o none || true

echo
echo "== Remaining resources in '$RG' =="
az resource list --resource-group "$RG" -o table
