---
name: cloudflare-mcp
description: "Connect to Cloudflare's infrastructure via MCP Portal. Create databases, manage storage, deploy workers, run AI - all through natural language."
---

# Cloudflare MCP

> **This one takes effort to set up, but the payoff is extraordinary.**

Cloudflare powers ~20% of the internet. Databases, file storage, serverless functions, AI models, vector search, RAG pipelines, DNS, analytics, security - the full production stack.

What used to require 3-5+ years of DevOps experience, you now control through natural language and you essentially need 0 experience to start. Cursor + Liftoff become your senior infrastructure engineer - one that reads every page of documentation and builds the best architecture for your use case and can teach you along the way. You will learn by using it having a guardian angel watching over you and AI to automate/write/configure everything for you.

The connection uses an **MCP Portal** - a single URL bundling all Cloudflare tools behind one secure entry point. Once set up, everything from creating a database to deploying a Worker happens right here in conversation.

> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for MCP Portal creation, server selection, access policies, and agent config.

<!-- ═══════════════════════════════════════════════════ -->
<!-- BEFORE VS AFTER                                    -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Before vs After: Creating a D1 Database

**Without MCP (10-20 min manual):**
1. Open dashboard
2. Navigate to D1
3. Click Create
4. Name it
5. Copy ID
6. Open editor
7. Paste binding config
8. Write SQL
9. Paste in console
10. Run
11. Hope no typos
12. Test
13. Rewrite...

**With MCP:**
> "Create a D1 database and set up a users table." Done in one message.

---

## Servers We Skipped

| Server | Why Not |
|---|---|
| Containers | Docker-style edge containers. Skip if using Convex + Pages + Workers |
| Radar | 65 tools for internet traffic research. Exceeds tool budget |
| Browser Rendering | Redundant - Cursor has built-in browser tools |
| Logpush | Enterprise log delivery configuration |
| Audit Logs | Tracks "who changed what" - unnecessary for solo use |

---

## Troubleshooting

| Issue | Fix |
|---|---|
| "No allowed servers available" | Per-server Access policies missing (Step 4b) |
| No login page appears | Stale cookie. Visit `https://mcp.yourdomain.com/cdn-cgi/access/logout` |
| Tools not showing after changes | Restart Cursor to refresh tool list |

---

## All Available Servers (Reference)

| Server | Direct URL |
|---|---|
| Workers Bindings | `https://bindings.mcp.cloudflare.com/mcp` |
| Workers Builds | `https://builds.mcp.cloudflare.com/mcp` |
| Observability | `https://observability.mcp.cloudflare.com/mcp` |
| Documentation | `https://docs.mcp.cloudflare.com/mcp` |
| DNS Analytics | `https://dns-analytics.mcp.cloudflare.com/mcp` |
| Containers | `https://containers.mcp.cloudflare.com/mcp` |
| Browser Rendering | `https://browser.mcp.cloudflare.com/mcp` |
| AI Gateway | `https://ai-gateway.mcp.cloudflare.com/mcp` |
| AutoRAG | `https://autorag.mcp.cloudflare.com/mcp` |
| Logpush | `https://logs.mcp.cloudflare.com/mcp` |
| Audit Logs | `https://auditlogs.mcp.cloudflare.com/mcp` |
| Radar | `https://radar.mcp.cloudflare.com/mcp` |
| GraphQL | `https://graphql.mcp.cloudflare.com/mcp` |

Source: [cloudflare/mcp-server-cloudflare](https://github.com/cloudflare/mcp-server-cloudflare)

> [!TIP]
> The direct URLs are reference only. The Portal bundles everything behind one URL.

---

## Activation
- Enable in `~/.cursor/liftoff/extensions/extensions.json`: `"cloudflare-mcp": true`
- Triggered by: Cloudflare setup, backend infrastructure, D1, R2, Workers, deployment

---

## Agent Rules

- **Verify auth** before operations - guide through OAuth if not completed
- **Set active account first** - call `set_active_account` on each server before using its tools
- **Start with Bindings** - most infrastructure tasks go through Workers Bindings
- **Explain operations** - tell user what was created and relevant IDs/bindings
- **Respect free tier** - warn before paid-plan operations
- **Don't over-connect** - only suggest more servers if actually needed
- **Security-first** - destructive operations done manually in dashboard, not through MCP
