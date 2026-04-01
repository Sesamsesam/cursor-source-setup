<!--
AGENT: After install.sh / install.ps1 finishes, read ~/.cursor/skills/liftoff-lifecycle/SKILL.md "Session Start" and follow it.
AGENT: If setup-package-manager is "pending" in ~/.cursor/liftoff/extensions/extensions.json, read ~/.cursor/liftoff/setup/package-manager/SKILL.md and execute Steps 0-9. Do not stop after install only.
-->

# Cursor Source Setup (Liftoff for Cursor)

This repository installs **Liftoff** globally for **Cursor**: thin **Cursor Rules** (`.mdc`), **Agent Skills** (`SKILL.md`), optional **extensions**, **workflows**, and a one-time **developer setup**. It mirrors the *ideas* of the separate **Antigravity** Liftoff pack (`~/.gemini`) but uses **Cursor-native paths** under `~/.cursor/`.

**Canonical repository:** [github.com/Sesamsesam/cursor-source-setup](https://github.com/Sesamsesam/cursor-source-setup)

## Requirements

- **Cursor** editor
- **Git** (clone and auto-update)
- **Python 3** (`python3` on PATH) — used by the install/update scripts to merge `extensions.json` without clobbering your toggles
- **macOS, Linux, or Windows** (PowerShell for Windows install)

## Quick install

**macOS / Linux**

```bash
git clone https://github.com/Sesamsesam/cursor-source-setup.git
cd cursor-source-setup
chmod +x install.sh update.sh && ./install.sh
```

**Windows (PowerShell)**

```powershell
git clone https://github.com/Sesamsesam/cursor-source-setup.git
cd cursor-source-setup
powershell -ExecutionPolicy Bypass -File install.ps1
```

Forks: change the clone URL to your fork; keep **`~/.cursor/liftoff/.liftoff-source`** pointing at the clone you pull from for auto-updates.

## What gets installed

| Location | Contents |
|----------|----------|
| `~/.cursor/liftoff/rules/` | Thin always-on rules (e.g. `liftoff-core.mdc`) — symlinked into projects by **`init-project`** |
| `~/.cursor/skills/` | Core skills: `forge-methodology`, `security-guardian`, `error-handling`, `git-flow`, `brand-identity`, `stack-pro-max`, `cursor-standard`, `liftoff-lifecycle` |
| `~/.cursor/liftoff/extensions/` | Extension packs + `extensions.json` (extensions off by default until set to `true`) |
| `~/.cursor/liftoff/workflows/` | e.g. `init-project.md` |
| `~/.cursor/liftoff/setup/` | e.g. `package-manager` (first-run bootstrap) |
| `~/.cursor/liftoff/user-extensions/` | Your custom extensions — **never** deleted by update scripts |

Version tracking: **`~/.cursor/liftoff/.liftoff-source`** (path to this cloned repo) and **`~/.cursor/liftoff/.liftoff-version`** (git HEAD) so **`liftoff-lifecycle`** can run `git pull` + `update.sh` / `update.ps1`.

## After install

1. Open **Cursor** in a normal project (or a new window).
2. The agent follows **`liftoff-lifecycle`** → **Session Start**: optional `git pull` + updater, then **`setup-package-manager`** if still `"pending"`.
3. Put real projects under **`~/dev/`** (or `%USERPROFILE%\dev\` on Windows). Say **“liftoff”** or rely on auto-detection to run **`init-project`** per lifecycle rules.

## Project layout (after `init-project`)

Each project gets **symlinks** (macOS/Linux) or **junctions / hard links** (Windows) under **`.cursor/`** pointing at `~/.cursor/liftoff/` so **one global pack** stays in sync across projects. Details: **`pack/workflows/init-project.md`**.

## Cursor compatibility notes

- **Rules:** `liftoff-core.mdc` uses **`alwaysApply: true`** when present under **`.cursor/rules/`**. Global copies live in **`~/.cursor/liftoff/rules/`**; **`init-project`** links them into the repo so the editor applies them for that project.
- **MCP:** Extension **SETUP.md** files often mention **`~/.cursor/mcp.json`**. Cursor’s MCP UI and file locations can change between versions — if steps do not match your app, use **Cursor Settings → MCP** and paste the same JSON blocks there.
- **Skills:** Personal skills are expected under **`~/.cursor/skills/`** per Cursor’s skill discovery; this installer copies **`pack/skills/`** there.

## Cloud / remote agents

Remote agents may only see the **repository**. Copy the pack into the project using the **Cloud Agent Support** section in **`liftoff-lifecycle`** (`~/.cursor/skills/liftoff-lifecycle/SKILL.md`).

## Updating

If you keep the clone: Session Start can **`git pull`** and run **`./update.sh`** (or **`update.ps1`**). Your **`extensions.json`** values and **`user-extensions/`** are preserved; new keys from the repo are merged in.

## Relationship to Antigravity

The **Antigravity / Gemini** Liftoff installer is a **separate repository** and installs under **`~/.gemini/`**. It is not bundled here. Use the edition that matches your editor; do not mix both packs into one global path.

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
