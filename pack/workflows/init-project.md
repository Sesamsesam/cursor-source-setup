---
description: "Initialize a new project with Git, GitHub, scaffolding, and all guardrails (Cursor + Liftoff)."
---

# Init Project Workflow

## When To Use
Run this workflow when creating a brand new project from scratch.

> [!IMPORTANT]
> **Do not use F.O.R.G.E. for this workflow.** This is a standardized setup with no design decisions to approve. Do not create an implementation plan or ask for review. Execute directly. The first thing the user should see is the PROBE discovery question.

## Steps

### 0. Silent Setup (no user interaction)

Before asking the user anything, silently set up the project infrastructure:

1. Create **`.cursor/`** in the project root (and **`.cursor/rules/`** if linking a single rule file).
2. Symlink **`liftoff-core.mdc`**, **`extensions/`**, and **`user-extensions/`** to their global locations under **`~/.cursor/liftoff/`** (see Step 9 for exact commands).
3. Create **`.gitignore`** with the Liftoff symlink entries (see Step 4 for exact content).

These are the same for every project type. Do not show output or ask for approval.

### 1. Opening Question

> "We are ready for take-off! What do you want to work on or build?"

Wait for the user's answer before proceeding.

### 2. P.R.O.B.E. Discovery

**P**roject **R**equirements **O**utline and **B**uild **E**valuation

Based on the user's answer, ask 1-2 dynamic follow-up questions to extract what you need for classification and scaffolding. Only ask what you genuinely need. Stop asking when you have enough to classify and build the probe plan.

#### Internal Classification (never share with user)

Based on the answers, silently classify into one of three scaffold types:

| Signal | Classification | Scaffold |
|---|---|---|
| Mentions building an app, website, dashboard, SaaS, tool with UI | **App** | React + Vite (stack-pro-max defaults) |
| Mentions blog, portfolio, documentation, marketing page, landing page | **Static Site** | Astro |
| Mentions research, MCP tools, NotebookLM, Notion, data analysis, no UI | **Research / Tools** | Bare repo (git + README + .gitignore only) |
| Unclear or mixed | **Bare repo** | Can add framework later |

**Never ask the user** "Is this a dynamic app or a static site?" - this is jargon they may not understand. The classification is always an internal agent decision.

#### Create PROBE Plan

After discovery, create `probe-plan.md` in the project root containing:

