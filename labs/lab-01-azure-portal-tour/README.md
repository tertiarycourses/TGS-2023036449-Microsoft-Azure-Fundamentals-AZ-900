# Lab 1 — Tour the Azure Portal and Create Your First Resource Group

In this lab you take a guided tour of the Azure portal — the web-based console you will use throughout this course — and create the resource group `rg-az900-labs` that hosts every resource you build over the next two days. This maps to the AZ-900 skill areas **Describe cloud concepts** (getting started with a cloud provider) and **Describe Azure management and governance** (portal, resource groups, tags).

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — Sign in to the Azure portal

1. Open a browser and go to **https://portal.azure.com**.
2. Sign in with the Microsoft account tied to your Azure free account. If you do not have one yet, create it first at **https://azure.microsoft.com/free** (requires a credit card for identity verification — you are **not** charged; the free account includes USD 200 credit for 30 days plus always-free services).
3. If prompted, complete multi-factor authentication and choose **Yes** on "Stay signed in?" for the duration of the class.

The portal Home page loads with **Azure services** icons at the top and **Recent resources** below.

---

## Step 2 — Explore the portal menu and global navigation

1. Click the **hamburger icon** (☰, top-left) to open the **portal menu**. Note the entries: **Home**, **Dashboard**, **All services**, **All resources**, **Resource groups**, plus favorited services with stars.
2. Click **All services** and browse the categories on the left (Compute, Networking, Storage, Databases, etc.). This is the full Azure service catalogue — 200+ services.
3. Hover over **Virtual machines** and click the **star** icon to add it to your favourites in the portal menu.
4. Click **Home** in the portal menu to return.

Everything you can do in Azure is reachable from this one menu — the portal is just a GUI over the same Azure Resource Manager (ARM) API that the CLI and PowerShell use.

---

## Step 3 — Use the global search bar

1. Click the **search bar** at the top of the portal (or press **/** or **Ctrl+/** as a shortcut).
2. Type `resource groups` — note results are grouped into **Services**, **Resources**, **Marketplace** and **Documentation**.
3. Type `virtual machines` and observe the same grouping, then press **Esc** to close.

The search bar is the fastest way to navigate — during labs, searching a service name beats clicking through menus.

---

## Step 4 — Explore the top toolbar icons

Locate these icons at the top-right of the portal and click each briefly:

| Icon | Name | What it does |
|---|---|---|
| `>_` | **Cloud Shell** | Opens a browser-based Bash/PowerShell terminal (Lab 2) — close it for now |
| Bell | **Notifications** | Shows deployment progress and alerts — currently empty |
| Gear | **Settings** | Portal appearance, language, startup view |
| `?` | **Help + support** | Documentation and support tickets |

---

## Step 5 — Customise portal settings

1. Click the **gear icon** (Settings) at the top-right.
2. Under **Appearance + startup views**:
   - **Choose a theme**: try a dark theme, then set it back to your preference.
   - **Startup page**: options are **Home** or **Dashboard** — leave it on **Home**.
3. Note the **Language + region** tab (portal display language) and the **Signing out + notifications** tab (inactivity sign-out timeout).
4. Click **Apply** if you changed anything, then close the Settings pane.

---

## Step 6 — View and edit your dashboard, and pin a service

1. In the portal menu (☰), click **Dashboard**. You see the default private dashboard with tiles such as **All resources** and **Quickstarts + tutorials**.
2. Click **Edit** on the dashboard toolbar — a **Tile Gallery** appears. Drag any tile (e.g. **Clock**) onto the canvas, then click **Save**.
3. Now pin a service: search for `Virtual machines` in the global search, open it, and click the **pin icon** (📌) at the top-right of the Virtual machines blade. Choose your dashboard and click **Pin**.
4. Return to **Dashboard** and confirm the **Virtual machines** tile appears.

Dashboards are per-user, customisable views — teams often build shared dashboards for monitoring.

---

## Step 7 — Create the resource group `rg-az900-labs`

1. In the global search bar, type `resource groups` and open **Resource groups**.
2. Click **+ Create**.
3. On the **Basics** tab enter:
   - Subscription: your free-account subscription (e.g. `Azure subscription 1` or `Free Trial`)
   - Resource group: `rg-az900-labs`
   - Region: `Southeast Asia`
4. Click **Next: Tags**.

A resource group is a logical container for resources that share a lifecycle — deleting the group deletes everything inside it. The region here only stores the group's metadata; resources inside it can live in any region.

---

## Step 8 — Add a tag and create

1. On the **Tags** tab enter:
   - Name: `course`
   - Value: `az900`
2. Click **Review + create** — validation runs and shows **Validation passed**.
3. Click **Create**. Creation is instant (resource groups contain no billable resources by themselves).
4. Click the **notifications bell** — you see the "Created resource group" notification.

Tags are name/value metadata used for cost reporting, ownership and automation — a core AZ-900 governance topic.

---

## Step 9 — Verify the resource group

1. Open **Resource groups** from the portal menu and confirm `rg-az900-labs` is listed with location **Southeast Asia**.
2. Click `rg-az900-labs` to open its **Overview** blade — it shows *No resources to display* for now.
3. On the left menu of the resource group, note the blades you will use later: **Access control (IAM)**, **Tags**, **Deployments**, **Locks**.
4. Click **Tags** on the left and confirm `course : az900` is present.

---

## Clean up

Nothing to delete. **Keep `rg-az900-labs`** — it is reused by every lab in this course and is only deleted at the end of the course (Lab 16). A resource group with no resources in it costs nothing.

Optional: if you added extra dashboard tiles you don't want, open **Dashboard** → **Edit**, remove them and **Save**.

## What you learned

- How to navigate the Azure portal: portal menu, global search, All services, notifications and Cloud Shell icons.
- How to customise the portal experience (theme, startup page) and pin services/tiles to a dashboard.
- What a resource group is — a logical, lifecycle-based container for Azure resources — and that its region only stores metadata.
- How to apply tags (`course=az900`) for organisation and cost governance.
- That the portal, CLI and PowerShell are all front ends to the same Azure Resource Manager control plane.

---

## Files in this lab folder

| File | What it is |
|------|------------|
| `verify-lab01.sh` | Optional Cloud Shell check that your resource group was created correctly. |

The scripts are optional conveniences — the lab steps above teach the same thing command by command. Upload a script to Cloud Shell (**Manage files → Upload**), or clone this repo there, then run it with `bash <script-name>`.

