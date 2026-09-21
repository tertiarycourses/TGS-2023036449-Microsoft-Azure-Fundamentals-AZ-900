#!/usr/bin/env bash
# Lab 5 — delete the VM and the leftover NIC, public IP, NSG and disk.
# Deleting a VM does NOT delete its dependent resources: this removes them all.
# Run in Azure Cloud Shell (Bash):  bash cleanup-linux-vm.sh
set -euo pipefail

RG="rg-az900-labs"
VM="vm-az900-linux01"

echo "== Deleting VM '$VM' =="
az vm delete --resource-group "$RG" --name "$VM" --yes -o none || true

echo "== Deleting dependent resources =="
az network nic delete -g "$RG" -n "${VM}VMNic" -o none || true
az network public-ip delete -g "$RG" -n "${VM}PublicIP" -o none || true
az network nsg delete -g "$RG" -n "${VM}NSG" -o none || true

az disk list -g "$RG" --query "[?contains(name,'linux01')].name" -o tsv \
  | xargs -r -I{} az disk delete -g "$RG" -n {} --yes -o none || true

echo
echo "== Remaining resources in '$RG' =="
az resource list --resource-group "$RG" -o table
echo
echo "Keep the resource group '$RG' — later labs reuse it."
