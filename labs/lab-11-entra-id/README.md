# Lab 11 — Explore Microsoft Entra ID: Users and Groups

In this lab you explore your tenant in Microsoft Entra ID (formerly Azure AD), create a user and a security group, and sign in as that user to see what "authenticated but not authorised" looks like. This maps to the AZ-900 skill area **Describe Azure architecture and services** — identity, access, and the difference between authentication and authorization.

Run on https://portal.azure.com — sign in with your Azure free account (https://azure.microsoft.com/free).

---

## Step 1 — WARNING: use your own tenant, not your company's

**Do this lab only in the tenant of your own Azure free account.** If your portal session is signed into a company or school tenant, creating users and groups there may violate policy and confuse your IT department.

1. Click your account avatar (top-right) → **Switch directory**.
2. Confirm the current directory is your personal free-account tenant (usually named "Default Directory" with a domain like `<yourname>outlook.onmicrosoft.com`). Switch to it if not.

---

## Step 2 — Open Microsoft Entra ID and note your tenant details

1. In the portal search bar, type **Microsoft Entra ID** and open it.
2. On the **Overview** blade, write down:
   - **Tenant name** (e.g. `Default Directory`)
   - **Primary domain** — `<something>.onmicrosoft.com` (you need this exact value in Step 3)
   - **Tenant ID** — a GUID
3. Note the counts of Users, Groups, and Applications.

Every Azure subscription trusts exactly one Entra tenant — the tenant is the identity boundary; the subscription is the billing/resource boundary.

---

## Step 3 — Create a new user

1. In Entra ID, click **Manage → Users** → **+ New user** → **Create new user**.
2. On the **Basics** tab enter:

   | Field | Value |
   |---|---|
   | User principal name | `az900.learner` @ `<yourtenant>.onmicrosoft.com` |
   | Display name | `AZ900 Learner` |
   | Password | tick **Auto-generate password**, then click the copy icon and **save the password** — you need it in Step 6 |

3. Click **Review + create** → **Create**.
4. Refresh the Users list and confirm `AZ900 Learner` appears with source "Cloud".

This is a cloud-only identity that exists purely in your tenant — no on-premises AD involved.

---

## Step 4 — Create a security group

1. In Entra ID, click **Manage → Groups** → **+ New group**.
2. Enter:
   - Group type: `Security`
   - Group name: `grp-az900-learners`
   - Membership type: `Assigned`
3. Click **Create**.

Assigned membership means an admin adds members manually; **Dynamic** groups instead auto-populate from rules (e.g. department = Sales) — a Premium feature.

---

## Step 5 — Add the user to the group

1. Open **grp-az900-learners** → **Manage → Members** → **+ Add members**.
2. Search for `AZ900 Learner`, select it, click **Select**.
3. Confirm the member count is now 1.

In real deployments you assign roles and licences to **groups**, not individual users — new hires inherit access just by joining the group.

---

## Step 6 — Sign in as the new user

1. Open a **private/incognito** browser window and go to https://portal.azure.com.
2. Sign in as `az900.learner@<yourtenant>.onmicrosoft.com` with the auto-generated password.
3. You are forced to **update the password** — set a new one and note it (keep MFA enrolment prompts minimal if offered; you can select "Ask later" where available).
4. The portal opens. **Authentication succeeded** — the tenant verified who this user is.

---

## Step 7 — Observe: authenticated but not authorised

Still in the private window as `az900.learner`:

1. Search **Subscriptions** — the list is empty ("You don't have any subscriptions").
2. Search **Resource groups** — no resource groups are visible, even though `rg-az900-labs` exists in the same tenant.
3. Try **Create a resource** → pick anything → the Basics tab has no subscription to select, so creation is impossible.

This is the key lesson: Entra ID **authenticated** the user (proved identity), but with no Azure **RBAC role assignments** the user is **authorised** to do nothing with resources. Lab 12 fixes this by assigning a role. Sign out of the private window but keep the user and its new password.

---

## Step 8 — Look at authentication methods and MFA (look, don't enforce)

Back in your admin window:

1. In Entra ID, click **Manage → Security → Authentication methods** (or **Manage → Users** → select a user → **Authentication methods**).
2. Browse the available methods: Microsoft Authenticator, SMS, FIDO2 security keys, Temporary Access Pass.
3. **Do NOT enable any enforcement policy** — just note that multifactor authentication requires two or more of: something you know (password), something you have (phone/key), something you are (biometric).

Free-tier tenants also have **Security defaults** (Entra ID → Overview → Properties → Manage security defaults), which enforce MFA tenant-wide — leave it as is for this course.

---

## Clean up

**Keep the user `az900.learner` and the group `grp-az900-learners` — Lab 12 (RBAC) reuses them.** They cost nothing.

If you are not continuing to Lab 12, delete them: Entra ID → **Users** → tick `AZ900 Learner` → **Delete**, and **Groups** → tick `grp-az900-learners` → **Delete**. Keep the resource group `rg-az900-labs` — it is reused until Lab 16.

---

## What you learned

- **Microsoft Entra ID** is Azure's cloud identity service; every subscription trusts one tenant, identified by a primary domain and tenant ID.
- **Users** are identities; **security groups** (Assigned or Dynamic) are the unit you should manage access with.
- **Authentication** (proving who you are) is separate from **authorization** (what you may do) — a new user can sign in yet see zero subscriptions or resources.
- Azure resource access comes from **RBAC role assignments**, not from merely existing in the tenant (explored in Lab 12).
- **MFA** strengthens authentication by combining something you know, have, and are; Entra ID supports Authenticator, SMS, and FIDO2 keys.
