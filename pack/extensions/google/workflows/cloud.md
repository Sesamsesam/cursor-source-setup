---
name: google-cloud-workflow
description: "Post-setup: verify Google Cloud CLI (gcloud) connection and available services."
---

# Google Cloud - CLI Workflow

> **Prerequisites:** Complete [SETUP.md](../SETUP.md) first. `gcloud` must be installed and authenticated.

> [!NOTE]
> **CLI access only.** The agent uses `gcloud` commands directly through the terminal. There is no MCP server for the full gcloud CLI. The MCP Store offers a **Cloud Run** server (for deploying containerized apps only) if you need MCP-level integration for that specific service.

## Checklist

- [ ] Step 1: Verify gcloud is ready
- [ ] Step 2: Test operations
- [ ] Step 3: Confirm API access

---

### Step 1: Verify gcloud Is Ready

```bash
gcloud --version
gcloud config get project
gcloud auth list
```

All should return valid output. If not, go back to [SETUP.md](../SETUP.md).

---

### Step 2: Test Operations

```bash
# List enabled APIs
gcloud services list --enabled --project=PROJECT_ID

# List projects
gcloud projects list
```

---

### Step 3: Confirm API Access

The default APIs enabled during setup:

| API | Purpose |
|---|---|
| `drive.googleapis.com` | Google Drive |
| `sheets.googleapis.com` | Google Sheets |
| `gmail.googleapis.com` | Gmail |
| `calendar-json.googleapis.com` | Google Calendar |
| `docs.googleapis.com` | Google Docs |
| `meet.googleapis.com` | Google Meet |

To enable additional APIs:

```bash
gcloud services enable <API>.googleapis.com --project=PROJECT_ID
```

<!-- CREW BRIEF -->
> **After workflow is complete, tell the user:**
>
> "Google Cloud CLI is connected! I can now manage your cloud infrastructure directly through terminal commands.
>
> Some things I can help with: deploying apps to Cloud Run, creating databases, managing storage buckets, querying BigQuery, and configuring networking.
>
> The tools respect your account's permissions - I can only do what your Google Cloud account is allowed to do."

> ✅ **Workflow complete.**
