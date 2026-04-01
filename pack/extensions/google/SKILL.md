---
name: google
description: "Connect to Google Cloud and Google Workspace via MCP. Manage infrastructure, send emails, organize Drive, create spreadsheets - all through natural language."
---

# Google (Cloud + Workspace)

> **Two powerhouses, one extension.** Google Cloud for infrastructure. Google Workspace for productivity. Both controlled from right here.

This extension gives Cursor (via Liftoff) access to Google's ecosystem through two CLI tools:

- **Google Cloud CLI (`gcloud`)** - Manage cloud infrastructure: Cloud Run, Cloud SQL, BigQuery, Compute Engine, Cloud Storage, and 8,000+ commands across all Google Cloud services
- **Google Workspace CLI (`gws`)** - Control productivity apps: Gmail, Drive, Calendar, Sheets, Docs, Meet, Chat, and more

Both tools authenticate with your Google account. The agent runs them via terminal commands and receives structured JSON responses.

> [!NOTE]
> **CLI-based access, not MCP.** Google removed MCP server mode from `gws` in v0.8.0. Both tools work through direct CLI commands. This is functionally equivalent - the agent just runs commands like `gws drive files list` instead of calling MCP tools.

> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for gcloud installation, GCP project creation, and gws configuration.

---

## Before vs After: Managing Your Google Services

**Without MCP (15-30 min manual per task):**
1. Open Gmail in browser, compose email, format, send
2. Switch to Drive, navigate folders, upload file
3. Open Calendar, create event, add guests
4. Open Sheets, create spreadsheet, enter data
5. Context-switch between 4+ tabs constantly

**With MCP:**
> "Send an email to [person] about the meeting, create a calendar event for next Tuesday, and put the agenda in a new Google Doc." Done in one message.

---

## What You Can Do

### Google Cloud (`gcloud`)

| Category | Examples |
|---|---|
| Compute | Deploy to Cloud Run, manage VMs, configure load balancers |
| Data | Create Cloud SQL databases, run BigQuery queries |
| Storage | Manage Cloud Storage buckets, upload/download files |
| AI/ML | Access Vertex AI, manage models, run predictions |
| Networking | Configure DNS, VPCs, firewalls |
| IAM | Manage service accounts, permissions, roles |

### Google Workspace (`gws`)

| Service | What You Can Do |
|---|---|
| **Gmail** | Read, search, send, reply, label, archive emails |
| **Drive** | List, upload, download, organize, share files |
| **Calendar** | Create, update, list events, check availability |
| **Sheets** | Create spreadsheets, read/write cells, format data |
| **Docs** | Create documents, read content, manage sharing |
| **Meet** | Access meeting info, manage recordings |
| **Chat** | Send messages to spaces, manage conversations |

---

## Workflows

| Workflow | File | What It Does |
|---|---|---|
| Google Cloud | `workflows/cloud.md` | Add gcloud MCP server to Cursor |
| Google Workspace | `workflows/workspace.md` | Add gws MCP server to Cursor |

Run one or both after completing [SETUP.md](./SETUP.md). Cloud should be done first since gws depends on gcloud for its initial setup.

---

## Activation
- Enable in `~/.cursor/liftoff/extensions/extensions.json`: `"google": true`
- Triggered by: Google services, Gmail, Drive, Calendar, Sheets, Docs, Cloud Run, BigQuery, GCP

---

## Agent Rules

- **Verify auth** before operations - guide through OAuth if not completed
- **Respect scope limits** - only request scopes for services the user actually needs
- **Security-first** - never auto-send emails or share files without explicit user confirmation
- **Explain actions** - tell user what was accessed/modified and provide links when available
- **Handle scope errors gracefully** - if an API returns 403, explain which scope is needed and how to add it
- **Don't over-request** - start with the 6 default services (Drive, Gmail, Calendar, Sheets, Docs, Meet), add more only when needed
- **Privacy-aware** - remind users that the agent can now read their email/files, and to disable the extension when not needed

Source: [googleworkspace/cli](https://github.com/googleworkspace/cli) | [Google Cloud SDK](https://cloud.google.com/sdk)
