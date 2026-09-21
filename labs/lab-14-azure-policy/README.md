# Lab 14 — Enforce Standards with Azure Policy

In this lab you use Azure Policy to enforce an organisational standard — restricting which regions resources may be deployed to — and watch a non-compliant deployment get denied at creation time, even for an Owner. This maps to the AZ-900 skill area "Describe Azure management and governance" (purpose of Azure Policy and compliance).

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — Open the Policy service

1. In the portal search bar, type **Policy** and open the **Policy** service.
2. On the **Overview** blade, note the compliance summary for your subscription (likely 100% or "no assignments" if this is a fresh account).

Azure Policy evaluates every resource against assigned rules and reports compliance continuously — it is governance for *what* gets created, not *who* creates it.

---

## Step 2 — Browse built-in policy definitions

1. In the Policy left menu, under **Authoring**, click **Definitions**.
2. In the **Search** box type **Allowed locations** — open the built-in definition named **Allowed locations**.
3. Read the description and click the **JSON** view: the rule denies any resource whose `location` is not in the `listOfAllowedLocations` parameter.
4. Go back and search **Require a tag on resources** — open it and note it denies creation of resources missing a given tag.

Azure ships hundreds of built-in definitions (many grouped into **initiatives** — bundles of related policies); you assign them rather than writing JSON from scratch.

---

## Step 3 — Assign "Allowed locations" to rg-az900-labs

1. From the **Allowed locations** definition page, click **Assign policy** (or go to **Assignments** > **Assign policy** and pick the definition).
2. On the **Basics** tab:
   - **Scope**: click the `...` button, select your subscription, then **Resource Group**: `rg-az900-labs`, click **Select**.
   - **Assignment name**: leave as `Allowed locations`.
3. On the **Parameters** tab:
   - **Allowed locations**: tick **Southeast Asia** and **East Asia** only.
4. Click **Review + create** > **Create**.

The scope matters: this rule now applies only inside `rg-az900-labs`; assigned at subscription or management-group scope it would govern everything below.

---

## Step 4 — Wait for the assignment to take effect

1. Go to **Policy** > **Assignments** and confirm the **Allowed locations** assignment is listed with scope `rg-az900-labs`.
2. Wait about **5 minutes** before testing — new assignments take a few minutes to propagate to the resource providers that enforce them.

Enforcement (deny at deployment) starts within minutes; the **Compliance** dashboard scan is slower (see Step 6).

---

## Step 5 — Attempt a non-compliant deployment

1. Open **rg-az900-labs** > **+ Create**, search **Storage account**, click **Create**.
2. On the **Basics** tab:
   - **Resource group**: `rg-az900-labs`
   - **Storage account name**: `staz900policytest` plus random digits (lowercase, unique)
   - **Region**: `West Europe`  ← deliberately not allowed
   - **Redundancy**: `Locally-redundant storage (LRS)`
3. Click **Review + create**. Validation fails (or the deployment is denied on **Create**) with an error like:
   - `Resource 'staz900policytest...' was disallowed by policy. Policy identifiers: '[{"policyAssignment":{"name":"Allowed locations", ...}}]' (Code: RequestDisallowedByPolicy)`
4. Read the error — it names the exact **policy assignment** that blocked you. Cancel the deployment (do not retry with an allowed region).

You are the subscription Owner and were still denied: Azure Policy applies to **everyone**, regardless of RBAC role.

---

## Step 6 — View the Compliance blade

1. Go to **Policy** > **Compliance**.
2. Click the **Allowed locations** assignment to see its compliance state and the count of compliant resources (your existing Southeast Asia resources comply).

Note: the compliance evaluation cycle can take **~15 minutes or more** to first populate — if it shows "Not started", continue and check back later. Denied deployments never appear here because the resource was never created.

---

## Step 7 — Compare Azure Policy with RBAC

| | Azure RBAC (Lab 12) | Azure Policy (this lab) |
|---|---|---|
| Question answered | **Who** can perform actions? | **What** configurations are allowed? |
| Applies to | The assigned principal only | Everyone, including Owners |
| Example | Reader cannot create resources | No one can create resources in West Europe |
| Blocked how | Authorization error before the action | `RequestDisallowedByPolicy` on deployment / flagged non-compliant |

Real governance uses both together: RBAC limits who acts, Policy limits what even authorised users can do.

---

## Step 8 — Delete the policy assignment

1. Go to **Policy** > **Assignments**.
2. Click the `...` at the right of the **Allowed locations** assignment and select **Delete assignment**, then confirm.

Or with the CLI in Cloud Shell:

```bash
az policy assignment list --resource-group rg-az900-labs -o table
az policy assignment delete --name "Allowed locations" --resource-group rg-az900-labs
```

The first command shows the assignment's name at the resource-group scope; the second removes it so later labs can deploy to any region.

---

## Clean up

1. Confirm the **Allowed locations** assignment is deleted (Step 8) — the built-in *definition* stays, only your *assignment* is removed.
2. No resources were created (the test deployment was denied), so nothing else to delete. Keep `rg-az900-labs` for the remaining labs.

## What you learned

- Azure Policy enforces organisational standards (allowed regions, required tags, allowed SKUs) and continuously assesses **compliance**.
- A policy is a **definition** (the rule) plus an **assignment** (the rule applied at a scope); initiatives bundle related definitions.
- Policy assignments inherit down the scope hierarchy just like RBAC, but apply to **all users including Owners**.
- Deny-effect policies block non-compliant deployments with `RequestDisallowedByPolicy`, naming the assignment responsible.
- RBAC answers *who can act*; Policy answers *what is allowed* — the AZ-900 exam tests this distinction.

---

## Files in this lab folder

| File | What it is |
|------|------------|
| `allowed-locations-policy.json` | Parameters file for the built-in **Allowed locations** policy. |
| `require-tag-policy.json` | A custom policy rule that denies any resource created without a `course` tag. |
| `POLICY-USAGE.md` | How to assign, test and remove both policies from Cloud Shell. |

The scripts are optional conveniences — the lab steps above teach the same thing command by command. Upload a script to Cloud Shell (**Manage files → Upload**), or clone this repo there, then run it with `bash <script-name>`.

