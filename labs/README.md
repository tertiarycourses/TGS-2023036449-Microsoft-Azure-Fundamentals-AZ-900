# Microsoft Azure Fundamentals (AZ-900) — Lab Index

All labs run on a **free Azure account**:
**https://azure.microsoft.com/free** (USD 200 credit for 30 days + always-free services)

Portal labs run at **https://portal.azure.com**; CLI labs run in **Azure Cloud Shell** (https://shell.azure.com) — nothing to install on your own machine. Labs marked 🌐 **Web tool** use a free public website and need no Azure subscription at all.

The labs share the resource group **`rg-az900-labs`** (region **Southeast Asia**). Run each lab's **Clean up** section; the full course clean-up happens at the end of Lab 16.

---

## Domain 1 — Describe Cloud Concepts (25–30%)

| # | Lab | Where it runs |
|---|-----|---------------|
| 1 | [Tour the Azure Portal and Create Your First Resource Group](lab-01-azure-portal-tour/) | Azure Portal |
| 2 | [Get Started with Azure Cloud Shell (CLI and PowerShell)](lab-02-cloud-shell-cli/) | Cloud Shell |
| 3 | [Explore Regions, Region Pairs and Availability Zones](lab-03-regions-availability-zones/) | Cloud Shell + 🌐 **Web tools** — https://datacenters.microsoft.com/globe/explore, https://www.azurespeed.com |

## Domain 2 — Describe Azure Architecture and Services (35–40%)

| # | Lab | Where it runs |
|---|-----|---------------|
| 4 | [Create a Windows Virtual Machine in the Portal](lab-04-windows-vm-portal/) | Azure Portal + RDP client (mstsc / Windows App) |
| 5 | [Create a Linux VM with the Azure CLI](lab-05-linux-vm-cli/) | Cloud Shell |
| 6 | [Create a Web App with Azure App Service](lab-06-app-service-webapp/) | Azure Portal + Cloud Shell |
| 7 | [Deploy a Container with Azure Container Instances](lab-07-container-instances/) | Cloud Shell |
| 8 | [Create a Virtual Network and Test Private Connectivity](lab-08-virtual-network/) | Azure Portal + Cloud Shell |
| 9 | [Create a Storage Account and Work with Blob Storage](lab-09-storage-blobs/) | Azure Portal + Cloud Shell |
| 10 | [Create an Azure SQL Database](lab-10-azure-sql/) | Azure Portal (Query editor) |
| 11 | [Explore Microsoft Entra ID: Users and Groups](lab-11-entra-id/) | Azure Portal — ⚠️ use your own free-account tenant |

## Domain 3 — Describe Azure Management and Governance (30–35%)

| # | Lab | Where it runs |
|---|-----|---------------|
| 12 | [Manage Access with Azure RBAC](lab-12-rbac/) | Azure Portal |
| 13 | [Apply Resource Tags and Resource Locks](lab-13-tags-locks/) | Azure Portal + Cloud Shell |
| 14 | [Enforce Standards with Azure Policy](lab-14-azure-policy/) | Azure Portal |
| 15 | [Estimate and Control Costs: Pricing Calculator, TCO and Budgets](lab-15-cost-management/) | Azure Portal + 🌐 **Web tools** — https://azure.microsoft.com/pricing/calculator/, https://azure.microsoft.com/pricing/tco/calculator/ |
| 16 | [Monitor Your Environment: Advisor, Service Health and Azure Monitor](lab-16-monitoring/) | Azure Portal — ends with full course clean-up |

---

## Two-day schedule

| Day | Labs | Focus |
|-----|------|-------|
| **Day 1** | Labs 1–8 | Cloud concepts, portal & CLI tooling, compute (VMs, App Service, containers), networking |
| **Day 2** | Labs 9–16 | Storage, databases, identity (Entra ID), RBAC, governance (tags, locks, policy), cost management, monitoring |

---

## How each lab folder is laid out

Every lab is a self-contained folder:

```
lab-05-linux-vm-cli/
├── README.md                  <- the lab instructions (Markdown)
├── lab-05-linux-vm-cli.pdf    <- the same instructions (PDF, for printing/handout)
├── deploy-linux-vm.sh         <- optional helper script
└── cleanup-linux-vm.sh
```

- **`README.md`** — the lab instructions; this is what you follow on screen.
- **`<lab-name>.pdf`** — the identical instructions as a PDF handout.
- **Scripts, YAML, JSON and SQL** — optional helpers that automate the commands in
  the lab. They are a convenience, not a shortcut: the steps in the README teach the
  concepts command by command, and the AZ-900 exam tests understanding, not typing.
  To use one, upload it to Cloud Shell (**Manage files → Upload**) or clone this repo
  there, then run `bash <script-name>`.

Regenerate every PDF after editing any lab:

```bash
python3 qa/render_lab_pdfs.py
```
