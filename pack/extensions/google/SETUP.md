---
name: google-setup
description: "One-time setup: install gcloud CLI, create GCP project, install gws CLI, create OAuth credentials, and authenticate."
---

# Google - Setup Guide

> **One-time setup.** Once complete, the agent verifies the connection via CLI. This file is not needed again.

## Checklist

- [ ] Step 1: Install Google Cloud CLI (`gcloud`)
- [ ] Step 2: Authenticate gcloud and create GCP project
- [ ] Step 3: Install Google Workspace CLI (`gws`)
- [ ] Step 4: Enable APIs
- [ ] Step 5: Create OAuth credentials (requires browser)
- [ ] Step 6: Authenticate gws
- [ ] Step 7: Verify connection

---

## Agent Guidance Rules

> [!IMPORTANT]
> **If something goes wrong during setup,** the agent must try to resolve it automatically first. Retry commands, try alternative approaches, check error messages, and attempt fixes independently. Only after exhausting automatic solutions should the agent fall back to guiding the user manually. When that happens, switch to step-by-step guide mode: one action at a time, tell the user exactly what to do and what they should see, and ask them to confirm with **'done'** before moving on.

**Browser confirmation protocol:** Every time the agent opens a browser URL (using `open` or `start`), immediately ask:

> "Did a browser window open? If not, let me know and I'll open it again. Once it's open, here's what to do: [instructions]"

Never assume a browser opened successfully. Always confirm before giving the next set of instructions.

---

### Step 1: Install Google Cloud CLI

**macOS:**
```bash
brew install google-cloud-sdk
```

**Windows (PowerShell):**
```powershell
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:TEMP\GoogleCloudSDKInstaller.exe")
& "$env:TEMP\GoogleCloudSDKInstaller.exe"
```

**Linux:**
```bash
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
tar -xf google-cloud-cli-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
```

