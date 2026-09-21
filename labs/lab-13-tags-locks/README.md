# Lab 13 — Apply Resource Tags and Resource Locks

In this lab you organise resources with tags (for ownership, environment and cost reporting) and protect them with resource locks that block accidental deletion — two core Azure governance tools. This maps to the AZ-900 skill area "Describe Azure management and governance" (purpose of tags, and resource locks).

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — Add tags to the resource group

1. Search for **Resource groups**, open **rg-az900-labs** (create it in **Southeast Asia** if missing).
2. In the left menu, click **Tags**.
3. Enter the following name/value pairs, then click **Apply**:

| Name | Value |
|---|---|
| env | training |
| costcenter | az900 |
| owner | `<your name>` |

Tags are simple metadata — Azure never interprets the values, but Cost Management and inventory reports can group and filter by them.

---

## Step 2 — Confirm tags are NOT inherited by resources

1. Still inside **rg-az900-labs**, open the **Overview** blade and click the Lab 9 storage account (`staz900...`).
2. In its left menu, click **Tags** — the list is **empty**.

By default, tags on a resource group do **not** flow down to the resources inside it. Inheritance can only be forced with an Azure Policy (`Inherit a tag from the resource group`) — remember this distinction for the exam.

---

## Step 3 — Tag an individual resource

1. On the storage account's **Tags** blade, add:
   - **Name**: `env`, **Value**: `training`
   - **Name**: `costcenter`, **Value**: `az900`
2. Click **Apply**.

A resource can carry up to 50 tags of its own, independent of its resource group's tags.

---

## Step 4 — Filter All resources by tag

1. Search for **All resources** and open it.
2. Click **+ Add filter**, choose **Filter**: `Tags`, then pick **Tag**: `env` and **Value**: `training`, and click **Apply**.
3. Only the tagged storage account appears (the resource group itself is not a "resource" in this view).

This is how large organisations slice thousands of resources by department, environment or cost centre in seconds.

---

## Step 5 — Manage tags with the Azure CLI

Open Cloud Shell (the `>_` icon, **Bash**) and run:

```bash
az group update --name rg-az900-labs --set tags.project=az900-course
```

`--set tags.<name>=<value>` adds one tag to the resource group without touching the existing ones; the command echoes the group JSON including the full `tags` block.

```bash
az tag list --resource-id $(az group show --name rg-az900-labs --query id -o tsv)
```

`az tag list` reads all tags on any resource ID — here the inner `az group show --query id -o tsv` fetches the resource group's full ID. (Note: `az tag create --resource-id <id> --tags ...` also works, but it **replaces** all existing tags, so `az group update --set` is safer for adding one.)

---

## Step 6 — Add a Delete (CanNotDelete) lock on the resource group

1. Open **rg-az900-labs** > left menu **Settings** > **Locks**.
2. Click **+ Add**:
   - **Lock name**: `lock-az900-nodelete`
   - **Lock type**: `Delete`
   - **Notes**: `AZ-900 lab - prevent accidental deletion`
3. Click **OK**.

A lock at resource-group scope is inherited by **every** resource inside the group — unlike tags, locks do flow down.

---

## Step 7 — Try to delete a locked resource

1. Open the storage account `staz900...` and click **Delete** on its Overview toolbar; type the account name to confirm.
2. The operation fails with an error similar to:
   - `The scope '.../resourceGroups/rg-az900-labs/providers/Microsoft.Storage/storageAccounts/staz900...' cannot perform delete operation because following scope(s) are locked: '/subscriptions/.../resourceGroups/rg-az900-labs'. Please remove the lock and try again.`

Note that this blocked **you, the Owner** — locks apply regardless of RBAC role, which is exactly why they exist: to stop authorised users making accidental changes.

---

## Step 8 — Understand ReadOnly vs Delete (CanNotDelete)

| Lock type | Portal name | Effect |
|---|---|---|
| CanNotDelete | Delete | Authorised users can read and **modify** the resource, but cannot delete it |
| ReadOnly | Read-only | Authorised users can only read — no modify, no delete (can break apps that need write operations, e.g. listing storage keys) |

Use **Delete** locks routinely on production resource groups; use **ReadOnly** sparingly because it can block normal operations.

---

## Step 9 — Remove the lock (required for later clean-up!)

1. Go to **rg-az900-labs** > **Settings** > **Locks**.
2. Click **Delete** next to `lock-az900-nodelete` and confirm.

Or with the CLI:

```bash
az lock delete --name lock-az900-nodelete --resource-group rg-az900-labs
```

The command returns silently on success. **Do not skip this** — Lab 16's final clean-up deletes the whole resource group, and a leftover lock will block it.

---

## Clean up

1. Ensure the lock `lock-az900-nodelete` is deleted (Step 9).
2. Leave the tags in place — they cost nothing and Lab 15 uses them when grouping costs. Keep `rg-az900-labs` and the storage account for the remaining labs.

## What you learned

- Tags are name/value metadata used to organise resources for ownership, environment and cost reporting — they do not affect how a resource runs.
- Resource-group tags are **not inherited** by child resources by default (only an Azure Policy can enforce inheritance).
- Resource locks (**Delete/CanNotDelete** and **Read-only/ReadOnly**) prevent accidental change and apply even to Owners, overriding RBAC permissions.
- Locks at a parent scope (resource group) are inherited by all child resources.
- Governance tooling like tags and locks addresses accidents and organisation — RBAC addresses *who* is allowed to act.

---

## Files in this lab folder

| File | What it is |
|------|------------|
| `apply-tags-locks.sh` | Applies the governance tags and the `CanNotDelete` lock in one run. |

The scripts are optional conveniences — the lab steps above teach the same thing command by command. Upload a script to Cloud Shell (**Manage files → Upload**), or clone this repo there, then run it with `bash <script-name>`.

