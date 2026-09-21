#!/usr/bin/env bash
# Lab 5 — create an Ubuntu VM with the Azure CLI, open port 80 and report its IP.
# Run in Azure Cloud Shell (Bash):  bash deploy-linux-vm.sh
set -euo pipefail

RG="rg-az900-labs"
LOCATION="southeastasia"
VM="vm-az900-linux01"

az group create --name "$RG" --location "$LOCATION" --tags course=az900 -o none

echo "== Creating VM '$VM' (takes 1-3 minutes) =="
az vm create \
  --resource-group "$RG" \
  --name "$VM" \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys \
  -o none

echo "== Opening port 80 =="
az vm open-port --resource-group "$RG" --name "$VM" --port 80 -o none

IP=$(az vm list-ip-addresses -g "$RG" -n "$VM" \
  --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)

echo
echo "VM '$VM' is ready."
echo "  Public IP : $IP"
echo "  Power     : $(az vm show -g "$RG" -n "$VM" --show-details --query powerState -o tsv)"
echo
echo "Connect with:   ssh azureuser@$IP"
echo "Then install a web server:   sudo apt update && sudo apt install -y nginx"
echo "Finally browse to:   http://$IP"
