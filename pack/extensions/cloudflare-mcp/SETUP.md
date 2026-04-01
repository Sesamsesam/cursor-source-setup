---
name: cloudflare-mcp-setup
description: "One-time MCP Portal setup for Cloudflare infrastructure integration."
---

# Cloudflare MCP - Setup Guide

> **One-time setup.** Once the MCP Portal is connected, the agent uses SKILL.md for all operations. This file is not needed again.

## Prerequisites

1. **A Cloudflare account** - [Sign up free](https://www.cloudflare.com/). The free tier is genuinely generous - D1, R2, Workers, and KV all have free tiers
2. **A domain on Cloudflare** - You need one to create an MCP Portal. If you're building apps that go live on the internet, you need a domain anyway. Example: `yourdomain.com`
3. **Identity provider in Zero Trust** - Google, GitHub, or one-time PIN, the Agent will guide you.

---

## Step 1: Create the MCP Portal

`dash.cloudflare.com` > Zero Trust > Access controls > AI controls > **Add MCP server portal**

| Field | Value |
|---|---|
| Portal name | `Liftoff` |
| Portal ID | `liftoff` |
| Subdomain | `mcp` |
| Domain | Pick any domain from your account |

Portal URL: `https://mcp.yourdomain.com/mcp`

## Step 2: Add MCP Servers

Click **Select existing servers** and add these 8:

| Server | What It Does |
|---|---|
| **Bindings** | **The big one.** D1, R2, KV, Workers, Hyperdrive. 50+ built-in AI models (Workers AI) |
| **Builds** | Deploy/manage Workers. Build triggers, status, rollback |
| **AI Gateway** | Route between AI providers. Rate limiting, caching, cost analytics |
| **Observability** | Workers logs, error traces, performance metrics |
| **GraphQL** | Analytics API. Bandwidth, requests, threats |
| **DNS Analytics** | DNS records, query analytics, propagation |
| **AutoRAG** | RAG pipelines, searchable knowledge bases |
| **Docs** | Search official documentation (prevents hallucinated APIs) |

## Step 3: Prune Tools (Recommended)

Click **Tools authorized** for each server. Two optimizations:

**Remove destructive operations** (do deletes manually for safety):
- Bindings: turn off `kv_namespace_delete`, `r2_bucket_delete`, `d1_database_delete`, `hyperdrive_config_delete`

**Remove redundant tools:**
- GraphQL: turn off `graphql_complete_schema`, `graphql_schema_overview`, `graphql_type_details` (redundant with `graphql_schema_search`)

Result: ~52 active tools across 8 servers.

## Step 4: Create Access Policies

> [!CAUTION]
> Most common error: "No allowed servers available." Cloudflare has deny-by-default at **two levels** - portal AND each server.

**4a: Portal Policy**
Portal > Policies tab > Create: name `admin`, Action Allow, Selector Emails, Value: your Cloudflare email. This is so only you are allowed to use the MCP Portal.

**4b: Per-Server Policies**
Access controls > Applications. Each MCP server = separate app. For **each one**: click name > Policies tab > assign `admin` policy > Save.

Without 4b, the portal authenticates you but shows zero servers.

## Step 5: Add to Agent Config

Add to `~/.cursor/mcp.json`:

```json
"cloudflare": {
  "command": "npx",
  "args": ["-y", "mcp-remote", "https://mcp.yourdomain.com/mcp"]
}
```

One URL. One config entry. All 8 servers, 52 tools.

## Step 6: Authorize

1. Start (or restart) Cursor
2. Browser opens: "Connect to Cursor"
3. Check servers, click **Authorize** for each
4. OAuth completes - connected

> [!NOTE]
> Each new session requires re-authorization via Zero Trust popup. Security feature, not a bug.

<!-- CREW BRIEF -->
> **After setup is complete, tell the user:**
>
> "Cloudflare is now connected! This is your infrastructure layer - Sami added it to Liftoff so you can deploy apps to the internet, manage databases, store files, and even use 50+ AI models, all from right here.
>
> You won't need to learn Cloudflare's dashboard - I handle everything through MCP tools. When your project is ready to go live, just tell me and I'll deploy it.
>
> One thing to know: each time you start a new session, a browser popup will ask you to re-authorize. That's a security feature from Cloudflare - just click through it."
