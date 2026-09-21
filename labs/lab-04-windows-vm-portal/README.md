# Lab 4 — Create a Windows Virtual Machine in the Portal

In this lab you deploy a Windows Server 2022 virtual machine through the portal, connect to it over RDP, install the IIS web server, expose it on port 80 through a network security group rule, and then stop (deallocate) it to see how IaaS compute billing works. This maps to the AZ-900 skill areas **Describe cloud concepts** (IaaS, shared responsibility) and **Describe Azure architecture and services** (virtual machines, networking basics).

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — Start the Create VM wizard

1. In the portal search bar, type `virtual machines` and open **Virtual machines**.
2. Click **+ Create** → **Azure virtual machine**.
3. On the **Basics** tab set:
   - Subscription: your subscription
   - Resource group: `rg-az900-labs` (click **Create new** and enter it if it doesn't exist)
   - Virtual machine name: `vm-az900-win01`
   - Region: `Southeast Asia`
   - Availability options: `No infrastructure redundancy required`
   - Security type: `Trusted launch virtual machines` (default)
   - Image: `Windows Server 2022 Datacenter: Azure Edition - x64 Gen2`
   - Size: click **See all sizes** and choose `Standard_B2s` (2 vCPUs, 4 GiB RAM — burstable, cheap)

The B-series is designed for workloads that idle most of the time — ideal for labs and free credit.

---

## Step 2 — Set credentials and inbound ports

Still on the **Basics** tab:

1. Under **Administrator account**:
   - Username: `azureadmin`
   - Password: choose a strong password (12+ chars) and **write it down** — Azure never shows it again.
2. Under **Inbound port rules**:
   - Public inbound ports: `Allow selected ports`
   - Select inbound ports: `RDP (3389)`
3. Under **Licensing**, leave the Azure Hybrid Benefit checkbox unticked.

Opening RDP to the internet is acceptable for a short lab, but in production you would use Azure Bastion or restrict the source IP — note the portal's warning about this.

---

## Step 3 — Review the remaining tabs, then create

1. Click **Next: Disks** — note the default **OS disk type**; change it to `Standard SSD (locally-redundant storage)` to keep costs low.
2. Click **Next: Networking** — observe that the wizard auto-creates a virtual network (`rg-az900-labs-vnet`), subnet, public IP (`vm-az900-win01-ip`) and NIC network security group with your RDP rule. Set **Delete public IP and NIC when VM is deleted** to checked.
3. Click through **Management**, **Monitoring**, **Advanced** — leave defaults.
4. Click **Review + create**. Check the **price per hour** shown for `Standard_B2s` and confirm **Validation passed**.
5. Click **Create**.

A single "VM" is really a bundle of resources: compute, disk, NIC, public IP, NSG — you'll see them all land in `rg-az900-labs`.

---

## Step 4 — Watch the deployment

1. The **Deployment** page opens automatically; watch resources turn green as ARM creates them (~2–3 minutes).
2. Click the **notifications bell** — the same deployment progress appears there.
3. When you see **Your deployment is complete**, click **Go to resource** to open the VM's **Overview** blade.
4. Note the **Public IP address** on the Overview — copy it.

---

## Step 5 — Connect via RDP

1. On the VM's Overview blade, click **Connect** → select **Connect** (or **RDP** → **Download RDP file**).
2. Connect from your laptop:
   - **Windows**: open the downloaded `.rdp` file, or run `mstsc /v:<public-ip>`.
   - **macOS**: install **Windows App** (formerly Microsoft Remote Desktop) from the App Store, add a PC with the public IP, and connect.
3. Sign in as `azureadmin` with your password. Accept the certificate warning (it's a self-signed cert for the lab VM).
4. Windows Server desktop loads — Server Manager opens automatically.

You are now inside an IaaS VM: Microsoft manages the physical host; you manage the OS, patches and everything above — the shared responsibility model in action.

---

## Step 6 — Install IIS with PowerShell inside the VM

1. Inside the RDP session, right-click **Start** → **Windows PowerShell (Admin)** (or **Terminal (Admin)**).
2. Run:

```powershell
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
```

Installs the IIS web server role; wait for `Success : True` in the output (1–2 minutes, no restart needed).

3. Verify locally: open **Microsoft Edge** inside the VM and browse to `http://localhost` — the blue IIS welcome page appears.
4. Leave the RDP session connected (or minimise it).

---

## Step 7 — Open port 80 in the network security group

The IIS page works inside the VM but is not reachable from the internet yet — port 80 is blocked by the NSG.

1. Back in the portal, on the VM's left menu open **Networking** → **Network settings**.
2. Under **Rules**, click **+ Create port rule** → **Inbound port rule** and set:
   - Source: `Any`
   - Source port ranges: `*`
   - Destination: `Any`
   - Service: `HTTP` (sets Destination port `80`, Protocol `TCP`)
   - Action: `Allow`
   - Priority: `1010`
   - Name: `Allow-HTTP-80`
3. Click **Add** and wait for the "Created security rule" notification.

NSGs are stateful packet filters evaluated by priority (lower number = evaluated first) — a core Azure networking concept.

---

## Step 8 — Browse the site from the internet

1. On your **own laptop's** browser (not inside the VM), go to `http://<public-ip>` using the IP copied in Step 4.
2. The default **IIS Windows Server** welcome page loads.

You have deployed a working public web server on IaaS: VM + OS + web role + firewall rule — everything a physical server needs, provisioned in minutes.

---

## Step 9 — Stop (deallocate) the VM and observe billing behaviour

1. Close your RDP session (sign out inside the VM, or just close the window).
2. On the VM's **Overview** blade, click **Stop** and confirm. (Optionally leave "reserve public IP" unticked.)
3. Watch the **Status** field change: `Stopping` → **`Stopped (deallocated)`**.
4. Key observation: **Stopped (deallocated)** means the compute hardware is released back to Azure and **you stop paying for the VM's compute time**. You still pay small charges for the OS disk (storage) and any static public IP. Shutting down from inside Windows only reaches `Stopped` — still billed; always stop from the portal/CLI to deallocate.

---

## Clean up

Keep the VM for now if you are continuing the course the same day — later labs reuse `rg-az900-labs`, and a **deallocated** VM costs only its disk (~a few cents/day).

When you no longer need it:

1. Open **Virtual machines** → `vm-az900-win01` → **Delete**.
2. In the delete pane, tick the checkboxes to also delete the **OS disk**, **Network interface** and **Public IP address**, then confirm.
3. **Do not delete the resource group `rg-az900-labs`** — it is reused by every remaining lab (deleted only in Lab 16).

## What you learned

- IaaS in practice: a VM bundles compute, managed disk, NIC, public IP and NSG, all deployed together by ARM into a resource group.
- How to size a VM for cost (`Standard_B2s` burstable) and connect over RDP from Windows (mstsc) or macOS (Windows App).
- Shared responsibility: Azure runs the host; you install and manage the OS workload (IIS via `Install-WindowsFeature`).
- NSG inbound rules control traffic by priority — the site was unreachable until port 80 was allowed.
- `Stopped (deallocated)` releases compute and stops compute billing (disks and static IPs still bill) — a key cost-management behaviour on the AZ-900 exam.
