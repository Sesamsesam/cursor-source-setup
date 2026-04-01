---
name: autorag-pipeline
description: "RAG Level 1 - Build a RAG knowledge base with file upload and chat - powered by Cloudflare AutoRAG, R2, and Workers"
---

# AutoRAG Pipeline - RAG Level 1

> A chatbot searches 50 pages. AutoRAG searches 50,000 and tells you exactly which document, which paragraph, and why.

> Build a working "RAG knowledge base with chat" app in one session (20 mins). Upload PDFs, ask questions in plain English, get AI answers with source citations. All on Cloudflare's free tier.

> [!IMPORTANT]
> **Prerequisite**: The `cloudflare-mcp` extension must be active and authenticated. Follow the Cloudflare skill to set up first.

> [!TIP]
> **This is RAG Level 1** - the free-tier entry point for a quick 15-20 min setup. 
For enterprise-grade precision in regulated industries, see **RAG Level 2** (`vertex-rag-pipeline`).

---

## What Is This?

**RAG** (Retrieval-Augmented Generation) lets you upload documents and ask questions about them in plain English. The system finds relevant passages, synthesizes an answer, and cites its sources. No folder searching, no Ctrl+F.

**AutoRAG handles everything behind the scenes:**

1. **Storage** - Your documents live in an R2 bucket (Cloudflare's cloud storage)
2. **Indexing** - AutoRAG automatically chunks your documents, converts them into searchable vectors, and keeps the index up to date
3. **AI-powered answers** - When you ask a question, it finds the most relevant passages and generates an answer with citations


---

## Who Is This For?

The pattern is the same for every role: take the mountain of documents you already have, make them searchable through conversation, and get trusted answers grounded in your own sources.

| Professional | What You Upload | What You Ask |
|---|---|---|
| **Salespeople** | Product specs, competitor analysis, case studies | "What are our strongest differentiators against [competitor]?" |
| **Customer Support** | Knowledge base articles, past tickets, SOPs | "How do we handle auto-renewal refund requests?" |
| **Project Managers** | Briefs, meeting notes, status reports | "What were the blockers across all Q4 projects?" |
| **Consultants** | Client research, proposals, industry reports | "What methodology did we use for the last fintech engagement?" |
| **HR / Legal** | Policies, handbooks, compliance docs | "What's our parental leave policy for remote employees?" |
| **SaaS Operators** | API docs, changelogs, runbooks | "How do I set up webhooks for payment events?" |

> [!NOTE]
> **Accountants and financial analysts** - AutoRAG is great for document search and quick lookups. But if you need cross-referencing large financial datasets or legally defensible analysis, see **RAG Level 2** (`vertex-rag-pipeline`).

---

## What You'll Have When Done

A deployed web app where you can:
- Upload PDF documents to a knowledge base
- Ask questions in natural language and get AI answers grounded in your documents
- See source citations showing where the answer came from

---

## What You'll Need to Do

> The agent does 90% of the work. Here are the only moments where you need to act:

1. **Upload your PDF documents** to R2 via the Cloudflare Dashboard (drag and drop)
2. **Create the AutoRAG instance** in the Cloudflare Dashboard (agent guides you through it)
3. **Approve `wrangler login`** in your browser when it opens (click "Allow")

Everything else - creating the R2 bucket, writing the API, building the chat interface, and deploying - is handled by the agent.

<!-- ═══════════════════════════════════════════════════ -->
<!-- SETUP STEPS                                        -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Step-by-Step Setup

### Step 1 - Set the Active Cloudflare Account

**Agent action.** Use the Cloudflare MCP tools to list accounts and set the active one. You must set the active account on **both** the `bindings` and `auto-rag` MCP tool groups - they maintain separate contexts.

---

### Step 2 - Create an R2 Bucket

**Agent action.** Create the storage bucket for documents using the MCP `r2_bucket_create` tool. The bucket name must be globally unique, lowercase, and use only letters, numbers, and hyphens.

---

### Step 3 - Upload Documents to R2

> [!IMPORTANT]
> **You need to do this part.**
> The MCP server cannot upload files to R2 directly. Upload your PDFs manually:
> 1. Go to the **Cloudflare Dashboard** > **R2 Object Storage** > select your bucket
> 2. Click **Upload** > drag and drop your PDF files
> 3. Confirm the files appear in the bucket's file list
>
> **Tip:** You can also organize files in folders (e.g., `legal/`, `contracts/`) if you want to filter by topic later.

---

### Step 4 - Create an AutoRAG Instance

> [!IMPORTANT]
> **You need to do this part.**
> AutoRAG instances are created in the Cloudflare Dashboard (no MCP tool exists for this):
> 1. Go to **Compute & AI** > **AI Search** in the sidebar
> 2. Click **Create AutoRAG**
> 3. Give it a name (e.g., `my-rag-app`) - **tell the agent this name**, it needs it for the code
> 4. Select the R2 bucket you created in Step 2 as the data source
> 5. Choose an embedding model (the default is fine for most use cases)
> 6. Click **Create** and wait for initial indexing to complete (status shows "Active")
>
> **Important:** The AutoRAG name is the ID used everywhere in code. Keep it simple - lowercase, hyphens only. It cannot be changed after creation.

---

### Step 5 - Verify AutoRAG is Working

**Agent action.** Use the MCP tools to confirm the instance is live and documents are indexed:
- List AutoRAG instances to verify the instance appears and is active
- Run a test search query to confirm it returns relevant chunks from your documents
- Run an AI search to confirm it generates answers with source citations

If `search` works but `ai_search` fails, it's usually because indexing is still in progress. Wait a few minutes and try again.

---

### Step 6 - Scaffold the Project

**Agent action.** Create a monorepo with a React + Vite frontend and a Cloudflare Worker API:

```
my-rag-chat/
├── frontend/          <- React + Vite chat UI
├── api/               <- Cloudflare Worker API
│   ├── src/index.ts   <- Worker entry point
│   └── wrangler.toml  <- Cloudflare config
└── package.json
```

---

### Step 7 - Create the Worker API

**Agent action.** Create the Cloudflare Worker with two endpoints:

**`wrangler.toml` bindings:**
```toml
[ai]
binding = "AI"

[[r2_buckets]]
binding = "R2"
bucket_name = "your-bucket-name"

[vars]
AUTORAG_NAME = "your-autorag-name"
```

**Endpoints:**
- `POST /api/chat` - Takes a `query` string, calls AutoRAG's `aiSearch`, returns the AI answer and source citations
- `POST /api/upload` - Accepts a file via FormData, stores it in R2 under a `documents/` prefix

The Worker uses `env.AI.autorag(env.AUTORAG_NAME)` to connect to AutoRAG. This is the key binding - AutoRAG handles all the vector search and AI generation automatically.

> [!NOTE]
> AutoRAG automatically re-indexes when new files appear in the R2 bucket. There is no manual trigger needed - just upload and wait a few minutes.

---

### Step 8 - Wrangler Login

> [!IMPORTANT]
> **You need to do this part.**
> Before the Worker can be deployed, Wrangler needs permission to access your Cloudflare account:
> 1. The agent will run `bunx wrangler login` - this opens a browser window
> 2. Click **"Allow"** to grant access
> 3. The terminal should show "Successfully logged in"

---

### Step 9 - Build the Chat UI

**Agent action.** Build a React chat interface with:
- A text input and send button
- Message history with markdown rendering
- Source citations below each answer (filename, relevance score, excerpt)
- A file upload button for adding new documents
- Loading and error states

---

### Step 10 - Deploy

**Agent action.** Deploy the Worker API and the frontend to Cloudflare:
- Worker deploys via `bunx wrangler deploy`
- Frontend builds with Vite and deploys to Cloudflare Pages

The agent will output the live URLs when deployment is complete.

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## When You Need RAG Level 2

> [!CAUTION]
> AutoRAG is **not** for high-stakes precision in regulated industries. If decisions depend on the output (tax positions, legal analysis, audit reports), you need grounding controls and confidence scoring.

**Use `vertex-rag-pipeline` if:**
- You need numerical analysis at scale (financial modeling, BigQuery)
- You're in a regulated industry (HIPAA, SOC 2)
- Hallucination tolerance is zero (legal, medical, financial reporting)

> [!TIP]
> **Start with Level 1 anyway.** It teaches RAG concepts on a free platform, and the frontend architecture transfers directly to Level 2.

---

## Cloudflare Free Tier Coverage

| Service | Free Limit | Plenty For |
|---|---|---|
| R2 | 10 GB storage, 10M reads/mo | Hundreds of documents |
| Workers | 100K requests/day | Heavy personal/team usage |
| AutoRAG | Check current limits | Document processing + search |
| Pages | Unlimited sites | Frontend hosting |

---

## Activation
- When the user wants to build a RAG knowledge base
- When asked about document search, knowledge bases, or AI-powered Q&A
- When asked to "chat with my documents" or "build a document assistant"

---

## Agent Rules

1. **Use Cloudflare MCP tools** to create R2 buckets and verify AutoRAG status - never manual
2. **Set active account on BOTH `bindings` and `auto-rag` MCP tool groups** - they maintain separate contexts. Forgetting one causes "account not set" errors
3. **Verify each component** before moving to the next (create R2 > confirm > upload docs > create AutoRAG > verify search works)
4. **Never delete R2 buckets via MCP** - destructive operations go through the dashboard only
5. **Log every infrastructure ID** (bucket name, AutoRAG name) in the project config
6. **Keep it simple** - no D1 database, no auth, no modes. Just R2 + AutoRAG + Worker + React chat
7. **Use `AUTORAG_NAME` as an env variable** in `wrangler.toml`, never hardcode it
8. **Sanitize error messages** - Wrangler sometimes returns HTML error pages. Always strip HTML tags before displaying in the UI
9. **Test end-to-end** before declaring complete - upload a test doc, wait for indexing, query, verify citations appear

Source: [AutoRAG Docs](https://developers.cloudflare.com/ai-search/) | [R2 Docs](https://developers.cloudflare.com/r2/)
