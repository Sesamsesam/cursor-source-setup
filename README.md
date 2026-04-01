# Cursor Source Setup (Liftoff for Cursor)

This repository installs **Liftoff** globally for **Cursor**: thin **Cursor Rules** (`.mdc`), **Agent Skills** (`SKILL.md`), optional **extensions**, **workflows**, and a one-time **developer setup**. It mirrors the *ideas* of the separate Antigravity (`~/.gemini`) edition but uses **Cursor-native paths** under `~/.cursor/`.

## Requirements

- **Cursor** editor
- **Git** (for clone and auto-update)
- **macOS, Linux, or Windows** (PowerShell for Windows install)

## Quick install

**macOS / Linux**

```bash
git clone https://github.com/sesamsesam/cursor-source-setup.git
cd cursor-source-setup
chmod +x install.sh && ./install.sh
```

**Windows (PowerShell)**

```powershell
git clone https://github.com/sesamsesam/cursor-source-setup.git
cd cursor-source-setup
powershell -ExecutionPolicy Bypass -File install.ps1
```

Replace the clone URL with your fork when you publish.

## What gets installed

| Location | Contents |
|----------|----------|
| `~/.cursor/liftoff/rules/` | Thin always-on rules (e.g. `liftoff-core.mdc`) — also symlinked into projects by `init-project` |
| `~/.cursor/skills/` | Core skills: `forge-methodology`, `security-guardian`, `error-handling`, `git-flow`, `brand-identity`, `stack-pro-max`, `cursor-standard`, `liftoff-lifecycle` |
| `~/.cursor/liftoff/extensions/` | Extension packs + `extensions.json` (extensions off by default) |
| `~/.cursor/liftoff/workflows/` | e.g. `init-project.md` |
| `~/.cursor/liftoff/setup/` | e.g. `package-manager` (first-run bootstrap) |
| `~/.cursor/liftoff/user-extensions/` | Your custom extensions — **never** deleted by update scripts |

Version tracking writes **`~/.cursor/liftoff/.liftoff-source`** (path to this cloned repo) and **`~/.cursor/liftoff/.liftoff-version`** (git HEAD) so the **`liftoff-lifecycle`** skill can pull updates.

## After install

1. Open **Cursor**.
2. The agent should follow **`liftoff-lifecycle`** → **Session Start**: optional git pull + `update.sh` / `update.ps1`, then pending **`setup-package-manager`** if needed.
3. Create real work under **`~/dev/`** (or `%USERPROFILE%\dev\` on Windows). Say **“liftoff”** or let auto-detection run **`init-project`** per lifecycle rules.

## Project layout (after `init-project`)

Projects get symlinks (macOS/Linux) or junctions/hard links (Windows) under **`.cursor/`** pointing at `~/.cursor/liftoff/` so **one global pack** stays in sync. See **`pack/workflows/init-project.md`**.

## Cloud / remote agents

Remote agents only see the repo. Copy global Liftoff files into the project using the **Cloud Agent Support** section in **`liftoff-lifecycle`**.

## Updating

If you kept the clone: Session Start can **`git pull`** and run **`./update.sh`** (or **`update.ps1`**). Your **`extensions.json`** toggles and **`user-extensions/`** are preserved; new keys are merged in.

## Relationship to Antigravity

The **Antigravity / Gemini** Liftoff pack is a **different repo** and installs under **`~/.gemini/`**. Use one edition per machine/editor pattern you prefer; they are not mixed in one install path.

## Repository layout

```
cursor-source-setup/
  README.md
  CHANGES.md
  install.sh
  install.ps1
  update.sh
  update.ps1
  pack/
    rules/liftoff-core.mdc
    skills/*/SKILL.md
    extensions/*/...
    extensions/extensions.json
    workflows/init-project.md
    setup/package-manager/SKILL.md
```

## License

MIT