1. **Project summary** (one paragraph, from the user's own words)
2. **Classified type** (App / Static Site / Research / Tools)
3. **Recommended extensions** to activate
4. **Scaffold decision** (what will be set up)
5. **Immediate next steps** (3-5 bullet points)

**If classified as App**, add this note at the top:

> "This is a shorthand plan to get you started quickly. For a professional, comprehensive application, ask your agent to use **O.R.B.I.T.** to plan thoroughly before you build."

Present the plan to the user for quick approval, then proceed to scaffolding.

#### Backend Detection (internal - never share with user)

After classifying the project, scan the user's answers for signals that imply infrastructure needs they may not know how to articulate:

| User says (examples) | What it means | Add to probe plan |
|---|---|---|
| "users log in," "accounts," "sign up," "members" | Auth needed | "Your app needs a way for users to log in. We use Clerk for that - I'll set it up when we start building." |
| "save data," "remember," "store posts," "user profiles" | Database needed | "Your app needs a place to store data. We use Convex for that - it's real-time and handles everything automatically." |
| "payments," "subscriptions," "charge," "buy," "pricing" | Payments needed | "Your app will handle money, so we'll need a payment system. We typically use Stripe for that." |
| "deploy," "go live," "put it online," "share the link" | Hosting needed | "To put this on the internet, we'll use Cloudflare. I can set that up when you're ready to launch." |
| "research," "analyze," "study," "sources" | Research tools needed | Recommend NotebookLM extension |
| "scrape," "extract," "crawl," "pull data from" | Web scraping needed | Recommend Firecrawl extension |

Include detected needs in the probe plan's "Immediate next steps" section, explained in plain language. Never use terms like "backend," "server," or "infrastructure" unless the user used them first - describe what things DO, not what they're called.

<!-- CREW BRIEF -->
> **After presenting the probe plan, tell the user:**
>
> "This probe discovery is something Sami built into Liftoff so that instead of jumping straight into building, you start with a light outline and a clearer picture of what you're creating. It gives you clarity and gives me better context to help you.
>
> Check `probe-plan.md` in your folder view on the left sidebar. You can edit it, expand on it by chatting with me ('let's expand the probe and tell me more'), or if you're happy with it, we move on to the next steps."

### 3. Scaffold the project

Based on the PROBE classification:

**For apps (React + Vite):**
```bash
# turbo
bunx --bun create-vite@latest ./ -- --template react-ts
# turbo
bun install
```

> [!NOTE]
> Convex, Clerk, and other integrations are added when the user chooses to use them, not during init. If the user asks for a backend or auth, refer to the `stack-pro-max` skill for setup commands.

**For static sites (Astro):**
```bash
# turbo
bunx --bun create-astro@latest ./ -- --template minimal --no-install --no-git
# turbo
bun install
```

**For research / tools (bare repo):**
No framework scaffolding. Create these files directly:
- `README.md` with `# <project-name>` as the heading and the PROBE summary as the description
- `.gitignore` from the `git-flow` skill template

The project is ready for extension configuration.

### 4. Initialize Git
```bash
# turbo
git init
```

### 5. Extend `.gitignore`
The base `.gitignore` with Liftoff symlink entries was created in Step 0. Now extend it with the `git-flow` skill template entries (node_modules, .env*, .convex/_generated/, .wrangler/, etc.) and any project-specific patterns.

**Add these entries to `.gitignore` for every new project - these are symlinks to global Liftoff files under `~/.cursor/liftoff/` and must never be committed:**
```gitignore
# Liftoff global symlinks — local only (point to ~/.cursor/liftoff/)
.cursor/rules/liftoff-core.mdc
.cursor/extensions/
.cursor/user-extensions/
```

### 6. Create `.env.example`
```bash
# Required environment variables
# Copy this file to .env.local and fill in the values

# Add your project-specific variables below
```

Only add specific entries (Convex, Clerk, Cloudflare, etc.) when the user chooses to integrate those tools.

### 7. Set up CSS foundation
Create `src/index.css` with the design tokens from the `brand-identity` skill.

### 8. Create GitHub repository

Use the GitHub CLI to create a private repo and push the initial code:

```bash
# turbo
gh repo create <project-name> --private --source=. --remote=origin --push
```

Where `<project-name>` is derived from the folder name (lowercase, hyphenated). If the repo already exists, just add the remote:

```bash
git remote add origin https://github.com/<username>/<project-name>.git
```

> [!IMPORTANT]
> **Always create repos as private by default.** New users often don't realize their code is public. Only make a repo public if the user explicitly asks.

After creation, verify privacy:
```bash
# turbo
gh repo view --json visibility -q '.visibility'
# Expected: "PRIVATE". If not, fix immediately:
# gh repo edit --visibility private
```

<!-- CREW BRIEF -->
> **After the repo is created, tell the user (use this text closely, do not summarize):**
>
> "Your code is now backed up on GitHub - it's set to private so only you can see it.
>
> Check it out here: [https://github.com/<username>/<project-name>](https://github.com/<username>/<project-name>)
>
> If you go to your GitHub account you'll see I created a folder (a repository). As you build and work with me, your files get periodically saved there in the cloud - so at any time, from anywhere, your work is safe and accessible. Pretty cool right!"

### 9. Verify symlinks

The symlinks were created in Step 0. Verify they work:

**macOS / Linux:**
```bash
# turbo
mkdir -p .cursor/rules
mkdir -p ~/.cursor/liftoff/user-extensions

ln -sf ~/.cursor/liftoff/rules/liftoff-core.mdc .cursor/rules/liftoff-core.mdc
ln -sf ~/.cursor/liftoff/extensions .cursor/extensions
ln -sf ~/.cursor/liftoff/user-extensions .cursor/user-extensions
```

**Windows (PowerShell):**
```powershell
# turbo
New-Item -ItemType Directory -Force -Path .cursor\rules | Out-Null
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\liftoff\user-extensions" | Out-Null

cmd /c mklink /H .cursor\rules\liftoff-core.mdc "$env:USERPROFILE\.cursor\liftoff\rules\liftoff-core.mdc"
cmd /c mklink /J .cursor\extensions "$env:USERPROFILE\.cursor\liftoff\extensions"
cmd /c mklink /J .cursor\user-extensions "$env:USERPROFILE\.cursor\liftoff\user-extensions"
```

**What this creates in the project:**
```
my-project/
├── .cursor/
│   ├── rules/
│   │   └── liftoff-core.mdc   → ~/.cursor/liftoff/rules/liftoff-core.mdc
│   ├── extensions/            → ~/.cursor/liftoff/extensions/
│   │   ├── extensions.json
│   │   └── ...
│   └── user-extensions/       → ~/.cursor/liftoff/user-extensions/
├── src/
└── ...
```

Core **skills** remain in **`~/.cursor/skills/`** (global Cursor discovery). This project links **rules + extensions + user-extensions** only.

<!-- CREW BRIEF -->
> **After completing the symlinks, tell the user (use this text closely, do not summarize):**
>
> "Look at the Explorer sidebar on the left. You'll see a `.cursor/` folder - expand it. Inside, `extensions/` lists Liftoff extensions and `extensions.json` toggles them. Global skills live in your user Cursor skills folder - I will recommend and set up extensions when your project needs them."

### 10. Initial commit and push

Create the Liftoff init marker:
```bash
# turbo
touch .cursor/.liftoff-init
```

```bash
git add .
git commit -m "chore: scaffold project with Liftoff (Cursor) defaults"
git push -u origin main
```

### 11. Suggest extensions

After everything is set up, tell the user:

> "Your project is ready and pushed to GitHub (private).
>
> Before we start building, would you like to connect any tools? The two most popular ones to start with are:
>
> 1. **NotebookLM** - AI-powered research assistant for grounded, citation-backed content
> 2. **Notion** - Knowledge base and project documentation
>
> I can set either of these up right now, or you can activate any extension later from `.cursor/extensions/extensions.json`."

Only suggest, never auto-activate. If the user picks one, follow the **Activation Flow** from the Skill Discovery & Extension Lifecycle rules in the `liftoff-lifecycle` skill.

### 12. Verify
- [ ] `bun run dev` starts without errors (only if user asks to start the server)
- [ ] `.gitignore` covers all sensitive patterns and Liftoff symlinks
- [ ] `.env.example` exists (`.env.local` does NOT exist in repo)
- [ ] CSS tokens are in place (for app/static scaffolds)
- [ ] `.cursor/extensions/` shows all extensions and `extensions.json`
- [ ] `.cursor/rules/liftoff-core.mdc` resolves (symlink or hard link)
- [ ] GitHub repo exists and is private

### 13. Report
Tell the user:

> "Project scaffolded with [type].
>
> - Git initialized and pushed to GitHub (private)
> - Extensions and config linked in `.cursor/extensions/`
>
> Browse `.cursor/extensions/` to see what's available or toggle extensions on and off."
