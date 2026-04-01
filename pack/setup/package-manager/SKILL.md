---
name: setup-package-manager
description: "One-time bootstrap: detect OS, install/verify system package manager, bun, git, and GitHub CLI."
---

# Developer Tools Bootstrap

> **This is a one-time setup task.** The agent runs it automatically on first session, notes the results, and never loads it again.

## Universal Fallback Principle

> [!IMPORTANT]
> **Never give up on installing a tool.** If the system package manager (brew on macOS, winget on Windows) is locked, broken, or permission-denied, the agent must automatically pivot to alternative installation methods:
> - **macOS/Linux**: Use `curl` scripts or direct binary downloads
> - **Windows**: Use PowerShell web requests (`irm`) or direct `.msi`/`.zip` downloads
>
> Do **not** attempt to fix package manager permissions (e.g., `chown` or `chmod` on brew directories) as this risks breaking other users' setups on shared machines.

## Instructions for the Agent

When `extensions.json` has `"setup-package-manager": "pending"`, execute this flow. Run each check in order. If a tool is already installed, skip to the next one.
### Setup Progress Tracker

**At the very start (before the welcome message)**, create a checklist file at `~/.cursor/liftoff/setup/setup-progress.md`:

```markdown
# Liftoff Setup Progress
- [ ] Step 0: Welcome + GitHub check
- [ ] Step 1: Detect OS
- [ ] Step 1.5: Windows Build Essentials (Windows only)
- [ ] Step 2: Install Homebrew (macOS) / detect package manager
- [ ] Step 3: Install bun
- [ ] Step 4: Detect git
- [ ] Step 5: Install and authenticate GitHub CLI
- [ ] Step 6: Write Machine Environment
- [ ] Step 7: Mark setup-package-manager as done
- [ ] Step 8: Confirm all tools
- [ ] Step 9: Handoff to project init
```

**After completing each step**, update the checklist:
- Mark the step `[x]`
- If the step failed and was resolved with an alternative, note it: `[x] Step 3: Install bun (fallback: curl install)`

**If the agent gets interrupted, errors out, or loses context**, it should:
1. Read `~/.cursor/liftoff/setup/setup-progress.md`
2. Find the first unchecked `[ ]` item
3. Resume from that step

**After Step 9 completes successfully**, delete the file - it's no longer needed.

> [!IMPORTANT]
> **Error recovery:** If any step fails, do NOT skip it and do NOT abandon the setup. Troubleshoot the issue, try alternative approaches (see fallback instructions in each step), and resolve it before moving on. After resolving, check off the step in `setup-progress.md` with a note about what was done differently, then continue from the next unchecked step.

### 0. Welcome

Start the session with this message (include the line breaks exactly as shown):

