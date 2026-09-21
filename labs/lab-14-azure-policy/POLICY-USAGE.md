# Lab 14 — using the policy files from Cloud Shell

The portal steps in the lab do the same thing through the UI. These files let you
do it as code — upload both JSON files to Cloud Shell (or `cd` to this folder) first.

## 1. Assign the built-in "Allowed locations" policy

`allowed-locations-policy.json` is a **parameters** file: it lists the only regions
that resources may be created in.

```bash
az policy assignment create \
  --name allowed-locations-az900 \
  --display-name "Allowed locations (AZ-900 lab)" \
  --resource-group rg-az900-labs \
  --policy e56962a6-4747-49cd-b67b-bf8b01975c4c \
  --params @allowed-locations-policy.json
```

`e56962a6-4747-49cd-b67b-bf8b01975c4c` is the well-known ID of the built-in
*Allowed locations* policy definition.

### Test that it denies

```bash
az storage account create -g rg-az900-labs -n staz900deny$RANDOM -l westus --sku Standard_LRS
```

This **must fail** with `RequestDisallowedByPolicy` — `westus` is not in the allowed
list. Repeat with `-l southeastasia` and it succeeds. That is Azure Policy enforcing a
guardrail *before* the resource is ever created.

### Remove the assignment

```bash
az policy assignment delete --name allowed-locations-az900 --resource-group rg-az900-labs
```

## 2. (Stretch) Create a custom "require a tag" policy

`require-tag-policy.json` is a **policy rule**: deny any resource that has no
`course` tag.

```bash
az policy definition create \
  --name require-course-tag \
  --display-name "Require a course tag on all resources" \
  --mode Indexed \
  --rules @require-tag-policy.json

az policy assignment create \
  --name require-course-tag-az900 \
  --resource-group rg-az900-labs \
  --policy require-course-tag
```

Clean up in this order — the assignment must go before the definition:

```bash
az policy assignment delete --name require-course-tag-az900 --resource-group rg-az900-labs
az policy definition delete --name require-course-tag
```

## Check what is assigned

```bash
az policy assignment list --resource-group rg-az900-labs -o table
```
