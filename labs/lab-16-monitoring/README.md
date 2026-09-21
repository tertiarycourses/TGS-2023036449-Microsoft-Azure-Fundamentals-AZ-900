# Lab 16 — Monitor Your Environment: Advisor, Service Health and Azure Monitor

In this final lab you tour Azure's monitoring stack: Azure Advisor's recommendation categories, Service Health alerts for platform incidents, and Azure Monitor's Metrics and Activity log — then you perform the full end-of-course clean-up. This maps to the AZ-900 skill area "Describe Azure management and governance" (Azure Advisor, Service Health, Azure Monitor including Log Analytics and alerts).

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — Review Azure Advisor recommendations

1. In the portal search bar, type **Advisor** and open **Azure Advisor**.
2. On the **Overview** blade, note the five recommendation categories, each with a score/count:
   - **Cost** — e.g. shut down or resize under-used VMs
   - **Security** — findings sourced from Microsoft Defender for Cloud
   - **Reliability** — e.g. enable backups, add redundancy
   - **Operational excellence** — e.g. use resource locks, follow deployment best practice
   - **Performance** — e.g. upgrade SKUs or storage tiers for speed
3. Click into one category (e.g. **Cost**) and open any recommendation to see the affected resource and suggested action.

A small lab subscription may show few or zero recommendations — Advisor only advises on what you actually run. Memorise the five categories for the exam.

---

## Step 2 — Download the Advisor recommendations CSV

1. On the Advisor **Overview** (or any category blade), click **Download as CSV** in the toolbar.
2. Open the file and note the columns: category, impact (High/Medium/Low), recommendation and impacted resource.

Teams feed this export into review meetings — Advisor is free, personalised guidance, not a billed service.

---

## Step 3 — Explore Service Health

1. Search **Service Health** and open it.
2. Walk through the left-menu views:
   - **Service issues** — active Azure platform outages affecting *your* subscriptions/regions (usually "No active events" — good news)
   - **Planned maintenance** — upcoming Microsoft maintenance windows
   - **Health advisories** — changes needing action, e.g. service retirements
   - **Health history** — past events
