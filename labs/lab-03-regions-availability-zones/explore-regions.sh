#!/usr/bin/env bash
# Lab 3 — explore Azure regions, region pairs and availability zones.
# Run in Azure Cloud Shell (Bash):  bash explore-regions.sh
set -euo pipefail

REGION="${1:-southeastasia}"

echo "== All physical regions (first 25) =="
az account list-locations --query "[?metadata.regionType=='Physical'].name" -o tsv | head -25

echo
echo "== Recommended regions and their paired region =="
az account list-locations \
  --query "[?metadata.regionCategory=='Recommended'].{Region:displayName, Name:name, Pair:metadata.pairedRegion[0].name}" \
  -o table

echo
echo "== Region pair for '$REGION' =="
az account list-locations \
  --query "[?name=='$REGION'].{Region:displayName, PairedWith:metadata.pairedRegion[0].name}" \
  -o table

echo
echo "== Availability zones for B-series VM sizes in '$REGION' =="
az vm list-skus --location "$REGION" --zone --size Standard_B --output table

echo
echo "Note: a region showing zones 1/2/3 supports zone-redundant deployments."