> "Welcome Astronaut 🧑‍🚀 to samihermes.ai Liftoff! 🚀 Are you ready to move with rocket speed and get an AI upgrade?
>
> I'm going to set up your developer toolkit now to give you a super boost ⚡️ - this will take just a few minutes. I'll install everything automatically and ask you only when I need your help. Enjoy the magic 🪄
>
> 1. First things first - do you have a GitHub account? If you don't, create one right now as the first step at [github.com/signup](https://github.com/signup) - this is essential and mandatory to move on.
> (don't worry, you will learn what it is and how to use it over time working with me)
>
> If you already have an account, go and sign in right now.
> Reply with **'Ready'** when you have done this."

Wait for the user to confirm before proceeding to Step 1.

### 1. Detect OS

The system context includes `OS version: mac` or `OS version: windows`. Use this to branch.

### 1.5 Windows Build Essentials (Windows Only)

> [!IMPORTANT]
> **This step is the Windows equivalent of macOS Xcode Command Line Tools.** On Mac, Homebrew automatically detects and installs the C/C++ compiler and system headers. Windows has no such automatic chain - the agent must explicitly check for and install these foundational tools. Without them, `bun install` or `npm install` will fail with cryptic errors on any package with native bindings (e.g., `sharp`, `better-sqlite3`, `node-canvas`).

**Skip this entire step on macOS/Linux** - macOS handles this via Xcode CLI Tools (triggered automatically by Homebrew), and Linux distributions ship with `gcc`/`build-essential`.

#### 1.5.1 Visual C++ Build Tools

1. Check if the C++ compiler is available:
   ```powershell
   where cl.exe
   ```
2. If found: note `Build Tools: Visual C++ (present)` and skip to 1.5.2
3. If not found: tell the user:
   > "I'm installing Windows Build Tools - these are foundational tools your computer needs to compile software. On Mac this happens automatically, but on Windows we set it up once. This may take 5-10 minutes."
4. Install via winget:
   ```powershell
   winget install Microsoft.VisualStudio.2022.BuildTools --override "--quiet --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
   ```
5. If winget is not available, provide the fallback:
   > "Please download Build Tools from https://visualstudio.microsoft.com/visual-cpp-build-tools/ - click Download, run the installer, select 'Desktop development with C++', and click Install. Reply with **'Done'** when finished."
6. After install, verify:
   ```powershell
   where cl.exe
   ```
7. If still not found after install: note `Build Tools: unavailable (manual install needed)` and move on. The user may hit errors later with native packages, but core tools (bun, git, gh) will still work.

#### 1.5.2 Python 3 (for node-gyp)

Many native Node.js/Bun packages use `node-gyp` to compile, which requires Python. macOS ships with Python; Windows does not.

1. Check if Python is available:
   ```powershell
   python --version
   ```
2. If found (Python 3.x): note the version and skip
3. If not found or returns Python 2.x: install via winget:
   ```powershell
   winget install Python.Python.3.12
   ```
4. If winget is not available, use the fallback:
   ```powershell
   powershell -c "irm https://www.python.org/ftp/python/3.12.0/python-3.12.0-amd64.exe -OutFile python-installer.exe; Start-Process python-installer.exe -ArgumentList '/quiet InstallAllUsers=1 PrependPath=1' -Wait"
   ```
5. Verify:
   ```powershell
   python --version
   ```
6. If both methods fail: note `Python: unavailable` and move on. Most projects will work, but some native compilation steps may fail.

### 2. System Package Manager

**macOS:**
1. Run `which brew`
2. If found: verify it actually works by running `brew --version`
   - If `brew --version` succeeds: brew is healthy, use it for subsequent installs
   - If `brew --version` fails (permission denied, errors): brew is **unusable** on this account. Note `Package Manager: unavailable (permission denied)` and use curl/direct-download for all subsequent tool installs. Do **not** reinstall brew or modify permissions - this would break other users on the same machine
3. If `which brew` returns nothing (brew not installed): tell the user you're installing Homebrew, then run:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
4. After install, run the shell env setup:
   ```bash
   echo >> ~/.zprofile
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```
5. Verify with `brew --version`
6. If fresh install also fails: note `Package Manager: unavailable` and use curl/direct-download for all subsequent tools

**Windows:**
1. Run `where winget` or `winget --version`
2. If found: note `winget` and skip to step 3
3. If not found: check for alternatives with `where choco` and `where scoop`
4. If one is found: note whichever is available
5. If none found: ask the user:
   > "Do you have a preferred package manager? If you don't know, just say 'I don't know'."
   - If they name one: note it
   - If "I don't know": `winget` ships with Windows 10/11 - verify with `winget --version`. If truly missing, install via the App Installer package from the Microsoft Store, or note `Package Manager: unavailable` and use PowerShell/direct-download for all subsequent tools
6. If install fails: note `Package Manager: unavailable` and move on

**Linux:**
1. Detect which is available: `which apt`, `which dnf`, `which pacman`, `which zypper`
2. Note the first one found (they're always pre-installed)

### 3. Install bun

1. Run `which bun` (or `where bun` on Windows)
2. If found: note the version and skip
3. If not found: install using the table below - try the **primary** method first, if it fails use the **fallback**:

| OS | Primary (package manager) | Fallback (direct install) |
|---|---|---|
| macOS | `brew install oven-sh/bun/bun` | `curl -fsSL https://bun.sh/install \| bash` |
| Windows | `winget install Oven-sh.Bun` | `powershell -c "irm bun.sh/install.ps1 \| iex"` |
| Linux | `curl -fsSL https://bun.sh/install \| bash` | Same (curl is the primary method) |

4. Verify with `bun --version`
5. If both methods fail: note `Runtime: manual (bun install blocked)` and provide the user with: https://bun.sh/docs/installation

### 4. Install git

Most systems ship with git. Check first.

1. Run `git --version`
2. If found: note the version and skip
3. If not found: install using the table below:

| OS | Primary (package manager) | Fallback |
|---|---|---|
| macOS | `brew install git` | `xcode-select --install` (opens a system dialog - tell the user: "A dialog will appear asking to install Command Line Tools. Click Install and wait for it to finish.") |
| Windows | `winget install Git.Git` | Tell the user: "Please download Git from https://git-scm.com/download/win and run the installer. Use the default settings." |
| Linux | `sudo apt install git` / `sudo dnf install git` | Always available via system package manager |

4. Verify with `git --version`

### 5. Install GitHub CLI

1. Run `gh --version`
2. If found but not authenticated: go to step 5.4
3. If not found: install using the table below:

| OS | Primary (package manager) | Fallback (direct install) |
|---|---|---|
| macOS | `brew install gh` | `curl -sS https://webi.sh/gh \| bash` |
| Windows | `winget install GitHub.cli` | `powershell -c "irm https://webi.sh/gh \| iex"` |
| Linux | See [gh install docs](https://github.com/cli/cli/blob/trunk/docs/install_linux.md) | `curl -sS https://webi.sh/gh \| bash` |

4. **Authenticate** (fully automated - no user interaction at the terminal):
   ```bash
   gh auth login --hostname github.com --git-protocol https --web
   ```
   > [!CAUTION]
   > **This command has TWO interactive prompts. The agent MUST handle BOTH automatically:**
   >
   > **Prompt 1:** `? Authenticate Git with your GitHub credentials? (Y/n)` - The agent MUST immediately send `Y\n` (the letter Y followed by Enter) via stdin/send-input. Do NOT wait. Do NOT ask the user. Just send it.
   >
   > **Prompt 2:** `Press Enter to open github.com in your browser...` - The agent MUST immediately send `\n` (Enter) via stdin/send-input. Do NOT wait. Do NOT ask the user. Just send it.
   >
   > **Both of these are mandatory automated actions.** The user cannot interact with the terminal - there is no button for them to click. The agent is the only one who can send input. If the agent does not have permission to send input, it must request permission to do so - but it must NEVER ask the user to type in the terminal.

   - After both prompts are handled, the command outputs a one-time code and opens a browser
   - The agent **must** capture that code and write in chat:
     > "👉 A browser should have opened. Log in to GitHub and enter this code: **[CODE]**
     >
     > Reply with **'Done'** when you've completed the authorization."
   - Wait for the user to confirm before proceeding
   - After user says "Done", verify with `gh auth status`. If auth is NOT successful, tell the user:
     > "Hmm, it looks like the connection didn't go through yet. Did you enter the code **[CODE]** and click Authorize on GitHub? Try again and reply with 'Done' when connected."
   - Repeat until `gh auth status` confirms authentication
5. If the user doesn't have a GitHub account:
   > "You'll need a GitHub account to store your code. Head to github.com/signup, create a free account, then come back here and we'll finish connecting."
6. Verify with `gh auth status` (skip if already verified in step 4 above)

<!-- CREW BRIEF -->
> **After GitHub CLI is authenticated, tell the user:**
>
> "You're now connected to GitHub - this is where all your projects get safely stored and backed up.
>
> Think of GitHub as a cloud vault for everything you build. Every change I make gets saved there automatically, so you'll never lose your work. It also makes it easy to share projects or collaborate later.
>
> This connection is permanent - you won't need to do this again."

### 6. Write Machine Environment

Append a `## Machine Environment` section to the user's `~/.cursor/skills/liftoff-lifecycle/SKILL.md` (at the end of the file):

```markdown
## Machine Environment
- OS: [macOS / Windows / Linux] ([architecture if detectable])
- Package Manager: [brew / winget / choco / scoop / apt / dnf / pacman / unavailable]
- Build Tools: [Xcode CLI Tools (macOS) / Visual C++ Build Tools 2022 (Windows) / gcc (Linux) / unavailable]
- Python: [version] (or: unavailable / not needed)
- Runtime: bun [version]
- Git: [version]
- GitHub CLI: gh [version] (authenticated as @[username])
```

If the section already exists (re-run scenario), update it instead of duplicating.

### 7. Mark Complete

Update `~/.cursor/liftoff/extensions/extensions.json`: change `"setup-package-manager"` from `"pending"` to `"done"`.

### 8. Confirm to User

Tell the user (dynamic - reflect what you ACTUALLY did, do not hard-code):

> "Global setup is complete! 🥳 Everything is ready ✅
>
> Here's what I just took care of and why each one matters:"

Then list ONLY the tools that are relevant to the user's OS. For each tool, honestly state what happened:
- **If you installed it fresh:** "**[tool]** - Installed! ✅ [one-sentence explanation of what it does]"
- **If it was already installed:** "**[tool]** - Already set up, verified and healthy ✅ [one-sentence explanation of what it does]"
- **If it was skipped or unavailable:** Don't list it at all

Use these explanations (adapt to actual tool names on user's OS):
- **Package manager** (Homebrew / winget / apt) - "this is how I install tools on your machine. You'll never need to touch it yourself, but it's the engine under the hood"
- **Build Tools** (Xcode CLI Tools / Visual C++ Build Tools) - "the foundation that lets your computer compile and build software. Without this, many packages would fail to install" *(only list if it was installed or detected in Step 1.5)*
- **Python** - "used behind the scenes to compile certain software packages" *(only list on Windows if it was installed in Step 1.5)*
- **bun** - "the runtime that makes your projects fast. It handles dependencies and runs your code"
- **git** - "tracks every change to your code, like an unlimited undo button. I manage it automatically"
- **GitHub CLI** - "the bridge to your GitHub vault where everything gets stored safely"

End with:
> "I'll use the right commands for your system automatically from now on.
>
> I'm juiced up and boosted ⚡️"

Then immediately proceed to Step 9.

### 9. Handoff to Project Init

> [!IMPORTANT]
> **Do not stop after Step 8.** New users will not know what to do next. This step bridges the gap between global setup and their first project.

#### 9.1 Prompt for project name

Tell the user:

> "Now let's create your first project folder.
> This is where your first project will be built.
>
> ‼️ You should not build inside this setup folder. ‼️
>
> So let's create a new one and I will guide you.
>
> What would you like to name your project?
>
> You can either:
> - Give me a name directly (e.g., `my-portfolio`, `ai-chat-app`)
> - Or describe what you want to do for your next project in a few sentences and I'll pick a good name for you"

Wait for the user's response. If they describe what they're building, generate a lowercase, hyphenated folder name from their description (e.g., "I want to build a recipe sharing app" becomes `recipe-share`).

> [!CAUTION]
> **Extension activation guardrail:** If the user's response mentions an extension or tool name (NotebookLM, Cloudflare, Firecrawl, etc.), do NOT activate the extension. Treat their response purely as a project description and generate a folder name from it. Example: "I want to do notebookLM research" -> folder name: `notebooklm-research`. Extensions are set up AFTER the user opens their new project folder - never inside the Liftoff source directory.
The idea here is only to understand what the user wants generate a folder name from it. 

#### 9.2 Create the project folder

**Always use `~/dev/` as the parent directory.** This is a hard convention - all projects live in `~/dev/`. Create it if it doesn't exist.

**macOS/Linux:**
```bash
mkdir -p ~/dev/<project-name>
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\dev\<project-name>"
```

**Before showing the closing message**, delete the progress tracker:
```bash
rm -f ~/.cursor/liftoff/setup/setup-progress.md
```

After creating, tell the user:

> "We are ready for take-off ⚡️! Instead of moving on foot, you now have a rocket 🚀
>
> Sami says hi and congratulations - you just unlocked what 99% of builders don't have. This is your unfair but totally fair advantage - you will see once you start using Cursor with Liftoff.
>
> ‼️ **A note from Sami:** Keep all your projects inside `~/dev/` - that's the convention for everything going forward. And once a folder is created, **never rename it** - renaming breaks git remotes, symlinks, and cached paths. If you want a different name, create a new project from scratch. Don't worry - your agent will also know all of this automatically!
>
> 👉 Now, to start building, open your new project folder:
>
> **Step 1:** In **Cursor**, use **File** > **Open Folder** (or Cmd+O on Mac / Ctrl+O on Windows)
> **Step 2:** Navigate to `~/dev/<project-name>/` and open it
> *(If a dialog asks to save changes, click **Don't Save** - the setup is already done)*
> **Step 3:** In the new window, say the word **liftoff**
>
> 👋🏼 **Important:** Don't say liftoff here - you need to be in your new project folder first! Follow the steps above."

#### 9.3 What happens in the new window

The agent in the new window will detect an empty, un-initialized project folder (no `.cursor/.liftoff-init` marker) and should automatically run the `init-project` workflow. The user saying "liftoff" confirms this, but even if they say something else, the auto-detection should trigger. See the `Session Start` rules in the `liftoff-lifecycle` skill and the "Liftoff" trigger for details.

## Common Commands Reference

The agent should use the correct commands based on what was noted:

| Action | brew (macOS) | winget (Windows) | apt (Linux) |
|---|---|---|---|
| Install | `brew install <pkg>` | `winget install <pkg>` | `sudo apt install <pkg>` |
| Update all | `brew upgrade` | `winget upgrade --all` | `sudo apt update && sudo apt upgrade` |
| Search | `brew search <pkg>` | `winget search <pkg>` | `apt search <pkg>` |
| Uninstall | `brew uninstall <pkg>` | `winget uninstall <pkg>` | `sudo apt remove <pkg>` |
| Health check | `brew doctor` | n/a | `sudo apt --fix-broken install` |

## Troubleshooting

**"brew: command not found" after install**: Shell env not loaded. Run the Step 2 shell env commands, then restart terminal.

**brew exists but permission denied**: Multi-user Mac. Do **not** fix permissions. Note `Package Manager: unavailable` and use curl/direct-download for all tools.

**"winget is not recognized"**: Windows version too old (pre-10) or App Installer not installed. Direct user to Microsoft Store to install "App Installer".

**"error: could not find cl.exe" or "node-gyp rebuild failed" on Windows**: Visual C++ Build Tools are missing. Run: `winget install Microsoft.VisualStudio.2022.BuildTools --override "--quiet --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"` and restart the terminal.

**"python is not recognized" on Windows**: Python is not installed. Run: `winget install Python.Python.3.12` and restart the terminal.

**Visual C++ Build Tools install hangs or fails**: The download is large (~2-4 GB). Ensure the user has a stable internet connection. If winget fails, direct the user to https://visualstudio.microsoft.com/visual-cpp-build-tools/ for manual download.

**"gh: command not found" after install**: Restart terminal or run `eval "$(/opt/homebrew/bin/brew shellenv)"` on macOS.

**Permission denied on any OS**: Corporate/managed machine. Note `unavailable` in Machine Environment and move on. The agent will provide manual download links instead of package manager commands.
