---
name: orbit-planning
description: "O.R.B.I.T. - strategic project planning before you build. Objective, Requirements, Blueprint, Implementation Roadmap, Track."
---

# O.R.B.I.T. - Strategic Project Planning

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

> **O**bjective - **R**equirements - **B**lueprint - **I**mplementation Roadmap - **T**rack
>
> *"Set the trajectory before you launch."*

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
A guided 5-phase planning process that defines your project before any code is written. The agent asks questions, pushes for detail, and builds a professional project blueprint. You don't need to know what a PRD is or how to write user stories - the agent translates everything into plain language and does the heavy lifting.

## Why Does It Exist?
F.O.R.G.E. handles *how* to build right, but assumes you know *what* to build. Without strategic planning, even perfect execution builds the wrong thing in the wrong order. O.R.B.I.T. fills that gap. It's the difference between a vibe coder who says "build me an app" and a professional who says "here's exactly what we're building, why, and in what order."

## What It Does For You
You answer questions. The agent builds your blueprint. By the end you have a clear vision, prioritized features, technical architecture, and a phased roadmap with work orders - the exact things that professional product teams spend weeks creating. Then F.O.R.G.E. takes over and executes.

---

## Activation
- Enable in `~/.cursor/liftoff/extensions/extensions.json`: `"orbit-planning": true`
- Trigger: "Let's plan a project," "Start ORBIT," or "Help me plan this app"

<!-- ═══════════════════════════════════════════════════ -->
<!-- THE 5 PHASES                                       -->
<!-- ═══════════════════════════════════════════════════ -->

---

## The 5 Phases

### Phase 1: O - Objective
> *"What are we building, and why does it matter?"*

Ask open-ended questions and push for depth. If the user gives a one-liner, push back:

*"That's a starting point, but I need the full picture. Who would use this? What's frustrating about what's already out there?"*

**Questions to ask:**
- "What problem does this solve?"
- "Who is this for? Describe them like a person, not a demographic."
- "Why does this need to exist? What happens if it doesn't?"
- "What's already out there? What's different about yours?"
- "What does success look like in 3 months?"

**Keep asking until the vision is crystal clear.** Most beginners stop too early - that's where the agent adds value by probing deeper.

**Produces:** Vision Statement (2-3 sentences) + Problem Definition

---

### Phase 2: R - Requirements
> *"What must it do? What would be nice to have?"*

Help the user think in user actions, not technical features:
- "Walk me through what a user does from the moment they open the app."
- "What are the 3 things it MUST do on day one?"
- "What would make users say 'wow' but could wait for v2?"
- "Hard constraints? Budget, timeline, platform?"

Introduce priorities naturally: *"Let's sort these into three buckets: P1 is must-have for launch, P2 is important but can wait, P3 is dream features."*

For each feature: "Describe what this looks like from the user's perspective."

**Produces:** Feature Set with P1/P2/P3 + User Stories

---

### Phase 3: B - Blueprint
> *"How will we build it?"*

**Default stack pitch:**
> *"Our default is React + Vite, Convex backend, Clerk auth, Cloudflare Pages hosting. Battle-tested combo. Do you have preferences, or should we roll with this?"*

If user accepts, confirm and move on. If they suggest alternatives (Vercel, Supabase, Firebase), explain trade-offs honestly:
> *"Those are popular and they work. But these alternatives give you more power for less money - they're what serious indie builders use. The learning curve is almost the same."*

**Surface needs with these questions:**
- "User accounts and login needed?"
- "File/image/video uploads?"
- "Real-time updates (chat, live dashboard)?"
- "AI/search features?"
- "Third-party services (payments, email, maps)?"
- "Web-only or mobile too?"

| If user mentions... | Recommend |
|---|---|
| Video/large files | R2 + compression pipeline |
| AI, semantic search | Vectorize or Vertex AI |
| RAG | AutoRAG or custom pipeline |
| Real-time | Convex subscriptions |
| Payments | Stripe |
| Email | Resend or CF Email Workers |
| Mobile | React Native / Expo |
| Static/content | Astro |
| Background jobs | Convex crons or CF Workers |

**Produces:** Technical Blueprint with stack, architecture, integrations

---

### Phase 4: I - Implementation Roadmap
> *"What do we build first, second, third?"*

Break P1 features into ordered phases:
- Group related features logically
- Each phase: features, complexity (simple/medium/complex), testable deliverable
- Phase 1 MUST produce something usable

Each phase is broken into **work orders** that F.O.R.G.E. executes.

**Produces:** Phased Roadmap with work orders

---

### Phase 5: T - Track
> *"Keep the plan alive as the project evolves."*

The `orbit.md` at `docs/orbit.md` is the living plan. Agent rules (always active):

1. **Before starting any task**: check `orbit.md` - is this in the roadmap?
2. **When user changes direction**: acknowledge, update `orbit.md`, then proceed
3. **After completing a work order**: check it off
4. **New ideas**: add to P2/P3 automatically
5. **Never silently ignore the plan** - if reality diverges, update the plan first

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Relationship to F.O.R.G.E.

```
O.R.B.I.T. (strategic)    ->    F.O.R.G.E. (tactical)
"What to build and why"    ->    "How to build it right"

Phase I work orders        ->    become F.O.R.G.E. tasks
orbit.md                   ->    referenced during Foundation phase
```

- O.R.B.I.T. runs **once** at project start (revisited via Track)
- F.O.R.G.E. runs **for every task** within the project

---

## With Beads vs Without

| | Without Beads | With Beads |
|---|---|---|
| **Within session** | Works perfectly | Works perfectly |
| **Across sessions** | Agent re-reads `orbit.md` but loses the *why* behind pivots | `bd ready` loads full context including decision rationale |
| **User effort** | May need to remind agent of recent changes | Zero re-explaining |

> Beads is not required, but eliminates cross-session friction. Without it, `orbit.md` is your safety net.

---

## The `orbit.md` Template

Agent creates this at `docs/orbit.md` when O.R.B.I.T. completes:

```markdown
# Project: [Name]
> Generated by O.R.B.I.T. | Last updated: [date]

## Objective
[Vision statement + problem definition]

## Requirements

### P1 - Must Have (Launch)
- [ ] Feature A - [user story]
- [ ] Feature B - [user story]

### P2 - Important (Post-Launch)
- [ ] Feature C - [user story]

### P3 - Dream Features
- [ ] Feature D - [user story]

## Blueprint
- **Frontend**: [stack]
- **Backend**: [stack]
- **Auth**: [stack]
- **Hosting**: [stack]
- **Storage**: [if applicable]
- **AI/Search**: [if applicable]
- **Integrations**: [third-party]

### Architecture Overview
[How components connect]

## Roadmap

### Phase 1: [Name] - [status]
- [ ] Work order 1
- [ ] Work order 2

### Phase 2: [Name] - [not started]
- [ ] Work order 3

## Change Log
- [date] Initial O.R.B.I.T. plan created
```
