# Lab 9 — Create a Storage Account and Work with Blob Storage

In this lab you create a general-purpose storage account, upload a blob, switch its access tier, and share it securely with a time-limited SAS URL — then list the same blobs from the CLI. This maps to the AZ-900 skill area **Describe Azure architecture and services** — storage services, tiers, and redundancy.

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — Create the storage account

1. Click **Create a resource** → search **Storage account** → **Create**.
2. On the **Basics** tab enter:

   | Field | Value |
   |---|---|
   | Subscription | your free subscription |
   | Resource group | `rg-az900-labs` (click **Create new** if it doesn't exist) |
   | Storage account name | `staz900<yourinitials><random>` (e.g. `staz900tan4821` — lowercase letters/numbers only, globally unique) |
   | Region | `Southeast Asia` |
   | Performance | `Standard` |
   | Redundancy | `Locally-redundant storage (LRS)` |

3. Leave all other tabs at defaults, click **Review + create** → **Create**, then **Go to resource**.

LRS keeps 3 copies of your data within one datacenter — the cheapest redundancy option, ideal for labs.

---

## Step 2 — Create a private blob container

1. On the storage account's left menu, click **Data storage → Containers**.
2. Click **+ Container** and enter:
   - Name: `labfiles`
   - Anonymous access level: `Private (no anonymous access)`
3. Click **Create**.

Private access means every request must be authorised — by Entra ID, an account key, or a SAS token.

---

## Step 3 — Upload a file via the portal

1. On your computer, create a small text file `hello.txt` containing one line, e.g. `Hello from Azure Blob Storage - AZ-900 Lab 9` (any small text or image file works).
2. Open the `labfiles` container → click **Upload**.
3. Browse to your file, expand **Advanced** and note the defaults (Block blob, access tier **Hot**), then click **Upload**.

Block blobs are the standard blob type for files; page blobs (VM disks) and append blobs (logs) are the other two.

---

## Step 4 — Change the blob's access tier Hot → Cool

1. In the `labfiles` container, click the blob `hello.txt` to open its properties.
2. Click **Change tier** (top toolbar), set **Access tier** = `Cool`, click **Save**.
3. Re-open the blob's properties and confirm **Access tier: Cool** and note the tier-change timestamp.

Cool storage costs less per GB but more per access, with a 30-day minimum — tiers let you match cost to how often data is read. (Cold and Archive tiers go further; Archive requires rehydration before reading.)

---

## Step 5 — Try to open the blob URL anonymously

1. On the blob's **Overview**, copy the **URL** (e.g. `https://staz900tan4821.blob.core.windows.net/labfiles/hello.txt`).
2. Paste it into a **private/incognito** browser window.
3. You get an XML error: `ResourceNotFound` / `The specified resource does not exist` — anonymous access is blocked because the container is private.

This is the expected, secure default: a URL alone is not enough to read private data.

---

## Step 6 — Generate a SAS URL and open it

1. Back on the blob's page, click the **Generate SAS** tab.
2. Configure:
   - Signing method: `Account key`
   - Permissions: `Read` only
   - Start: now; Expiry: 1 hour from now
3. Click **Generate SAS token and URL** and copy the **Blob SAS URL**.
4. Paste the SAS URL into the same private window — the file now opens/downloads.

A **shared access signature** grants delegated, scoped, time-limited access without sharing your account keys. When the expiry passes, the same URL stops working.

---

## Step 7 — List blobs from the CLI

Open **Cloud Shell** (Bash) and run:

```bash
az storage blob list \
  --account-name staz900<yourinitials><random> \
  --container-name labfiles \
  --auth-mode login \
  --output table
```

`--auth-mode login` uses your Entra ID sign-in. If you get an authorization error, your account needs the **Storage Blob Data Reader** role on the storage account (Owner of the subscription is not automatically a data-plane reader). Alternative — authenticate with the account key instead:

```bash
az storage account keys list --resource-group rg-az900-labs --account-name staz900<yourinitials><random> --query "[0].value" -o tsv
az storage blob list \
  --account-name staz900<yourinitials><random> \
  --container-name labfiles \
  --auth-mode key \
  --output table
```

This illustrates the difference between **management plane** (ARM/RBAC roles like Owner) and **data plane** (data access roles or keys) — a subtle point AZ-900 touches on under RBAC.

---

## Step 8 — Explore the Storage browser blade

1. On the storage account's left menu, click **Storage browser**.
2. Expand **Blob containers → labfiles** and view your blob; note you can also browse **File shares**, **Queues**, and **Tables** from here.

One storage account hosts four services: Blobs (objects), Files (SMB shares), Queues (messaging), Tables (NoSQL key-value).

---

## Step 9 — Review redundancy options

1. On the storage account's left menu, click **Data management → Redundancy**.
2. Open the redundancy dropdown and compare (don't change it):

   | Option | Copies | Protects against |
   |---|---|---|
   | LRS | 3 in one datacenter | Drive/rack failure |
   | ZRS | 3 across availability zones | Datacenter failure |
   | GRS | 6 (3 local + 3 in paired region) | Regional disaster |
   | GZRS | 6 (zones + paired region) | Zone + regional disaster |

3. Note the map showing the paired region for GRS options.

Choosing redundancy is a cost-vs-durability trade-off — a classic AZ-900 exam question.

---

## Clean up

The storage account costs almost nothing while nearly empty, so you may keep it — it will be removed with `rg-az900-labs` in Lab 16. To delete it now instead:

```bash
az storage account delete --resource-group rg-az900-labs --name staz900<yourinitials><random> --yes
```

Keep the resource group `rg-az900-labs` itself — it is reused until Lab 16.

---

## What you learned

- A **storage account** is a globally-unique namespace hosting Blobs, Files, Queues, and Tables.
- **Access tiers** (Hot/Cool/Cold/Archive) trade storage cost against access cost for infrequently used data.
- Private containers block anonymous access; a **SAS token** grants scoped, time-limited access without exposing account keys.
- Data-plane access uses either **Entra ID roles** (e.g. Storage Blob Data Reader) or **account keys** — separate from management-plane RBAC.
- **Redundancy options** (LRS → ZRS → GRS → GZRS) increase durability and cost by copying data across zones and paired regions.

---

## Files in this lab folder

| File | What it is |
|------|------------|
| `manage-blobs.sh` | Uploads, lists and downloads a blob: `bash manage-blobs.sh <storage-account-name>`. |

The scripts are optional conveniences — the lab steps above teach the same thing command by command. Upload a script to Cloud Shell (**Manage files → Upload**), or clone this repo there, then run it with `bash <script-name>`.

