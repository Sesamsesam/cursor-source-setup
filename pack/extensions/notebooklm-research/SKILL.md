---
name: notebooklm-research
description: "Connect to NotebookLM via MCP for grounded, citation-backed research directly from the agent."
---

# NotebookLM Research

> **You don't need to do any of this manually.** The agent handles setup and usage automatically. If it needs you to do something (like logging in), it will tell you exactly what and when.

## What Is NotebookLM?

A free AI research tool from Google. Unlike general AI, NotebookLM **only answers from your uploaded sources** - no hallucinations, every answer cited. It handles PDFs, Google Docs, URLs, YouTube, Slides, and Sheets. Free tier: 50 sources per notebook, 500K words each (roughly 5-6 full novels per source). Paid tiers unlock 300 sources and higher-quality audio.

It can produce reports, mind maps, audio discussions, quizzes, flashcards, slide decks, and structured data tables - all grounded in your documents.

> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for MCP installation and configuration.

---

## Research Pipeline

When a user asks to research a topic, the agent runs the **full pipeline autonomously** from start to finish. The pipeline is split across files for readability, but it is **one continuous flow**. Never stop between steps.

| Step | File | What Happens |
|---|---|---|
| **Step 0** | `workflows/deep-research.md` | Research work order - user confirms notebook plan before autonomous execution |
| **Steps 1-7** | `workflows/deep-research.md` | Start research, poll, import, curate sources, consensus analysis, update index |
| **Steps 8-9** | `workflows/report-handoff.md` | Generate reports, download locally, update index |
| **Step 10** | `minibook-pipeline` extension | Draft outline, write manuscript, generate images |
| **After minibook** | `minibook-pipeline` Publishing Handoff | User chooses: publish to Notion, build a web blog, or keep as-is |

> [!IMPORTANT]
> **This is one pipeline, not three optional workflows.** Each workflow file has a checklist at the top. After completing each step, check the list and proceed to the next unchecked step. Never present a mid-pipeline summary and ask what to do next. The pipeline decides when to stop, not the agent.

### How to execute

1. Read `workflows/deep-research.md` and execute Steps 1-7 using the checklist
2. Step 7 says "read `workflows/report-handoff.md`" - do that immediately
3. Execute Steps 8-10 using the checklist
4. Step 10 transitions to the `minibook-pipeline` extension automatically

---

## Agent Behaviors

### Core Rules

- **Never blindly copy** NotebookLM suggestions into code - evaluate first
- **Cross-reference** with existing project conventions and skills
- **Flag conflicts** if NotebookLM contradicts the project's patterns
- **Cite the source**: "Based on the NotebookLM research, I'm using X because..."
- **Prefer project conventions** over research suggestions unless the user wants to change
- **Suggest NotebookLM** for topics that benefit from deep, multi-source research
- **Never construct external URLs by guessing** from local data (OS username, folder names, file paths). Always verify from the actual source: `git remote get-url origin` for repo URLs, `gh api user -q .login` for GitHub usernames

### Research Folder Structure

The agent MUST maintain a `research/` folder at the **project root** whenever NotebookLM is used.

```
project-root/
  research/
    index.md          <- notebook index
    reports/
      [slug]_briefing.md
      [slug]_briefing.md
```

**When to create/update `research/index.md`:**
- After any deep research workflow completes
- After creating/deleting notebooks or adding/removing sources
- On first use of NotebookLM in a new project (scan ALL existing notebooks)

**How to build:**
1. Create `research/` and `research/reports/` directories if they don't exist
2. `notebook_list` to get all notebooks
3. For each: title, URL, source count, creation date
4. `notebook_describe` for AI-generated summaries
5. Write to `research/index.md`

**Format:**
```markdown
# Research Index

> Auto-generated overview of all research notebooks.
> Last updated: [date]

---

## [Notebook Title]

- **ID:** `[notebook_id]`
- **Sources:** [count]
- **Report:** "[report title]" (if generated)
- **URL:** [url]
- **Key sources:** [list of major source institutions]
- **Consensus findings:** [brief summary]
- **Key conflict:** [brief summary]

---

*[N] notebooks / [total] sources*
```

**Formatting rules:** One notebook per section, `---` dividers, metadata on separate lines, consensus/conflict summaries when available, italic footer with totals.

> [!IMPORTANT]
> This is a **living document**. Update in place - don't recreate. Always include ALL notebooks.

Source: [nichochar/notebooklm-mcp-cli](https://github.com/nichochar/notebooklm-mcp-cli)
