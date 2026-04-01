---
name: cursor-standard
description: "Meta-skill: the standard format for writing new Cursor skills (Liftoff). Use when creating or evaluating skills."
---

# Cursor Standard

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
The template and quality standard for writing new skills. Every skill in the Liftoff (Cursor) ecosystem must follow this format. Use this skill when creating a new skill or evaluating whether an existing one meets the bar.

## Why Does It Exist?
Without a standard, skills would have inconsistent formats, missing sections, and varying quality. This ensures every skill is agent-readable, beginner-friendly, and genuinely useful.

---

## Activation
- When asked to create a new skill
- When evaluating or auditing existing skills

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- TEMPLATE                                           -->
<!-- ═══════════════════════════════════════════════════ -->

## Required Sections

Every skill MUST have:

### 1. YAML Frontmatter
```yaml
---
name: skill-name-kebab-case
description: "One-line description. What does this skill enable?"
---
```

### 2. Beginner README Block
Three sections at the top of every skill:
- **What Is This?** - Plain-English explanation a non-developer can understand
- **Why Does It Exist?** - The problem it solves
- **What It Does For You** - The concrete benefit (what changes for the user)

### 3. Activation Section
When does the agent load and apply this skill? Specific triggers, not vague.

### 4. Enforcement Section (if applicable)
What rules the agent MUST follow. Use imperative language.

### 5. Content
The actual skill content - patterns, checklists, code examples, etc.

---

## Degrees of Freedom

Match instruction format to how much flexibility the agent has:

| Freedom Level | Format | When to Use |
|---|---|---|
| **High** (heuristics, guidelines) | Bullet points | "Prefer X over Y", design principles |
| **Medium** (templates, patterns) | Code blocks | Reusable snippets the agent should adapt |
| **Low** (fragile operations) | Exact bash commands | Database migrations, deployment scripts |

> [!TIP]
> If an agent could reasonably interpret the instruction 3 different ways, you need a code block or command - not a bullet.

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- QUALITY                                            -->
<!-- ═══════════════════════════════════════════════════ -->

## Quality Bar

A skill passes the quality bar if:

| Criterion | Test |
|---|---|
| **Agent-autonomous** | Can the agent apply this without asking the user? |
| **Concrete** | Does it have code examples, commands, or checklists? (Not just philosophy) |
| **Non-overlapping** | Does it duplicate content from another skill? If yes → merge or reference |
| **Beginner-friendly** | Would a first-week developer understand the README block? |
| **Under 200 lines** | Is the SKILL.md focused enough to fit in ~200 lines? If not, move one-time setup to SETUP.md or split workflows into `workflows/` sub-files |
| **Actionable** | Does every section tell the agent what to DO, not just what to think about? |

---

## File Structure

Each skill/extension lives in its own folder. Most have just one file:

```
extension-name/
  SKILL.md          ← Required. Workflow, rules, usage (read every session)
```

If the extension requires one-time MCP, CLI, or API setup, add a separate file:

```
extension-name/
  SKILL.md          ← Workflow + rules (read every session)
  SETUP.md          ← One-time install + config (read once on activation)
```

**When to use SETUP.md:**
- The extension needs MCP server configuration, API keys, or CLI installation
- The setup is genuinely one-time (not repeated per project or per session)
- Separating it keeps SKILL.md focused on the workflow the agent runs daily

**When NOT to use SETUP.md:**
- The skill has no installation or configuration steps (pure behavioral rules)
- The "setup" runs every time (like prerequisite checks) - keep in SKILL.md
- The skill is already under 200 lines - no need to split

### Complex extensions with workflows

Extensions with multiple workflows that would exceed ~200 lines in SKILL.md:

```
extension-name/
  SKILL.md          <- Index: overview, core rules, workflow table
  SETUP.md          <- One-time install + config
  workflows/
    workflow-a.md   <- Self-contained, ends with "Next Step" chaining
    workflow-b.md   <- Chains from workflow-a or triggered independently
```

See the **Workflow Sub-files** section below for the chaining convention.

**Cross-reference pattern:** SKILL.md must reference SETUP.md at the top:
```markdown
> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for [brief description].
```

## Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| Vague description ("helps with code quality") | Be specific: "Enforces input validation via Zod schemas on all mutations" |
| No code examples | Add at least 2 concrete examples |
| Duplicates another skill | Merge content or add a cross-reference: "See `security-guardian` for X" |
| Activation says "always" | Be specific: "When creating API routes" or "When writing mutations" |
| Pure philosophy, no action items | Convert to concrete rules with enforcement |

---

## Workflow Sub-files

When an extension has multiple distinct workflows that would push SKILL.md past ~200 lines, split them into sub-files:

```
extension-name/
  SKILL.md               <- Index: overview, core rules, activation, workflow table
  SETUP.md               <- One-time install + config (optional)
  workflows/
    first-workflow.md    <- Self-contained workflow with steps
    second-workflow.md   <- Another workflow, chained from the first
```

### SKILL.md as Index

When using sub-files, SKILL.md becomes a lean index (~100 lines) containing:
- What the extension is (beginner explainer)
- Activation triggers
- A **workflow table** listing each workflow file, when to use it, and a one-line description
- Core agent rules that apply across all workflows
- Shared structures (folder layouts, naming conventions)

### Workflow Chaining

Every workflow file must end with a **"Next Step"** section that tells the agent what to do after completing the workflow:

**If there's a natural next workflow:**
```markdown
## Next Step
> [!IMPORTANT]
> **Do not stop here.** Immediately proceed to [next phase]. Read `workflows/next-workflow.md` and continue.
```

**If the workflow branches to other extensions:**
```markdown
## Next Step
Offer the user a choice:
> "What would you like to do next?
> 1. **Option A** - [description]
> 2. **Option B** - [description]
> Or keep what you have and decide later."

**Branch routing:**
- If user picks **A**: activate `extension-a` and pass the output
- If user picks **B**: activate `extension-b` and pass the output
```

**If the workflow is terminal (no next step):**
```markdown
## Next Step
Workflow complete. No further action needed.
```

### Convention for Creating Skills

The agent applies this pattern automatically - do not ask the user about skill architecture.

- **Single workflow, under ~200 lines:** Keep everything in SKILL.md. No sub-files needed.
- **Multiple sequential phases or growing past ~200 lines:** Automatically split into `workflows/` sub-files. Each file is self-contained, ends with a "Next Step" chain.
- **Every workflow must end with a "Next Step"** - whether it chains to the next workflow, offers branch choices to other extensions, or declares the workflow terminal.
- **If a workflow connects to other extensions** (e.g., handing off to `notion-publishing` or `minibook-pipeline`), add branch routing at the end with activation instructions.

The agent determines the structure based on the content being created. If a skill starts simple and later grows, the agent refactors it into sub-files at that point.