3. Compare with **Azure status** (https://azure.status.microsoft) — that page shows global platform health for everyone; Service Health is *personalised* to your resources.

Service Health tells you when the problem is Azure's, not yours — key exam distinction versus Azure Monitor (your resources) and Resource Health (a single resource).

---

## Step 4 — Create an action group for notifications

1. In **Service Health**, click **Health alerts** > **+ Add service health alert** (this opens the alert rule creation wizard; you will create the action group inside it).
2. On the **Condition** tab set:
   - **Subscription**: your subscription
   - **Services**: `Select all`
   - **Regions**: untick all, tick **Southeast Asia** only
   - **Event types**: `Select all` (Service issue, Planned maintenance, Health advisories, Security advisory)
3. Go to the **Actions** tab and click **+ Create action group**:
   - **Resource group**: `rg-az900-labs`
   - **Action group name**: `ag-az900-email`
   - **Display name**: `az900email`
   - On the **Notifications** tab: **Notification type**: `Email/SMS message/Push/Voice`, **Name**: `email-me`, tick **Email** and enter your email address, click **OK**.
   - Click **Review + create** > **Create**.

An action group is a reusable bundle of "who to notify / what to run" — one group can serve many alert rules.

---

## Step 5 — Finish creating the Service Health alert rule

1. Back on the alert wizard's **Actions** tab, confirm `ag-az900-email` is selected.
2. On the **Details** tab:
   - **Resource group**: `rg-az900-labs`
   - **Alert rule name**: `alert-servicehealth-sea`
3. Click **Review + create** > **Create**.
4. Check your inbox — Azure sends a confirmation email that you were added to the action group.

From now on, any Azure incident touching Southeast Asia would email you automatically instead of you discovering it from angry users.

---

## Step 6 — Chart a metric in Azure Monitor

1. Search **Monitor** and open **Azure Monitor**, then click **Metrics**.
2. In the **Select a scope** pane, expand your subscription > `rg-az900-labs` and select a resource:
   - If a VM still exists from earlier labs: select it, **Metric**: `Percentage CPU`, **Aggregation**: `Avg`.
   - Otherwise select the Lab 9 storage account `staz900...`, **Metric namespace**: `Account`, **Metric**: `Transactions`, **Aggregation**: `Sum`.
3. Change the time range (top right) to **Last 24 hours** and watch the chart update.
4. Click **Save to dashboard** > **Pin to dashboard** > **Create new** > name it `AZ900 Ops` > **Pin**.
5. Open **Dashboard** from the portal menu to see your pinned chart.

Metrics are numeric time-series collected automatically for every resource — no agent or setup required for platform metrics.

---

## Step 7 — Audit operations with the Activity log

1. In **Azure Monitor**, click **Activity log** (also available on every resource and resource group).
2. Set the filters: **Timespan**: `Last 24 hours`, and add filter **Resource group**: `rg-az900-labs`.
3. Find entries from earlier labs — role assignments (Lab 12), lock create/delete (Lab 13), policy assignment (Lab 14). Click one and open the **JSON** tab to see **caller** (who), **operationName** (what) and timestamp (when).

The Activity log is the subscription-level audit trail of control-plane operations — "who did what, when" — retained for 90 days by default.

---

## Step 8 — Understand Log Analytics and KQL (concept only)

No workspace needed for this course — just know the model:

- **Log Analytics workspace**: a store into which resources, VMs and services send detailed logs.
- **KQL (Kusto Query Language)**: the query language used across Log Analytics, e.g. `AzureActivity | where OperationNameValue contains "delete" | take 10`.
- Alert rules can fire on log query results as well as on metrics.

For AZ-900 you only need to identify Azure Monitor's parts: Metrics, Logs (Log Analytics + KQL), Alerts (with action groups), and visualisation (dashboards/workbooks).

---

## Step 9 — FINAL COURSE CLEAN-UP: remove alert rule and action group

1. Go to **Azure Monitor** > **Alerts** > **Alert rules**, tick `alert-servicehealth-sea`, click **Delete**, confirm.
2. Go to **Azure Monitor** > **Alerts** > **Action groups** (or search **Action groups**), tick `ag-az900-email`, click **Delete**, confirm.

Delete the alert rule before the action group — a rule referencing a deleted group would silently notify no one.

---

## Step 10 — FINAL COURSE CLEAN-UP: delete the resource group

First check for the Lab 13 lock — a leftover lock will block deletion:

```bash
az lock list --resource-group rg-az900-labs -o table
az lock delete --name lock-az900-nodelete --resource-group rg-az900-labs
```

Run the second command only if the first shows the lock still exists. Then delete everything the course created in one shot:

```bash
az group delete --name rg-az900-labs --yes --no-wait
```

`--yes` skips the confirmation prompt and `--no-wait` returns immediately while Azure deletes the group and every resource inside it (storage account, dashboards' source resources, action-group container) in the background.

```bash
az group exists --name rg-az900-labs
```

Re-run this after a few minutes until it prints `false`.

---

## Step 11 — FINAL COURSE CLEAN-UP: delete the Entra ID test identities

1. Search **Microsoft Entra ID** and open it.
2. Click **Users**, tick `az900.learner`, click **Delete**, confirm. (The user moves to **Deleted users** for 30 days, then purges automatically.)
3. Click **Groups**, tick `grp-az900-learners`, click **Delete**, confirm.

Or with the CLI:

```bash
az ad user delete --id az900.learner@<yourtenant>.onmicrosoft.com
az ad group delete --group grp-az900-learners
```

Replace `<yourtenant>` with your tenant name; both commands return silently on success.

---

## Step 12 — Verify the subscription is empty

1. Open **All resources** — the list should be empty (allow a few minutes for the group deletion to finish).
2. Open **Resource groups** — `rg-az900-labs` should be gone.
3. Optionally open **Cost Management** > **Cost analysis** once more to confirm no ongoing charges.

An empty subscription means zero ongoing cost — the golden rule of lab hygiene. Congratulations, you have completed all 16 AZ-900 labs.

---

## Clean up

All course clean-up was performed in Steps 9–12:

1. Deleted Service Health alert rule `alert-servicehealth-sea` and action group `ag-az900-email`.
2. Removed any remaining resource lock, then deleted resource group `rg-az900-labs` (`az group delete --name rg-az900-labs --yes --no-wait`).
3. Deleted Entra ID user `az900.learner` and group `grp-az900-learners` (Lab 11).
4. Verified **All resources** is empty. If you created the `budget-az900` budget in Lab 15 and want it gone too, delete it under **Cost Management** > **Budgets**.

## What you learned

- **Azure Advisor** gives free, personalised recommendations in five categories: Cost, Security, Reliability, Operational excellence and Performance.
- **Service Health** reports Azure platform issues, planned maintenance and health advisories personalised to your subscriptions, and can alert you via action groups.
- **Azure Monitor Metrics** charts platform time-series data with no setup; the **Activity log** is the subscription audit trail of who did what.
- **Log Analytics** stores detailed logs queried with **KQL**, and alert rules plus **action groups** turn signals into notifications and automation.
- Deleting a resource group removes every resource inside it — the fastest way to guarantee a lab environment stops costing money.

---

## Files in this lab folder

| File | What it is |
|------|------------|
| `cleanup-course.sh` | **Full course clean-up** — removes the lock and deletes `rg-az900-labs` (asks to confirm). |

The scripts are optional conveniences — the lab steps above teach the same thing command by command. Upload a script to Cloud Shell (**Manage files → Upload**), or clone this repo there, then run it with `bash <script-name>`.

