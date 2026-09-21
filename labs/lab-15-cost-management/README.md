# Lab 15 — Estimate and Control Costs: Pricing Calculator, TCO and Budgets

In this lab you estimate the price of a workload with the Azure Pricing Calculator, compare on-premises versus Azure costs with the TCO Calculator, and then control real spend with Cost analysis and a Budget alert in the portal. This maps to the AZ-900 skill area "Describe Azure management and governance" (factors that affect cost, pricing and TCO calculators, Cost Management).

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — Part A: Open the Pricing Calculator and add a Virtual Machine

1. In a new browser tab, open https://azure.microsoft.com/pricing/calculator/ (sign-in optional, but sign in to save estimates).
2. On the **Products** tab, click the **Virtual Machines** tile — it is added to your estimate at the bottom of the page.
3. Scroll down to the **Virtual Machines** section of the estimate and configure:

| Field | Value |
|---|---|
| Region | Southeast Asia |
| Operating system | Windows |
| Type | (OS only) |
| Tier | Standard |
| Instance | B2s: 2 vCPUs, 4 GB RAM |
| Hours | 730 (1 month, 24×7) |

Note the monthly price shown — this is the compute meter only; disks, networking and licensing appear as separate line items.

---

## Step 2 — Add a Storage account to the estimate

1. Scroll back to the top, on the **Products** tab click **Storage Accounts**.
2. In the new **Storage Accounts** section of the estimate set:
   - **Region**: `Southeast Asia`
   - **Type**: `Block Blob Storage`, **Performance tier**: `Standard`, **Redundancy**: `LRS`
   - **Capacity**: `100 GB`
3. Observe the running **Estimated monthly cost** total at the bottom.

Every Azure service is priced per meter (capacity, transactions, egress) — the calculator makes those meters visible before you spend anything.

---

## Step 3 — Compare Pay-as-you-go with savings plans and reservations

1. In the Virtual Machines section, find the **Savings options** area.
2. Switch between:
   - **Pay as you go**
   - **1 year savings plan** (or **1 year reserved**)
   - **3 year reserved**
3. Note how the monthly VM price drops (typically ~30–60% for 1–3 year commitments).
4. Also try changing **Region** to `West US` or `West Europe` and watch the price change, then set it back to `Southeast Asia`.

Key cost factors: resource type and size, consumption (hours/GB), **region**, commitment model, and network egress.

---

## Step 4 — Export or share the estimate

1. At the bottom of the estimate, click **Export** to download the estimate as an Excel file, or
2. Click **Save** then **Share** to generate a link (requires sign-in).

Shared estimates are how architects present costed designs to stakeholders before deployment.

---

## Step 5 — Part B: Model an on-premises workload in the TCO Calculator

1. Open https://azure.microsoft.com/pricing/tco/calculator/ in a new tab.
2. Under **Define your workloads** > **Servers**, click **+ Add server workload**:
   - **Name**: `On-prem web servers`
   - **Workload**: `Windows/Linux Server`, **Environment**: `Virtual machines`
   - **Operating system**: `Windows`, **VMs**: `2`, **Cores per VM**: `2`, **RAM per VM**: `8` GB
3. Under **Storage**, click **+ Add storage**:
   - **Name**: `On-prem SAN`, **Storage type**: `Local Disk/SAN`, **Disk type**: `HDD`, **Capacity**: `1` TB
4. Leave **Networking** at defaults and click **Next**.

The TCO Calculator captures costs the pricing calculator does not: hardware, electricity, data-centre space, and IT labour.

---

## Step 6 — View the 5-year TCO comparison report

1. On the **Adjust assumptions** page, review the defaults (electricity price, IT labour cost, virtualisation ratio) and click **Next**.
2. On the **View report** page, set **Timeframe**: `5 years` and **Region**: `Southeast Asia`.
3. Review the chart comparing **total cost of running on-premises** vs **cost of the equivalent in Azure**, and the per-category breakdown (compute, data centre, networking, storage, IT labour).
4. Optionally click **Download** to save the report as PDF.

TCO = total cost of ownership over time, not just the sticker price — this is the business case tool, while the Pricing Calculator is the engineering estimate tool.

---

## Step 7 — Part C: Explore Cost analysis in the portal

1. Back in https://portal.azure.com, search **Cost Management + Billing** and open it.
2. Click **Cost Management** > **Cost analysis** (scope: your subscription).
3. Review the accumulated cost chart for the current month.
4. Change **Group by** to `Resource` to see which resources are generating cost; also try `Tag` > `costcenter` to see your Lab 13 tags at work.

Note: on a free account with no charges yet, Cost analysis may show $0 or "no data" — the tooling only lights up once billable usage exists. That is expected.

---

## Step 8 — Create a budget with an email alert

1. In **Cost Management**, click **Budgets** > **+ Add**.
2. On the **Create budget** page:
   - **Scope**: your subscription
   - **Name**: `budget-az900`
   - **Reset period**: `Billing month`
   - **Amount ($)**: `20`
3. Click **Next** to the **Set alerts** tab:
   - **Alert conditions** — **Type**: `Actual`, **% of budget**: `80` (i.e. alert at $16 actual spend)
   - **Alert recipients (email)**: your email address
4. Click **Create**.

Budgets do **not** stop spending by themselves — they notify you (and can trigger action groups) so you act before costs run away.

---

## Step 9 — (Optional) Review budgets and costs with the CLI

Open Cloud Shell (**Bash**) and run:

```bash
az consumption budget list -o table
```

Lists your budgets including `budget-az900` with its amount and time grain (if the command prompts, allow it to install the `consumption` extension).

---

## Clean up

1. In **Cost Management** > **Budgets**, you may keep `budget-az900` (it is free and useful) — or select it, click the `...` menu and **Delete** it now.
2. The Pricing Calculator and TCO Calculator estimates live outside your subscription and cost nothing; delete saved estimates from the calculator site if you wish.
3. Keep `rg-az900-labs` and its resources — Lab 16 performs the final course clean-up.

## What you learned

- The **Pricing Calculator** estimates the monthly cost of Azure services before deployment; the **TCO Calculator** compares full on-premises ownership costs (hardware, power, labour) against Azure over multiple years.
- Cost is driven by resource type/size, consumption, **region**, commitment model (pay-as-you-go vs savings plan vs reservation) and network egress.
- Reservations and savings plans trade a 1–3 year commitment for significant discounts on steady workloads.
- **Cost analysis** breaks real spend down by resource, service or tag — tags applied in Lab 13 become cost-reporting dimensions.
- **Budgets** with alert thresholds notify you at defined spend levels but do not block spending on their own.
