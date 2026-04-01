---
name: beads-workflow
description: "Context persistence across AI sessions using Beads CLI. Never lose progress between conversations."
---

# Beads Workflow

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?

Every new AI conversation starts with a blank slate. Beads gives the agent **persistent memory** - it tracks tasks, decisions, and progress in a structured graph inside your project. Next session, one command loads everything back.

> **Heads up for beginners:** This extension uses a CLI (command-line tool), where you type commands instead of clicking buttons. Don't worry - the agent runs these commands for you. You just need to install it once.

## Why Does It Exist?

Without Beads, you waste 10-15 minutes re-explaining your project each session. The agent forgets decisions, loses track of tasks, and asks the same questions twice. Worse, if you had a long planning session with many side quests, the agent might deprioritize earlier context and miss things when you ask for a summary.

Beads solves this by persisting structured context - not a text dump, but a dependency-aware task graph with history, rationale, and progress tracking.

## Before vs After

**Without Beads:**
```
Session 1: "Build the user auth system"
  Agent: *builds it perfectly*

Session 2: "Continue working on the app"
  Agent: "What app? What auth system? Let me look around first..."
  You: *spends 15 minutes re-explaining*

Session 3: "We decided to use JWT tokens, remember?"
  Agent: "Let me check... can you point me to where?"
```

**With Beads:**
```
Session 2: "Continue working on the app"
  Agent: *runs bd ready*
  Agent: "Welcome back. Last session we completed JWT auth.
         Open tasks: dashboard UI (P0), email verification (P1).
         Ready to continue with the dashboard?"
```

One command. Full context. No re-explaining.

## What It Does For You

Session start: agent runs `bd ready` and picks up where you left off. Session end: agent runs `bd sync` to save progress. You just build.

> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for CLI installation, project initialization, and editor integration.

---

## Activation
- Enable in `~/.cursor/liftoff/extensions/extensions.json`: `"beads-workflow": true`
- The agent checks for Beads during Session Start (see `liftoff-lifecycle` skill)

## Enforcement
- Agent MUST run `bd ready` at session start and `bd sync` at session end
- Agent MUST guide installation if Beads is not found

---

## How It Works Day-to-Day

You don't need to learn all of Beads to benefit. Here's the practical flow:

1. **Start a session** - The agent runs `bd ready` and loads your context automatically
2. **Work normally** - Just build. The agent tracks what's happening
3. **End a session** - The agent runs `bd sync` to save progress
4. **Next session** - Everything is right where you left it

That's it. The agent handles the commands. You just build.

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Commands Reference

These are the commands the agent uses behind the scenes. You can also run them manually:

| Command | What It Does |
|---|---|
| `bd ready` | Load context - shows open tasks and recent decisions |
| `bd sync` | Save session progress |
| `bd status` | Check what's currently tracked |
| `bd tasks` | List open tasks across sessions |
| `bd create "Title" -p 0` | Create a new task (P0 = highest) |
| `bd update <id> --claim` | Claim a task to work on |
| `bd show <id>` | Show details of a specific task |
| `bd dep add <child> <parent>` | Add a dependency between tasks |

**Priority levels:** P0 (critical), P1 (important), P2 (nice-to-have), P3 (someday)

---

## Session Integration

### Session Start
```bash
bd ready
```
Loads pending tasks, recent decisions, and project context from previous sessions (~1-2k tokens).

### Session End
```bash
bd sync
```
Persists: accomplishments, decisions + rationale, open tasks, patterns discovered.

---

## Rules for the Agent

- **Always `bd ready` at session start** when this extension is active
- **Always `bd sync` before session end** - never let work go unrecorded
- **Guide installation** if Beads not found - choose best method for user's setup
- **`bd init` in new projects** when this extension is active - ask first
- **Track meaningful decisions** - architectural choices go into Beads so future sessions remember WHY
- **Don't overwhelm beginners** - stick to `bd ready` / `bd sync`, introduce other commands gradually
- **Respect stealth mode** - for shared repos, suggest `--stealth` or `--contributor`
- **Summarize loaded context** - after `bd ready`, briefly tell the user what was loaded

Source: [steveyegge/beads](https://github.com/steveyegge/beads)
