---
name: firecrawl
description: "Scrape, crawl, and convert any website into clean structured data. Extract content from JavaScript-heavy sites, crawl entire domains, and pull structured data - all through natural language."
---

# Firecrawl

> **Turn any website into clean, usable data in one message.**

Firecrawl is a web scraping and crawling engine built specifically for AI agents. Cursor can already read individual web pages and search the internet on its own. Firecrawl goes further - it can read websites that are built with heavy animations and frameworks (which normally come back blank), crawl entire sites by following every link, and pull structured data like prices, names, and dates into clean organized formats.

**500 free credits per month** (1 credit = 1 page). No credit card required.

---

## Real Use Cases

Here's what you can ask the agent to do once Firecrawl is active:

- **"Do a quick analysis of your clients web sources** - Get all pages, and relevant info of a client or prospects website.

- **"Scrape this competitor's pricing page and compare it to ours"** - Works even on sites built with React or other frameworks that normally can't be read

- **"Pull all blog posts from this WordPress site so we can rebuild it"** - Crawls the entire blog, returns clean content per post

- **"Extract the layout, colors, and structure from this site I like"** - Design inspiration extraction

- **"Grab all job listings from these 5 career pages as a spreadsheet"** - Pulls structured data across multiple URLs in one go

- **"Crawl this entire docs site so I can feed it into NotebookLM"** - Discovers every page on a site and extracts all the content

> [!NOTE]
> The agent will automatically choose between its built-in tools and Firecrawl depending on the task. For simple, single-page reads it won't use credits. Firecrawl only kicks in when needed.


> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for API key and MCP configuration.

---

## Pricing

| Tier | Cost | Credits | Rate Limit |
|---|---|---|---|
| **Free** | $0 | 500/month | ~10 requests/min |
| **Hobby** | $16/month | 3,000/month | Higher limits |
| **Standard** | $83/month | 100,000/month | Higher limits |

1 credit = 1 page scraped or crawled. The free tier is enough for occasional scraping tasks and project work.

<!-- ═══════════════════════════════════════════════════ -->
<!-- TOOLS                                              -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Available Tools

Firecrawl provides 12 tools through MCP. Here are the ones you will use most:

### Core Tools

| Tool | What It Does | Credits |
|---|---|---|
| `firecrawl_scrape` | Scrape a single URL into Markdown/JSON. Renders JavaScript | 1/page |
| `firecrawl_crawl` | Crawl an entire site following links, with depth and limit controls | 1/page discovered |
| `firecrawl_map` | Discover all URLs on a site without scraping content (sitemap discovery) | 1 |
| `firecrawl_search` | Web search with optional scraping of results | 1/result scraped |
| `firecrawl_extract` | Extract structured data using a JSON schema + natural language prompt | Varies |
| `firecrawl_agent` | Autonomous deep research - give it a prompt, it crawls and finds answers | Varies |

### Status & Session Tools

| Tool | What It Does |
|---|---|
| `firecrawl_check_crawl_status` | Check progress of an async crawl job |
| `firecrawl_agent_status` | Check status of an async agent research job |
| `firecrawl_browser_create` | Create a persistent browser session for multi-step interactions |
| `firecrawl_browser_execute` | Execute code in an existing browser session |
| `firecrawl_browser_delete` | Close a browser session |
| `firecrawl_browser_list` | List active browser sessions |

### Tool Examples

**Scrape a single page:**
```json
{
  "name": "firecrawl_scrape",
  "arguments": {
    "url": "https://example.com",
    "formats": ["markdown"],
    "onlyMainContent": true
  }
}
```

**Crawl an entire docs site:**
```json
{
  "name": "firecrawl_crawl",
  "arguments": {
    "url": "https://docs.example.com",
    "maxDiscoveryDepth": 2,
    "limit": 50,
    "deduplicateSimilarURLs": true
  }
}
```

**Extract structured data:**
```json
{
  "name": "firecrawl_extract",
  "arguments": {
    "urls": ["https://example.com/pricing"],
    "prompt": "Extract all pricing tiers with name, price, and features",
    "schema": {
      "type": "object",
      "properties": {
        "tiers": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": { "type": "string" },
              "price": { "type": "number" },
              "features": { "type": "array", "items": { "type": "string" } }
            }
          }
        }
      }
    }
  }
}
```

**Discover all URLs on a site:**
```json
{
  "name": "firecrawl_map",
  "arguments": {
    "url": "https://example.com",
    "limit": 100,
    "ignoreQueryParameters": true
  }
}
```

<!-- ═══════════════════════════════════════════════════ -->
<!-- CONFIGURATION                                      -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Advanced Configuration

Optional environment variables for power users (add to the `env` block for the Firecrawl MCP entry in `~/.cursor/mcp.json`):

| Variable | Default | Purpose |
|---|---|---|
| `FIRECRAWL_RETRY_MAX_ATTEMPTS` | 3 | Max retry attempts on failure |
| `FIRECRAWL_RETRY_INITIAL_DELAY` | 1000 | Initial delay (ms) before first retry |
| `FIRECRAWL_RETRY_MAX_DELAY` | 10000 | Max delay (ms) between retries |
| `FIRECRAWL_RETRY_BACKOFF_FACTOR` | 2 | Exponential backoff multiplier |
| `FIRECRAWL_CREDIT_WARNING_THRESHOLD` | 1000 | Warn when credits drop below this |
| `FIRECRAWL_CREDIT_CRITICAL_THRESHOLD` | 100 | Critical alert threshold |
| `FIRECRAWL_API_URL` | (cloud) | Custom endpoint for self-hosted instances |

---

## Activation
- Enable in `~/.cursor/liftoff/extensions/extensions.json`: `"firecrawl": true`
- Triggered by: web scraping, site crawling, data extraction, content migration, competitive analysis

---

## Agent Rules

- **Conserve credits** - Always prefer `read_url_content` for simple single-page reads. Only use Firecrawl when JavaScript rendering, multi-page crawling, or structured extraction is needed
- **Set reasonable limits** - When crawling, always set `limit` and `maxDiscoveryDepth` to avoid burning through credits on large sites
- **Use `firecrawl_map` first** - Before crawling a full site, map it to see how many pages exist and decide on scope
- **Prefer `onlyMainContent: true`** - Strips nav, footer, and ads for cleaner output
- **Warn about credit usage** - Tell the user how many credits an operation will roughly consume before running large crawls
- **Respect free tier** - 500 credits/month. A 50-page crawl uses 50 credits. Always estimate before executing
- **Use `firecrawl_extract` for structured data** - When the user needs specific fields (prices, names, dates), use extract with a schema rather than scraping raw content and parsing manually
- **Async for large jobs** - Crawls of 20+ pages should use `firecrawl_crawl` which returns a job ID, then poll with `firecrawl_check_crawl_status`

Source: [Firecrawl MCP Docs](https://docs.firecrawl.dev/mcp-server) | [GitHub](https://github.com/mendableai/firecrawl-mcp-server)
