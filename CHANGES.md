# Change cascade checklist (Cursor Source Setup)

Read this before committing changes to **this** repository. Each change can ripple across multiple files.

| What changed | Also check |
|---|---|
| **Extension folder structure** (new files, subfolders, renamed) | `install.sh`, `install.ps1`, `update.sh`, `update.ps1`, `README.md` file tree, `liftoff-lifecycle` Extension Folder Structure |
| **New extension added** | `pack/extensions/extensions.json`, `README.md` extension table + count |
| **Extension removed** | `pack/extensions/extensions.json`, `README.md`, workflows that reference it |
| **Skill convention changed** | `pack/skills/cursor-standard/SKILL.md`, `liftoff-lifecycle` Extension Folder Structure, `README.md` How Skills Work |
| **Session Start rules changed** | `pack/skills/liftoff-lifecycle/SKILL.md` Session Start, `pack/workflows/init-project.md` if scaffolding changes |
| **PROBE / init-project changed** | `pack/workflows/init-project.md`, `README.md` if user-facing |
| **Install script logic changed** | **All four**: `install.sh`, `install.ps1`, `update.sh`, `update.ps1` |
| **Rules (`liftoff-core.mdc`) changed** | `README.md` if user-facing; keep rules **thin** |
| **Lifecycle / platform paths changed** | `liftoff-lifecycle`, `init-project.md`, `package-manager/SKILL.md` |
| **User extension paths changed** | `liftoff-lifecycle` Skill Creation, `init-project.md` symlinks, install/update scripts, `README.md` |
| **MCP path documentation** | Every `SETUP.md` that references `~/.cursor/mcp.json` — verify against current Cursor docs |
| **README clone URL / agent comments** | Top-of-file `README.md` HTML comments for agents; canonical `github.com/Sesamsesam/cursor-source-setup` |
| **Security tools docs (Socket)** | `pack/skills/security-guardian/SKILL.md`, `pack/extensions/security-tools/SKILL.md`, `pack/extensions/extensions.json` entry if added |

## Global install layout (reference)

- **Pack / config:** `~/.cursor/liftoff/` (workflows, setup, extensions, user-extensions, rules, `.liftoff-source`, `.liftoff-version`)
- **Core skills (global discovery):** `~/.cursor/skills/<skill>/SKILL.md`
- **Project links (after init-project):** `.cursor/rules/liftoff-core.mdc`, `.cursor/extensions/`, `.cursor/user-extensions/` → `~/.cursor/liftoff/`
