---
name: security-guardian
description: "14-point security framework. Covers the 95% that matters - agent enforces automatically on every code change."
---

# Security Guardian

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
A 14-point security checklist enforced automatically on every code change. Covers the measures that prevent 95% of real-world vulnerabilities.

## Why Does It Exist?
Most breaches exploit simple mistakes: exposed API keys, unsanitized inputs, missing auth checks. This skill ensures the agent catches them before they ship.

## What It Does For You
You never think "did I handle security?" The agent checks for leaked secrets, validates inputs, enforces auth boundaries, and audits dependencies - every time.

---

## Activation
- **Every code change.** Checked during the Guard phase of F.O.R.G.E.
- Triggered by: new files, mutations, API routes, env vars, dependency additions, file uploads, error handling, deployment configs

## Enforcement
- Agent MUST run these checks before any commit
- Violations are fixed before proceeding, never deferred
- Security is never pushed to "a later sprint"

<!-- ═══════════════════════════════════════════════════ -->
<!-- THE 14-POINT FRAMEWORK                             -->
<!-- ═══════════════════════════════════════════════════ -->

---

## The 14-Point Framework

### 1. Secrets Exposure
Scan every file for hardcoded secrets before commit.

**Detection regexes:**
```
sk-[a-zA-Z0-9]{20,}          # OpenAI
ghp_[a-zA-Z0-9]{36}          # GitHub PAT
sbp_[a-f0-9]{40}             # Supabase
AIza[a-zA-Z0-9_-]{35}        # Google API
AKIA[A-Z0-9]{16}             # AWS
Bearer [a-zA-Z0-9._-]+       # Auth tokens
-----BEGIN (RSA |EC )?PRIVATE KEY-----
eyJ[a-zA-Z0-9_-]+\.eyJ       # JWT tokens
```
**Action:** If found - warn, remove from code, add to `.env`, update `.gitignore`.

### 2. Secrets in Chat
Detect when user pastes a key/token/password into chat.
**Action:** Warn immediately: "I see what looks like a secret. I won't include this in any code or commit. Please rotate this key."

### 3. Input Hardening
Every user input validated before processing.
- Zod schemas on ALL mutation/action inputs (Convex pattern)
- `sanitizeText()` for plain text, `sanitizeHtml()` only for rich text
- Never trust client-side validation alone - always validate server-side

```typescript
// ✅ Correct - Zod schema validates input
export const createPost = mutation({
  args: {
    title: v.string(),
    content: v.string(),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Not authenticated");
    const safeTitle = sanitizeText(args.title);
    // ...
  },
});
```

### 4. File Upload Security
Validate uploads server-side, never trust file extensions alone.
- Check magic bytes (file signature), not just extension
- Enforce size limits per upload type
- Allowlist file types (never blocklist)
- Store in sandboxed storage (Convex file storage, S3 with restricted access)
- Generate new filenames - never use user-provided filenames in paths

### 5. Database Injection
- Parameterized queries only - never string concatenation
- Convex provides type safety by default - leverage it
- For raw SQL (Supabase): always use parameterized queries via the client SDK
- Never expose raw database IDs in URLs without auth checks

### 6. Auth Boundary
Every public mutation/action must verify identity.

```typescript
// ✅ First line of every public mutation
const identity = await ctx.auth.getUserIdentity();
if (!identity) throw new Error("Not authenticated");
```

- Use `internalMutation`/`internalAction` for server-only operations
- Never use `mutation` for admin-only operations without role checks
- Check ownership: user can only modify THEIR data

### 7. Credential Rotation
Track in `.liftoff/security.json`:
```json
{
  "credentials": {
    "CONVEX_DEPLOY_KEY": { "lastRotated": "2026-01-15", "rotationDays": 90 },
    "CLERK_SECRET_KEY": { "lastRotated": "2026-02-01", "rotationDays": 90 }
  }
}
```
Agent checks during Session Start. If overdue - warn with specific instructions.

### 8. Dependency Auditing
Run `bun audit` or `npm audit` before every deployment.
- Critical/High vulnerabilities must be resolved before shipping
- Document any accepted risks with a comment explaining why

### 9. Log Safety
- Redact tokens before logging - show only last 4 chars: `sk-...a1b2`
- Never log full request bodies that may contain passwords
- Never log full error stacks to user-facing responses
- Use structured logging (JSON format)

### 10. `.gitignore` Hygiene
Must include:
```gitignore
.env*
.liftoff/
node_modules/
*.pem
*.key
.wrangler/
.convex/_generated/
```
On project init, verify `.gitignore` exists and covers all patterns.

### 11. Deployment Config
- CORS: specific origins only, never `*` in production
- Debug mode: OFF in production
- Error messages: generic for users, detailed in server logs
- HTTPS only - no mixed content

### 12. Dependency Verification
Before installing any package:
- Does it exist on npm? (Catch hallucinated package names)
- Meaningful download counts? (Catch typosquatting)
- Name exactly correct? (`lodash` not `1odash`)
- Check last publish date - abandoned packages may have vulnerabilities

### 13. Error Handling (Security Angle)
- Never "fail open" - if auth check errors, DENY access
- User-facing errors: generic ("Something went wrong")
- Server logs: detailed for debugging
- Never expose stack traces, file paths, or internal IDs to users
- For full error handling patterns (what TO do), see `error-handling` skill

### 14. Secure Prompting
- Never hardcode secrets in code examples or artifacts
- Always include input validation when generating mutation code
- When generating auth code, always check identity first
- Never suggest `eval()`, `innerHTML`, or `dangerouslySetInnerHTML` without sanitization
- When suggesting env vars, always mention `.env` + `.gitignore`

<!-- ═══════════════════════════════════════════════════ -->
<!-- REFERENCE                                          -->
<!-- ═══════════════════════════════════════════════════ -->

---

## What We Skip (The 5%)

Real measures, but require specialized expertise beyond solo developer needs:

- CSP headers, SRI, certificate pinning
- DNSSEC, custom WAF rules, penetration testing

> [!TIP]
> If the project reaches production scale with paying users, revisit this list.
