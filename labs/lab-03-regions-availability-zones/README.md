# Lab 3 — Explore Regions, Region Pairs and Availability Zones

In this lab you explore Azure's global infrastructure — regions, region pairs and availability zones — using the CLI, Microsoft's interactive datacenter map, and a latency test tool, and you reason about how each construct delivers high availability versus disaster recovery. This maps to the AZ-900 skill areas **Describe cloud concepts** (high availability, disaster recovery, reliability) and **Describe Azure architecture and services** (regions, region pairs, availability zones).

Run in Azure Cloud Shell — https://shell.azure.com

---

## Step 1 — List all Azure regions with the CLI

```bash
az account list-locations -o table
```

Lists every region your subscription can see — 60+ rows with `DisplayName`, `Name` (the CLI-friendly id like `southeastasia`) and `RegionalDisplayName`. Note the `Name` column values: these are what you pass to `--location` in every `az` command.

```bash
az account list-locations --query "[?metadata.regionCategory=='Recommended'].{Region:displayName, Name:name, Pair:metadata.pairedRegion[0].name}" -o table
```

Filters to Microsoft's "Recommended" regions and shows each region's **paired region** — look at the `Pair` column for the row `Southeast Asia`.

---

## Step 2 — Explore the global infrastructure map

1. Open **https://datacenters.microsoft.com/globe/explore** in a new browser tab.
2. Rotate the 3D globe to Asia and click the **Southeast Asia** region (Singapore). Read the region facts panel — launch year, availability zone support, sustainability info.
3. Zoom out and observe how regions cluster into **geographies** (e.g. Asia Pacific, Europe, United States) and how undersea network cables connect them.
4. Also open **https://azure.microsoft.com/en-us/explore/global-infrastructure/geographies/** and locate **Singapore** under Asia Pacific — confirm Southeast Asia is listed with availability zones.

A **geography** keeps data residency and compliance boundaries (important for regulated industries); a **region** is a set of datacenters within a latency-defined perimeter.

---

## Step 3 — Identify Southeast Asia's paired region

1. From the CLI output in Step 1 (or the geographies page), confirm that **Southeast Asia (Singapore)** is paired with **East Asia (Hong Kong)**.
2. Verify with a targeted query:

```bash
az account list-locations --query "[?name=='southeastasia'].{Region:displayName, PairedWith:metadata.pairedRegion[0].name}" -o table
```

Expected output shows `PairedWith: eastasia`. Region pairs are at least 300 miles apart in the same geography (where possible); Microsoft sequences platform updates across the pair and prioritises one region's recovery in a broad outage — this is the foundation of cross-region **disaster recovery** and GRS storage replication.

---

## Step 4 — Check which VM SKUs support availability zones

```bash
az vm list-skus --location southeastasia --zone --size Standard_B --output table
```

The `--zone` flag filters to SKUs that can be deployed into availability zones; `--size Standard_B` narrows to the burstable B-series used in this course. In the `Zones` column you should see `1,2,3` for sizes like `Standard_B1s` and `Standard_B2s` — Southeast Asia has three availability zones.

```bash
az vm list-skus --location southeastasia --zone --resource-type virtualMachines --output table | head -20
```

Shows the broader list — note that virtually all mainstream VM sizes in this region are zone-capable.

---

## Step 5 — See zones in the portal VM creation flow

1. Open **https://portal.azure.com**, search `virtual machines`, click **+ Create** → **Azure virtual machine**.
2. On the **Basics** tab set **Region** to `Southeast Asia`, then look at **Availability options** — select **Availability zone** and note you can pick **Zone 1, 2 or 3** (or multiple zones).
3. Change **Region** to a region without zones (e.g. `West Central US`) and observe the availability-zone option disappears.
4. Click **X** to close the wizard **without creating anything**.

Each availability zone is one or more physically separate datacenters with independent power, cooling and networking — deploying VMs across zones protects against a datacenter-level failure with an SLA of 99.99%.

---

## Step 6 — Test your latency to Azure regions

1. Open **https://www.azurespeed.com** in a new tab.
2. On the **Latency Test** page, tick a handful of regions: `Southeast Asia`, `East Asia`, `Japan East`, `Australia East`, `West Europe`, `East US`.
3. Let the test run ~30 seconds and note the average latency to each.
4. Record: which region is fastest from Singapore? Roughly how much slower is Europe or the US?

Expect single-digit milliseconds to Southeast Asia and 150–250 ms to Europe/US — this is why you place resources in the region closest to your users, and why AZ-900 emphasises region selection for performance.

---

## Step 7 — Discuss: zones vs region pairs — HA vs DR

Compare the two constructs and note the difference in your lab notes:

| | Availability zones | Region pairs |
|---|---|---|
| Distance | Separate datacenters, same region (km apart) | Different regions, 300+ miles apart |
| Protects against | Datacenter failure (power, cooling, network) | Regional disaster (earthquake, major outage) |
| Latency between | < 2 ms (synchronous replication possible) | Tens of ms (asynchronous replication) |
| Primary use | **High availability** (99.99% VM SLA) | **Disaster recovery** (GRS storage, cross-region failover) |
| Example | VMs in zones 1, 2, 3 behind a load balancer | Southeast Asia paired with East Asia |

Key takeaway: zones keep an application **up** through a local failure; pairs let a business **recover** from a regional catastrophe. Well-architected solutions use both.

---

## Clean up

Nothing was created in this lab — the VM wizard was cancelled before deployment, and CLI commands were read-only. `rg-az900-labs` remains untouched and is reused in Lab 4.

## What you learned

- How to list Azure regions and their paired regions with `az account list-locations` and JMESPath queries.
- The hierarchy geography → region → availability zone, and that Southeast Asia (Singapore) pairs with East Asia (Hong Kong).
- How to check zone support for VM SKUs with `az vm list-skus --zone`.
- That network latency grows with distance — measured live with azurespeed.com — driving region selection.
- Availability zones deliver high availability within a region (99.99% SLA), while region pairs enable disaster recovery across regions.

---

## Files in this lab folder

| File | What it is |
|------|------------|
| `explore-regions.sh` | Runs every region / region-pair / availability-zone query in one pass. |

The scripts are optional conveniences — the lab steps above teach the same thing command by command. Upload a script to Cloud Shell (**Manage files → Upload**), or clone this repo there, then run it with `bash <script-name>`.