> [!NOTE]
> For other platforms or alternative methods, see the [official gcloud installation guide](https://cloud.google.com/sdk/docs/install-sdk).

Verify:

```bash
gcloud --version
```

Tell the user:

> "Installing the Google Cloud CLI - this takes a couple of minutes.
>
> I'll handle the download automatically."

---

### Step 2: Authenticate gcloud and Create GCP Project

```bash
gcloud auth login
```

This opens a browser window automatically for Google sign-in. The agent should tell the user:

> "A browser window is opening for Google sign-in. Log in with your Google account and approve access.
>
> Tell me **'done'** when you see the confirmation screen."

Wait for user confirmation. After authentication, create a project:

```bash
gcloud projects create liftoff-workspace --name="Liftoff Workspace"
gcloud config set project liftoff-workspace
```

> [!NOTE]
> If the project name is taken, append a unique suffix (e.g., `liftoff-ws-2026`). The agent should retry automatically with a different name.

---

### Step 3: Install Google Workspace CLI

Using the project's preferred package manager:

```bash
# bun (preferred)
bun install -g @googleworkspace/cli

# fallback
npm install -g @googleworkspace/cli
```

Verify:

```bash
gws --version
```

This step is fully automated - no user action needed.

---

### Step 4: Enable APIs

Enable the default services on the GCP project:

```bash
gcloud services enable \
  drive.googleapis.com \
  sheets.googleapis.com \
  gmail.googleapis.com \
  calendar-json.googleapis.com \
  docs.googleapis.com \
  meet.googleapis.com \
  --project=PROJECT_ID
```

Replace `PROJECT_ID` with the actual project ID from Step 2.

This step is fully automated - no user action needed.

---

### Step 5: Create OAuth Credentials (Requires Browser)

> [!IMPORTANT]
> This is the one step that **cannot** be fully automated. The agent must open the browser and guide the user through exactly what to click. Keep the instructions dead simple.

There are three sub-steps. The agent opens each URL automatically.

#### 5a: Configure OAuth Consent Screen

Open automatically:
```bash
# macOS
open "https://console.cloud.google.com/apis/credentials/consent?project=PROJECT_ID"
# Windows
start "https://console.cloud.google.com/apis/credentials/consent?project=PROJECT_ID"
```

Tell the user:

> "I just opened the Google Cloud Console in your browser. Here's what to do:
>
> 1. If it asks for User Type, select **External** and click **Create**
> 2. App name: type `Liftoff Workspace`
> 3. User support email: select your email from the dropdown
> 4. Scroll to the bottom, enter your email again under 'Developer contact information'
> 5. Click **Save and Continue**
> 6. On the Scopes page, just click **Save and Continue** (skip it)
> 7. On the Test Users page, click **+ ADD USERS**, enter your email, click **Add**
> 8. Click **Save and Continue**, then **Back to Dashboard**
>
> Tell me **'done'** when you're back at the dashboard."

Wait for user confirmation.

> [!CAUTION]
> The user **must** add themselves as a test user (sub-step 7). Without this, login will fail with a generic "Access blocked" error and no helpful message.

#### 5b: Create Desktop OAuth Client

Open automatically:
```bash
# macOS
open "https://console.cloud.google.com/apis/credentials/oauthclient?project=PROJECT_ID"
# Windows
start "https://console.cloud.google.com/apis/credentials/oauthclient?project=PROJECT_ID"
```

Tell the user:

> "I opened the credential creation page. Here's what to do:
>
> 1. **Application type**: select **Desktop app**
> 2. **Name**: type `Liftoff` (or any consent-screen name you prefer)
> 3. Click **Create**
> 4. A popup appears - click **Download JSON** (the download icon)
> 5. Close the popup
>
> Tell me **'done'** when you've downloaded the JSON file."

Wait for user confirmation.

#### 5c: Move the Client Secret File

The downloaded file lands in `~/Downloads/` as `client_secret_*.json`. The agent may not have access to `~/Downloads/` on macOS due to sandboxing.

**Strategy:** Ask the user to run a single copy command:

**macOS / Linux:**

Tell the user:

> "Almost there! Run this command in your terminal to move the file into place:
>
> ```
> mkdir -p ~/.config/gws && cp ~/Downloads/client_secret_*.json ~/.config/gws/client_secret.json
> ```
>
> Tell me **'done'** when it's run."

**Windows (PowerShell):**

Tell the user:

> "Almost there! Run this command in PowerShell to move the file into place:
>
> ```
> New-Item -ItemType Directory -Force -Path "$env:APPDATA\gws" | Out-Null; Copy-Item "$env:USERPROFILE\Downloads\client_secret_*.json" "$env:APPDATA\gws\client_secret.json"
> ```
>
> Tell me **'done'** when it's run."

**Alternative:** Ask the user to move the file to the project directory (which the agent can access), then the agent copies it:

```bash
# macOS / Linux
mkdir -p ~/.config/gws && cp /path/to/client_secret_*.json ~/.config/gws/client_secret.json

# Windows (PowerShell)
New-Item -ItemType Directory -Force -Path "$env:APPDATA\gws" | Out-Null
Copy-Item "C:\path\to\client_secret_*.json" "$env:APPDATA\gws\client_secret.json"
```

---

### Step 6: Authenticate gws

> [!NOTE]
> An alternative one-command setup exists: `gws auth setup`. It can handle project creation, API enabling, and OAuth in one interactive flow. However, it requires a working TUI and may not work in all agent environments. The manual steps below are more reliable.

```bash
gws auth login -s drive,gmail,calendar,sheets,docs,meet
```

This launches an interactive scope selection TUI, then prints an auth URL.

**Agent flow:**
1. When the scope selector appears, the "Recommended" preset is pre-selected (~28 scopes for the 6 services). Press **Enter** to confirm it.
2. When the auth URL is printed, open it in the user's browser: `open "<URL>"` (macOS) / `start "<URL>"` (Windows)
3. Tell the user what to do in the browser

Tell the user:

> "I'm opening a browser window for you to approve access to your Google apps.
>
> Did a browser window open? If not, let me know and I'll open it again.
>
> You'll see **'Google hasn't verified this app'** - this is normal. Click **Advanced**, then **Go to Cursor Workspace (unsafe)**.
>
> Check all the scope boxes and click **Continue**.
>
> Tell me **'done'** when the browser shows a success page."

Wait for user confirmation.

> [!WARNING]
> **Scope limit for unverified apps:** The OAuth app is in "testing mode," which limits consent to ~25 scopes. The 6 default services (Drive, Gmail, Calendar, Sheets, Docs, Meet) with the "Recommended" preset use ~28 scopes, which is within the limit. Do NOT use `-s all` during auth without service filtering, as it includes 85+ scopes and will fail.

---

### Step 7: Verify Connection

> [!NOTE]
> **No MCP server for gws.** Google removed MCP server mode from the gws CLI in v0.8.0. The agent accesses Google Workspace by running `gws` commands directly through the terminal. This works the same way - it just doesn't appear in the MCP servers list.

**Smoke test:**

```bash
gws drive files list --params '{"pageSize": 1}'
gws gmail users messages list --params '{"userId":"me","maxResults":1}'
```

If both return JSON data (even empty results), the connection works.

Tell the user:

> "Google Workspace is connected! I can now:
>
> - Read and send emails via Gmail
> - View and create calendar events
> - Browse, create, and organize Drive files
> - Read and edit Sheets and Docs
> - Access Google Meet
>
> I access these through the `gws` command-line tool. Your credentials are encrypted at rest with AES-256-GCM and never leave your machine."

> ✅ **Setup complete.**

---

## Troubleshooting

### "Access blocked" or 403 during login
You forgot to add yourself as a test user. Go back to Step 5a, sub-step 7.

### "Google hasn't verified this app"
This is expected and safe. Click **Advanced** then **Go to Cursor Workspace (unsafe)**.

### Too many scopes error
You selected too many services. Re-run `gws auth login -s drive,gmail,calendar,sheets,docs,meet` with only the services you need.

### "API not enabled - accessNotConfigured"
The agent forgot to enable an API. Run:
```bash
gcloud services enable <SERVICE>.googleapis.com --project=PROJECT_ID
```

### Can't access Downloads folder
macOS sandboxing may block the agent from reading `~/Downloads/`. The user must run the copy command themselves (Step 5c).

### Adding more services later
No reinstall needed. Just re-authenticate with additional services:
```bash
gws auth login -s drive,gmail,calendar,sheets,docs,meet,chat,keep
```
Then approve the new scopes in the browser.

### General: Something went wrong
If the setup breaks at any point, the agent should:
1. Tell the user exactly what failed and why
2. Offer a clear fix as a single numbered step
3. Ask for **'done'** confirmation before proceeding
4. Never skip a broken step or assume it resolved itself
