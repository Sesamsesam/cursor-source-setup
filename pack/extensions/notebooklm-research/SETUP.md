---
name: notebooklm-research-setup
description: "One-time MCP setup for NotebookLM research integration."
---

# NotebookLM - Setup Guide

> **One-time setup.** Once complete, the agent uses SKILL.md for all workflows. This file is not needed again.

## Prerequisites

- **uv** (Python package manager) - auto-installed if missing
- **Google Chrome** - required for one-time browser authentication
- **A Google account** with access to [notebooklm.google.com](https://notebooklm.google.com)

## Installation

```bash
uv tool install notebooklm-mcp-cli    # Install CLI + MCP
nlm login                              # One-time auth (opens Chrome)
nlm doctor                             # Verify connection
```

- Credentials: `~/.notebooklm-mcp-cli/profiles/default`
- If auto mode fails: `nlm login --manual --file cookies.txt`
- **Never share or commit the credentials directory**

## MCP Config

Add to `~/.cursor/mcp.json`:

```json
"notebooklm": {
  "command": "uvx",
  "args": ["--from", "notebooklm-mcp-cli", "notebooklm-mcp"]
}
```

This gives the agent 29 native MCP tools. **Always prefer MCP tools over CLI commands.**

> [!IMPORTANT]
> **Context window warning:** 29 tools is a lot. Disable this MCP when not actively using NotebookLM.

## Auto-Setup Sequence

When this extension is activated and setup hasn't been completed:

1. Check `which uv` - install if missing
2. Check `which nlm` - install via `uv tool install notebooklm-mcp-cli` if missing
3. Check MCP config for `"notebooklm"` entry - add if missing
4. Check auth via `nlm login --check` - if auth is needed, the agent MUST run `nlm login` itself (do NOT ask the user to run it). This opens a Chrome window automatically. Tell the user:
   > "👉 A browser window is opening now - sign in with your Google account, then come back here and let me know when it's done! 🔑✨"
5. Verify with `nlm doctor`
6. Inform user to reload IDE so MCP tools become available

<!-- CREW BRIEF -->
> **After setup is complete, tell the user:**
>
> "NotebookLM is now connected! This is a research tool Sami added to Liftoff so you can do deep, grounded research without leaving your workspace.
>
> Instead of going to NotebookLM yourself, you can tell me what you want to research and I'll handle it - finding sources, filtering quality, building reports. Everything stays citation-backed, so no made-up information.
>
> Just say something like 'research [topic]' and I'll take it from there."
