#!/usr/bin/env bash
# Lab 8 — build a VNet with two subnets and one VM in each.
# vm-az900-web has a public IP; vm-az900-db is private-only.
# Run in Azure Cloud Shell (Bash):  bash deploy-vnet.sh
set -euo pipefail

RG="rg-az900-labs"
LOCATION="southeastasia"
VNET="vnet-az900"

az group create --name "$RG" --location "$LOCATION" --tags course=az900 -o none

echo "== Creating VNet '$VNET' (10.0.0.0/16) with subnet-web (10.0.1.0/24) =="
az network vnet create \
  --resource-group "$RG" \
  --name "$VNET" \
  --address-prefix 10.0.0.0/16 \
  --subnet-name subnet-web \
  --subnet-prefix 10.0.1.0/24 \
  -o none

echo "== Adding subnet-db (10.0.2.0/24) =="
az network vnet subnet create \
  --resource-group "$RG" \
  --vnet-name "$VNET" \
  --name subnet-db \
  --address-prefix 10.0.2.0/24 \
  -o none

echo "== Creating vm-az900-web in subnet-web (public IP) =="
az vm create \
  --resource-group "$RG" \
  --name vm-az900-web \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --vnet-name "$VNET" \
  --subnet subnet-web \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard \
  -o none

echo "== Creating vm-az900-db in subnet-db (no public IP) =="
az vm create \
  --resource-group "$RG" \
  --name vm-az900-db \
  --image Ubuntu2204 \
  --size Standard_B1s \
  --vnet-name "$VNET" \
  --subnet subnet-db \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-address "" \
  -o none

echo
echo "== Private IP addresses =="
az vm list-ip-addresses -g "$RG" -o table

WEB_IP=$(az vm list-ip-addresses -g "$RG" -n vm-az900-web \
  --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)
DB_IP=$(az vm list-ip-addresses -g "$RG" -n vm-az900-db \
  --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)

echo
echo "Jump into the web VM:   ssh azureuser@$WEB_IP"
echo "From there, reach the private DB VM:   ping -c 4 $DB_IP"
echo "(The DB VM has no public IP — it is only reachable from inside the VNet.)"
