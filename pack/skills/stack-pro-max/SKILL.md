---
name: stack-pro-max
description: "The user's actual tech stack. Init commands, conventions, and database-first patterns."
---

# Stack Pro Max

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
Your **tech stack** is the set of tools and frameworks you build with - like a builder choosing specific brands of hammer, saw, and nails. This skill defines exactly which tools the agent should use, so every project starts the right way.

## Why Does It Exist?
Every developer has preferred tools. Without this, the agent might suggest Next.js when you use Vite, or npm when you use bun. This skill eliminates that friction - the agent knows your choices and follows them.

## What It Does For You
When you start a new project, the agent scaffolds it with the exact tools, folder structure, and conventions defined here. No more correcting tool choices mid-build.

---

## How The Pieces Fit Together

A web application has layers, and each layer uses a specific tool:

1. **Frontend** - what users see and click (React + Vite)
2. **Styling** - how it looks (vanilla CSS with design tokens from `brand-identity`)
3. **Backend** - where data is stored and processed (Convex)
4. **Auth** - who can log in and what they can access (Clerk)
5. **Hosting** - where the app lives on the internet (Cloudflare Pages)

When you "start a new project," the agent sets up all these layers in the right order with compatible versions. The tables below show the exact tools for each layer.

---

## Activation
- When creating a new project
- When suggesting dependencies or tooling
- When the user asks "what should I use for X?"

## Backend Signals (Proactive Detection)

Users - especially beginners - often describe features without knowing the technical terms. The agent must listen for natural language signals that imply backend needs and proactively suggest the right tools.

**This applies at any point in a project, not just during init.** If someone says "how do my users log in?" three weeks into building, the agent should recognize this as an auth need and propose Clerk + Convex setup if not already configured.

| Signal phrases | What it means | Suggest |
|---|---|---|
| "log in," "sign up," "user accounts," "members," "who's using it" | Auth needed | Clerk |
| "save," "store," "remember," "database," "user data," "profiles" | Database needed | Convex |
| "pay," "charge," "subscribe," "pricing," "checkout," "buy" | Payments needed | Stripe (manual setup, guide user) |
| "deploy," "go live," "share the link," "put it online" | Hosting needed | Cloudflare (see `cloudflare-mcp` extension) |

**How to suggest (beginner-friendly):**
- Never say "you need a backend" - say "your app needs a place to store user data, let me set that up"
- Never list tool options - just use the stack defaults and explain what they do
- If the tools aren't set up yet, follow the setup commands in this skill
- Give a Tier 1 Crew Brief after setup explaining what was added and why

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- THE STACK                                          -->
<!-- ═══════════════════════════════════════════════════ -->

## The Stack

### Dynamic Apps (SaaS, dashboards, CRUD)

| Layer | Tool | Why |
|---|---|---|
| **Frontend** | React + Vite | Fast dev server, modern tooling, huge ecosystem |
| **Styling** | Vanilla CSS with custom properties | Full control, design system via tokens (see `brand-identity`) |
| **Backend** | Convex | Reactive, real-time, type-safe, serverless |
| **Auth** | Clerk | Drop-in authentication with social logins, MFA |
| **Hosting** | Cloudflare Pages | Edge deployment, preview URLs per branch |
| **Package Manager** | bun (preferred) / pnpm (fallback) | Fast installs, no npm |

### Static Sites (Marketing, portfolios, landing pages)

| Layer | Tool | Why |
|---|---|---|
| **Framework** | Astro | Zero-JS by default, fast static sites |
| **Styling** | Vanilla CSS with custom properties | Same token system as dynamic apps |
| **Hosting** | Cloudflare Pages | Same deployment pipeline |

---

## Init Commands

### React + Vite + Convex
```bash
# Scaffold the app
bunx --bun create-vite@latest ./ -- --template react-ts

# Install dependencies
bun install

# Add Convex
bun add convex
bunx convex init

# Add Clerk
bun add @clerk/clerk-react
```

### Astro
```bash
# Scaffold the site
bunx --bun create-astro@latest ./ -- --template minimal --no-install --no-git

# Install dependencies
bun install
```

---

<!-- ═══════════════════════════════════════════════════ -->
<!-- PATTERNS & CONVENTIONS                             -->
<!-- ═══════════════════════════════════════════════════ -->

## Database-First Pattern (Convex)

Always define the data model before writing UI:

1. **Schema first** - write `convex/schema.ts` with all tables and relationships
2. **Queries + Mutations** - write the data layer in `convex/`
3. **UI last** - build components that consume the data layer

```typescript
// convex/schema.ts - always start here
import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  posts: defineTable({
    title: v.string(),
    content: v.string(),
    authorId: v.string(),
    published: v.boolean(),
  }).index("by_author", ["authorId"]),
});
```

---

## Conventions

- **File structure:** Feature-based folders (`src/features/auth/`, `src/features/posts/`)
- **Component naming:** PascalCase (`UserProfile.tsx`)
- **CSS files:** Co-located with components (`UserProfile.css`) or single `index.css` for small projects
- **Env vars:** Always in `.env.local`, never committed
- **TypeScript:** Strict mode, always
- **Imports:** Absolute paths via `tsconfig.json` paths (`@/features/auth`)
