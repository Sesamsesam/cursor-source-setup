---
name: git-flow
description: "Progressive Git workflow for solo developers. From complete beginner to team-ready."
---

# Git Flow

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.
> (THIS IS A MUST TO UNDERSTAND FOR ANY USER - an essential)

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
A step-by-step guide to Git - from "what is Git?" to professional team workflows. The agent enforces the right level automatically based on project context.

## Why Does It Exist?
Git is universal for tracking code changes and collaborating. Without proper practices, you lose work, break things with no undo button, and can't collaborate effectively. This skill teaches you the right habits from day one.

## What It Does For You
The agent writes proper commit messages, maintains `.gitignore`, and recommends the right workflow level. You learn professional Git by seeing it in action.

---

## Activation
- Every commit, branch creation, or deployment
- New project init (`.gitignore` setup)
- When the user asks about version control

## Enforcement
- Agent MUST use Conventional Commits format
- Agent MUST verify `.gitignore` covers sensitive files before first commit
- Agent MUST recommend appropriate workflow level

<!-- ═══════════════════════════════════════════════════ -->
<!-- BEGINNER GUIDE                                     -->
<!-- ═══════════════════════════════════════════════════ -->

---

## What Is Git? (For Beginners)

Think of Git as a **save-game system for your code.** Every time you make a meaningful change, you "save" (commit) it with a description. If something breaks, you can always go back to any previous save.

**Key concepts:**
- **Repository (repo):** Your project folder, tracked by Git
- **Commit:** A saved snapshot at a point in time
- **Branch:** A parallel "what if" copy of your code
- **Push:** Upload commits to GitHub (backup + sharing)
- **Pull:** Download latest changes from GitHub

### Installing Git (macOS)
```bash
xcode-select --install
git --version
```

---

## GitHub Setup (For Beginners)

Git tracks changes locally. **GitHub** stores your code online - backup, sharing, and collaboration. They both start with "Git" but are different things. Git is the local tool. GitHub is a service that uses Git.

### 1. Create a GitHub Account
Go to [github.com](https://github.com) and sign up. Free accounts include unlimited repositories.

### 2. Create Your First Repository
On GitHub, click **"New Repository"** - name it, select **Private**, click **Create**.

### 3. Connect Your Agent (HTTPS - Easiest)

When the agent runs `git push` for the first time, your browser opens a GitHub login prompt. Sign in and authorize. That's it.

```bash
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
# → Browser opens → Log in → Authorized ✅
```

> **Repo-level vs Account-level access:**
> - **Repo-level** (default): The agent can only push/pull from the specific repo you connected.
> - **Account-level**: Authorize the GitHub CLI (`gh auth login`) and the agent can create new repos for you anytime. Just say "create a new repo for this project" - no manual steps. Only do this if you want the agent to scaffold entire projects.

> **SSH** is an alternative for advanced users (key-based auth, no browser prompts). Ask the agent if interested.

---

## The 3-Step Flow: Save, Checkpoint, Push

```bash
git add .                              # Stage changes
git commit -m "feat: add profile page" # Checkpoint with description
git push origin main                   # Push to GitHub (triggers deploy)
```

The agent runs these when you say "push to git." You don't need to memorize them.

**Understanding the system:**
1. **Save** (`git add`) - select which changes to include
2. **Checkpoint** (`git commit`) - snapshot with description
3. **Push** (`git push`) - upload to GitHub, triggers rebuild

> Only push after testing locally. Pushing broken code = broken live site.

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Conventional Commits

```
type: short description (imperative mood)
```

| Type | When |
|---|---|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation only |
| `chore:` | Maintenance (deps, config) |
| `refactor:` | Code restructure, no behavior change |
| `test:` | Adding or updating tests |

**Examples:**
```
feat: add dark mode toggle to settings
fix: resolve crash on empty search results
docs: update README with deployment steps
chore: upgrade convex to v1.18
```

---

## Essential Commands

| Command | What It Does |
|---|---|
| `git status` | Shows what's changed since last commit |
| `git add .` | Stages all changes |
| `git commit -m "message"` | Saves a snapshot |
| `git push origin main` | Uploads to GitHub |
| `git log --oneline -5` | Shows last 5 commits |

---

## `.gitignore` Template

```gitignore
# Dependencies
node_modules/

# Environment
.env
.env.*
!.env.example

# Build output
dist/
.next/
.astro/

# Convex
.convex/_generated/

# Cloudflare
.wrangler/

# OS files
.DS_Store
Thumbs.db

# Security
*.pem
*.key
.liftoff/

# IDE
.idea/
.vscode/settings.json
```

---

## The Progressive Model

### Level 1: Solo, Small Changes
> Direct push to `main` is OK.

**Rules:** One logical change per commit. Conventional Commits. Never commit secrets or broken code (agent checks automatically).

### Level 2: Solo, Large Features
> Work on a branch, merge when complete.

Create a branch, make changes, merge back when tested. Branch names: `feat/description`, `fix/description`, `chore/description`.

### Level 3: Team or AI Review
> Branch -> Pull Request -> Review -> Merge

Same as Level 2, but with a Pull Request (PR) review step before merging. Quality gate for team collaboration or AI code review.

> **Want Levels 2-3 handled automatically?** Activate `extended-git` - the agent manages branches, PRs, and AI code review for you.
