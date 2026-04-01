---
name: firecrawl-setup
description: "One-time API key and MCP configuration for the Firecrawl web scraping extension."
---

# Firecrawl - Setup Guide

> **One-time setup.** Once the API key is configured, the agent uses SKILL.md for all scraping operations. This file is not needed again.

## Prerequisites

1. **A Firecrawl account** - [Sign up free](https://www.firecrawl.dev/) (no credit card required)
2. **An API key** - Get one at [firecrawl.dev/app/api-keys](https://www.firecrawl.dev/app/api-keys)

That's it. No domain, no infrastructure, no OAuth flows.

---

## Step 1: Get the API Key

1. Go to [firecrawl.dev/app/api-keys](https://www.firecrawl.dev/app/api-keys)
2. Sign in (or create account)
3. Copy the API key (format: `fc-XXXXXXXX`)

## Step 2: Add to Agent Config

Add to `~/.cursor/mcp.json`:

```json
"firecrawl": {
  "command": "npx",
  "args": ["-y", "firecrawl-mcp"],
  "env": {
    "FIRECRAWL_API_KEY": "fc-YOUR_API_KEY_HERE"
  }
}
```

## Step 3: Restart Cursor

Restart the agent session. The Firecrawl tools will appear in the MCP tool list automatically.

> [!NOTE]
> No OAuth, no browser popup, no re-authorization per session. The API key handles everything.

<!-- CREW BRIEF -->
> **After setup is complete, tell the user:**
>
> "Firecrawl is now connected! This is a web scraping tool Sami added to Liftoff so I can read and extract data from any website for you.
>
> Need to pull content from a page, scrape product listings, or convert a website into clean data? Just give me the URL and tell me what you need. I handle the rest."
