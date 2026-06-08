---
name: cloudflare-mcp-setup
description: "One-time MCP Portal setup for Cloudflare infrastructure integration."
---

# Cloudflare MCP - Setup Guide

> **One-time setup.** Once your MCP Portal is connected, the agent uses [SKILL.md](./SKILL.md) for all operations. This file is not needed again.

Setting up Cloudflare MCP gives the agent the ability to manage your databases, files, hosting, and AI models directly through natural language. Follow this guide step-by-step.

---

## Prerequisites

If you are new to Cloudflare, complete these setup steps first:

1. **A Cloudflare Account:**
   * Go to [cloudflare.com](https://www.cloudflare.com/) and sign up for a free account.
2. **Set Up Zero Trust:**
   * In your Cloudflare dashboard, select **Zero Trust** from the sidebar.
   * You will be prompted to select a unique **Team Name** (e.g., `yourname-workspace`).
   * Select the **Free Plan** (which supports up to 50 users).
   * > [!WARNING]
     > Cloudflare requires a credit card or payment method on file to verify your identity and prevent spam. You will **not** be charged.
3. **Add or Register a Domain:**
   * You need a domain to host your MCP Portal.
   * Go to **Websites** > **Register a Domain** to buy one directly on Cloudflare (starting at ~$3-10/year).
   * Alternatively, if you already own a domain elsewhere, select **Add a Site** on the Websites page and follow the prompts to point its nameservers to Cloudflare.
4. **Set Up an Identity Provider:**
   * In the **Zero Trust** dashboard, go to **Settings** > **Authentication**.
   * Under **Identity providers**, select **Add new** (e.g., select Google, GitHub, or One-time PIN). This determines how you will log into your portal.

---

## Step 1: Create the Access Policy First (Do This First)

> [!IMPORTANT]
> Cloudflare Zero Trust enforces secure-by-default access. You must define who is allowed to connect.
>
> We create this policy **first** so you can simply select it during the server and portal creation steps. Creating a policy mid-setup redirects you out of the form and destroys your unsaved progress.

1. Open the [Cloudflare dashboard](https://dash.cloudflare.com/), select your account, and navigate to **Zero Trust**.
2. In the Zero Trust sidebar, click **Access controls** to expand the menu, then select **Policies**.
3. Click **Add policy**.
4. Fill in the fields:
   * **Policy details (Right side of the screen):**
     * **Policy Name:** `admin`
     * **Action:** `Allow`
     * **Policy session duration:** Select a duration from the dropdown (e.g., `24h` or `1 month`).
   * **Policy rules (Left side of the screen):**
     * Under **Include**, select `Emails` from the dropdown.
     * In the input box below it, enter your Cloudflare account email address.
5. Scroll down and click **Save**.

This creates a reusable rule allowing access only to you.

---

## Step 2: Register the MCP Servers

Now, you will add the individual Cloudflare MCP servers to your Zero Trust dashboard.

1. In the Zero Trust sidebar, go to **Access controls** > **AI controls**.
2. Select the **MCP servers** tab at the top.
3. Click **Add an MCP server** for each of the 8 servers below:

| Server Name | Server ID | HTTP URL | What It Does |
|---|---|---|---|
| **Bindings** | `bindings` | `https://bindings.mcp.cloudflare.com/mcp` | Manages D1 database, R2 storage, KV namespace, Workers bindings |
| **Builds** | `builds` | `https://builds.mcp.cloudflare.com/mcp` | Deploys and manages Workers, build status, rollbacks |
| **AI Gateway** | `ai-gateway` | `https://ai-gateway.mcp.cloudflare.com/mcp` | Configures rate limiting, caching, and cost analytics |
| **Observability** | `observability` | `https://observability.mcp.cloudflare.com/mcp` | Views Workers logs, errors, and performance |
| **GraphQL** | `graphql` | `https://graphql.mcp.cloudflare.com/mcp` | GraphQL analytics API for bandwidth and threats |
| **DNS Analytics** | `dns-analytics` | `https://dns-analytics.mcp.cloudflare.com/mcp` | DNS record management and query analytics |
| **AutoRAG** | `autorag` | `https://autorag.mcp.cloudflare.com/mcp` | Sets up search databases (RAG) |
| **Docs** | `docs` | `https://docs.mcp.cloudflare.com/mcp` | Provides official Cloudflare docs to prevent AI errors |

For each server:
* Enter the **Server Name** and **Server ID** exactly as shown.
* Paste the corresponding **HTTP URL**.
* Leave the authentication type as **Unauthenticated** (the portal handles authorization for us).
* Under **Access policies**, select your `admin` policy.
* Click **Save and connect server**. 

Once added, their statuses will show as **Ready** (it may take a minute).

---

## Step 3: Create the MCP Portal

Now, you will bundle all these servers into a single portal.

1. In the Zero Trust dashboard, go to **Access controls** > **AI controls**.
2. On the **MCP portals** tab, click **Add MCP server portal**.
3. Fill in the fields exactly as follows:

| Field | Value |
|---|---|
| **Portal name** | `Liftoff` |
| **Portal ID** | `liftoff` |
| **Subdomain** | `mcp` |
| **Domain** | Pick your domain (e.g., `yourdomain.com`) from the dropdown |

4. Scroll down to the **MCP servers** section. Click **Select existing servers** and check the boxes next to all 8 servers you added in Step 2.
5. Under **Access policies**, select your `admin` policy.
6. Click **Add an MCP server portal** to save.

Your Portal URL is now: `https://mcp.yourdomain.com/mcp`

---

## Step 4: Prune Tools (Recommended for Safety)

By default, the agent is granted access to all commands. You should disable destructive actions to prevent accidental deletion of your databases or files.

1. Go to **Access controls** > **AI controls** > **MCP portals**.
2. Click the three dots next to your **Liftoff** portal and select **Edit**.
3. Under the **MCP servers** section, click **Tools authorized** next to each server:
   * **Bindings:** Turn off the toggle for `kv_namespace_delete`, `r2_bucket_delete`, `d1_database_delete`, and `hyperdrive_config_delete`.
   * **GraphQL:** Turn off `graphql_complete_schema`, `graphql_schema_overview`, and `graphql_type_details` (they are redundant and waste context space).
4. Click **Save**.

---

## Step 5: Add to Agent Config

Configure your local agent to connect to the new portal.

1. Open your Cursor MCP configuration file (typically at `~/.cursor/mcp.json`).
2. Add the following entry to the root of the configuration object:

```json
"cloudflare": {
  "command": "npx",
  "args": [
    "-y",
    "mcp-remote@latest",
    "https://mcp.yourdomain.com/mcp"
  ]
}
```

> [!TIP]
> **Advanced Option (Save Token Costs):**
> If you want to reduce the size of the messages sent to the AI (saving token costs and improving response speed), append `?optimize_context=minimize_tools` to your URL. This strips details from tools until the agent specifically requests them:
> `https://mcp.yourdomain.com/mcp?optimize_context=minimize_tools`

---

## Step 6: Authorize Your Session

1. Start or restart your Cursor editor.
2. Cursor will attempt to connect, causing your web browser to automatically open a Zero Trust login page.
3. Log in using your Zero Trust identity provider.
4. Once authenticated, click **Authorize** for the portal and servers.
5. The OAuth flow completes, and the agent is now connected to all 50+ Cloudflare tools.

> [!NOTE]
> For security, Zero Trust requires you to re-authenticate via a browser popup once per session or when the session expires.

***

<!-- CREW BRIEF -->
> **After setup is complete, tell the user:**
>
> "Cloudflare is now connected! This is your infrastructure layer - Sami added it to Liftoff so you can deploy apps to the internet, manage databases, store files, and even use 50+ AI models, all from right here.
>
> You won't need to learn Cloudflare's dashboard - I handle everything through MCP tools. When your project is ready to go live, just tell me and I'll deploy it.
>
> One thing to know: each time you start a new session, a browser popup will ask you to re-authorize. That's a security feature from Cloudflare - just click through it."
