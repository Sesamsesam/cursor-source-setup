---
name: notion-publishing-setup
description: "One-time setup: connect Notion MCP via OAuth for publishing manuscripts and reports."
---

# Notion Publishing - Setup

> **This runs once.** After setup, the agent can publish to Notion anytime without repeating these steps.

## Checklist

- [ ] Step 1: Add Notion MCP to config
- [ ] Step 2: Complete OAuth authorization
- [ ] Step 3: Verify connection

---

### Step 1: Add Notion MCP to Config

Notion provides a **hosted remote MCP server** with OAuth authentication. No API keys, no npm packages to manage.

Add to **`~/.cursor/mcp.json`** (user MCP config) or the project MCP file your Cursor version uses:

```json
{
  "mcpServers": {
    "notion": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://mcp.notion.com/mcp"
      ]
    }
  }
}
```

This uses `mcp-remote` as a bridge to Notion's hosted server. On first connection, it opens a browser for OAuth authorization.

> [!NOTE]
> Using a different AI client? See the [official Notion MCP setup guide](https://developers.notion.com/guides/mcp/get-started-with-mcp) for Cursor, Windsurf, VS Code, Claude Desktop, and other tools.

Tell the user:

> "I've added the Notion MCP connection to your config. Restart Cursor and a browser window will open asking you to authorize Notion access.
>
> Click **Allow access** and select the workspace you want to publish to.
>
> Reply with **'done'** when you've completed the authorization."

Wait for the user to confirm.

---

### Step 2: Complete OAuth

After the user says "done", verify the connection in Step 3.

If the OAuth prompt did not appear:

> "The authorization window didn't open. Try restarting Cursor again. The browser prompt should appear automatically when the MCP server starts."

---

### Step 3: Verify Connection

Test the connection by searching for pages:

Use `notion-search` to find any page. If it returns results, the connection works. If it returns empty results, the connection is live but no pages are shared yet (which is fine - OAuth gives access to whatever the user authorized).

If it fails with an auth error:

> "The connection isn't working yet. Let's try:
>
> 1. Restart Cursor to trigger the OAuth prompt again
> 2. Make sure you clicked **Allow** on the Notion authorization page
> 3. Check that you selected the correct workspace
>
> Want to try again?"

Once verified:

> "Notion is connected! I can now publish manuscripts, reports, and minibooks directly to your Notion workspace - including images, callouts, tables, and all formatting.
>
> Whenever you finish writing something, just say 'publish to Notion' and I'll handle everything."

> ✅ **Setup complete.**
