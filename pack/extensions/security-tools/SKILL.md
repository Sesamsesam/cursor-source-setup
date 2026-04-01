---
name: security-tools
description: "Optional supply-chain tools (Socket GitHub app and Firewall). Docs only, never auto-installed."
---

# Security Tools (Optional)

> **This extension is documentation-only.** The agent never installs or enables these tools automatically. Use them only if you explicitly want extra supply-chain protection and are comfortable with additional tooling.

## What This Covers

- **Socket for GitHub (app)** — Adds PR-level checks for risky dependencies (suspicious behavior, sudden new deps, typosquats, etc.) on GitHub repositories.
- **Socket Firewall (desktop)** — Monitors outbound network connections from developer tools (e.g., `npm install`) and can block anomalous traffic.

These can be valuable for:
- Teams that want stronger guardrails on **pull requests**.
- Developers who frequently install new or experimental packages and want extra monitoring on their **dev machine**.

## When To Use These

Use these only if:
- You are comfortable installing and managing GitHub apps and desktop tools, **or**
- You have guidance from your security team.

For most beginners, the built-in Liftoff protections (dependency verification, minimum release age, audits, etc.) are sufficient.

## How To Ask the Agent

You can say:

- **For the GitHub app:**
  > "Help me set up the Socket GitHub app for my main repos."

  The agent will:
  - Explain what the app does in plain language.
  - Open or link to the official Socket GitHub integration page.
  - Walk you through selecting which repositories to enable, without doing it silently.

- **For the Firewall:**
  > "Help me install Socket Firewall on my laptop."

  The agent will:
  - Explain what the firewall does (and that it runs locally on your machine).
  - Point you to the official Socket Firewall install instructions for your OS.
  - Never run installers or scripts on its own.

## Agent Rules (Strict)

- **Never auto-install** Socket GitHub app or Socket Firewall.
- **Only suggest** these when:
  - The user mentions Socket by name, **or**
  - The user explicitly asks for advanced supply-chain/CI/dev-machine protection.
- For non-technical users, avoid surfacing these unless they ask specifically.

