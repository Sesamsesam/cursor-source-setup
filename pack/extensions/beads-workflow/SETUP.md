---
name: beads-workflow-setup
description: "One-time installation and configuration for the Beads CLI context persistence tool."
---

# Beads Workflow - Setup Guide

> **One-time setup.** Once installed and initialized, the agent uses SKILL.md for daily operations. This file is not needed again.

## Quick Setup

The agent should use the correct install method for the user's OS (detected during package-manager setup):

- **macOS/Linux with Homebrew:** `brew install beads`
- **Any OS with bun:** `bun install -g --trust @beads/bd`
- **Any OS with pnpm:** `pnpm install -g @beads/bd`
- **Fallback:** `curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash`

After install:
```bash
cd your-project          # Go to your project folder
bd init                  # Initialize Beads in your project
```

Done. The agent handles `bd ready` / `bd sync` automatically from here.

> Full method table and details below.

---

## Step 1: Install the Beads CLI

Beads is a system-wide tool (like `git`). Do NOT clone the repo into your project.

| Method | Command | Best For | Updates |
|---|---|---|---|
| **Homebrew** | `brew install beads` | macOS/Linux | `brew upgrade beads` |
| **bun** | `bun install -g --trust @beads/bd` | JS developers | `bun update -g @beads/bd` |
| **pnpm** | `pnpm install -g @beads/bd` | JS fallback | `pnpm update -g @beads/bd` |
| **Script** | `curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh \| bash` | Any platform | Re-run script |
| **Go** | `go install github.com/steveyegge/beads/cmd/bd@latest` | Go devs (1.24+) | Re-run command |

> **New to Homebrew?** If you don't have it installed, check the Homebrew skill guide - it walks you through from scratch just ask you agent to look at it.

## Step 2: Verify

```bash
bd version
bd help
```

If you see a version number and the help menu, you're good.

**"bd: command not found"?** Close and reopen your terminal, or run `source ~/.zshrc` (macOS) / `source ~/.bashrc` (Linux). Or just ask the agent to fix it for you.

## Step 3: Initialize in Your Project

```bash
cd your-project
bd init
```

Creates `.beads/` in your project (tracked by git so context persists across machines).

**Init options:**
```bash
bd init --quiet        # Minimal output
bd init --stealth      # Local only, nothing committed (for shared repos)
bd init --contributor  # Open-source contributions (stores in ~/.beads-planning)
```

## Step 4: Editor Integration

**Cursor:**
```bash
bd setup cursor
```
Creates `.cursor/rules/beads.mdc` so the agent knows about Beads.

**VS Code (MCP Server):**
```bash
uv tool install beads-mcp
```
Then create `.vscode/mcp.json`:
```json
{
  "servers": {
    "beads": {
      "command": "beads-mcp"
    }
  }
}
```
Run `bd init --quiet` and reload VS Code.

**Cursor:** No additional setup needed - this extension handles everything.

<!-- CREW BRIEF -->
> **After setup is complete, tell the user:**
>
> "Beads is now active! This is a session memory tool Sami added to Liftoff so I can remember what we worked on between conversations.
>
> Without it, every time you start a new chat, I start fresh with no memory. With Beads, I pick up right where we left off - tasks, context, decisions, everything carries over.
>
> You don't need to do anything differently. I manage the memory automatically."
