---
name: forge-methodology
description: "F.O.R.G.E. - the default operating mode. Foundation, Outline, Rock'n'Roll, Guard, Evolve."
---

# F.O.R.G.E. Methodology

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
F.O.R.G.E. is the step-by-step process your AI agent follows for every task - from understanding what you want, to planning, building, protecting, and learning. Think of it as a master builder's workflow: measure twice, cut once, inspect the result.

## Why Does It Exist?
Without a structured approach, AI agents jump straight to coding and skip planning, security, and verification. The result? Fragile code, missed requirements, and expensive rewrites. F.O.R.G.E. prevents this by enforcing discipline at every step.

## What It Does For You
You never need to say "use FORGE" - the agent follows it automatically. Every feature gets planned before it's built, verified as it's built, and secured before it ships.

---

## Activation
- **Always active.** This is the default operating mode for every task.
- No trigger needed - F.O.R.G.E. is the baseline behavior.

## Enforcement
- The agent MUST NOT write implementation code before the Outline is approved.
- The agent MUST verify each step before moving to the next.
- If a step fails, STOP and report - never skip ahead.

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- THE CYCLE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

## The F.O.R.G.E. Cycle

### 1. Foundation
> Understand the project context, tech stack, and existing code before anything else.

**Actions:**
- Read relevant files, check the tech stack, understand the current state
- Ask Socratic questions to clarify ambiguity:
 - "What problem does this solve for the user?"
 - "Is there existing code that does something similar?"
 - "What are the success criteria?"
 - "Are there constraints I should know about?"
- If similar functionality exists in the codebase → inspect it first, learn from the working implementation
- Check Knowledge Items (KIs) for relevant prior work

**Do NOT proceed until:** You understand what you're building and why.

### 2. Outline
> Create a plan. No code until the user approves it.

**Actions:**
- Write an implementation plan with:
 - **Task decomposition** - break into small tasks (2-5 minutes each)
 - **Each task has:** exact file paths, expected changes, verification steps
 - **Dependency order** - what must be built first
 - **Potential risks** - what could go wrong
- For each proposed change, briefly state:
  1. What files/functions change
  2. Why this change is needed
  3. Directly impacted modules
  4. Potential side effects
  5. Trade-offs (if any)
- Present the plan in digestible sections (not a wall of text)
- Wait for explicit user approval before proceeding

**Do NOT proceed until:** The user says "approved," "go ahead," "looks good," or equivalent.

### 3. Rock'n'Roll
> Execute the plan, brick by brick, with verification at each step.

**Actions:**
- Before writing code for a task, mentally trace the change:
  - Walk through user interactions and data flow
  - Identify edge cases (empty state, errors, concurrent access)
  - If the simulation reveals issues → adjust the plan before coding
- Implement one task at a time in the approved order
- After each task:
 - Verify it works (run tests, check output, read the result)
 - If verification fails → fix before moving on
 - Update task tracker with progress
- If you discover unexpected complexity → STOP, return to Outline, update the plan

**Rule:** Never batch multiple unverified changes. One brick, test, next brick.

### 4. Guard
> Security, validation, and error handling - automatic, not optional.

**Actions (applied to every code change):**
- Run security checks (see `security-guardian` skill)
- Apply error handling patterns (see `error-handling` skill)
- Validate inputs (Zod schemas, sanitization)
- Check auth boundaries on public endpoints
- Verify `.gitignore` covers sensitive files

**Rule:** Guard is not a separate phase you "get to" - it runs continuously during Rock'n'Roll.

### 5. Evolve
> Learn from what happened. Persist knowledge for next session.

**Actions:**
- Document what was built, what worked, what didn't
- If Beads active: `bd sync` to persist context
- Update Knowledge Items if new patterns were discovered
- Suggest improvements in three categories:
  - **S1 - Stability/Scalability**: Architectural improvements, better error recovery, load handling
  - **S2 - Performance/Security**: Query optimization, caching, auth hardening, rate limiting
  - **S3 - Readability/Maintainability**: Cleaner abstractions, better naming, documentation gaps

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- QA & ANTI-PATTERNS                                 -->
<!-- ═══════════════════════════════════════════════════ -->

## QA Checklist (Single Source of Truth)

All other skills reference this checklist - it is defined here ONCE.

Before marking any task complete:
- [ ] Code compiles / builds without errors
- [ ] Feature works as specified in the Outline
- [ ] Error handling is in place (not just happy path)
- [ ] Inputs are validated (Zod schemas, sanitization)
- [ ] Auth boundaries enforced on public mutations
- [ ] No secrets in code, logs, or chat
- [ ] `.gitignore` covers all sensitive files
- [ ] Conventional commit message written
- [ ] If UI change: visually verified (screenshot or browser check)

---

## Anti-Patterns (What NOT To Do)

| Anti-Pattern | Why It's Bad |
|---|---|
| Skip the Outline | Leads to rework, missed requirements, wasted time |
| Batch 5 changes without testing | One failure cascades, impossible to isolate the bug |
| Ignore Guard phase | Security vulnerabilities, unhandled errors, data leaks |
| Hardcode quick fixes | Technical debt accumulates, code becomes unmaintainable |
| Skip Evolve | Same mistakes repeated across sessions |
