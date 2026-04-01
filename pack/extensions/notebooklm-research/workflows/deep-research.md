---
description: "Autonomous research flow: plan work order, start research, poll, import, curate, build consensus, and update the research index."
---

# Deep Research Workflow

> **Step 0 is interactive** - pause for user confirmation. **Steps 1-7 are fully autonomous** - complete every step before stopping. After each step, check the list below and proceed to the next unchecked step.

## Checklist

- [ ] Step 0: Research work order (user confirmation required)
- [ ] Step 1: Start research
- [ ] Step 2: Poll until complete
- [ ] Step 3: Import sources
- [ ] Step 4: Curate sources (classify + delete low-quality)
- [ ] Step 5: Consensus analysis
- [ ] Step 6: Update research index
- [ ] Step 7: → Continue to `workflows/report-handoff.md` initiate without asking

---

### Step 0: Research Work Order

**Always present a structured research plan before starting.** This is the one pause point in the pipeline - everything after this runs autonomously.

**Two paths depending on user input:**

**If the user provided detailed specs** (number of notebooks, specific topics, source quality criteria):
- Parse their instructions into the plan table below
- Do NOT simplify, reinterpret, or override anything they specified
- Present for quick confirmation, then go

**If the user gave a vague topic** (e.g. "research AI"):
- Propose 3-5 notebooks with specific angles that cover the topic comprehensively
- Default to deep mode for all notebooks
- Default to high-quality source criteria (academic, major consultancies, official reports)
- Present for approval - user confirms or adjusts

**Present the plan as a table:**

> | # | Notebook Title | Research Query | Mode | Source Quality |
> |---|---|---|---|---|
> | 1 | [title] | [specific search query] | Deep | [quality criteria if specified] |
> | 2 | ... | ... | Deep | ... |
>
> Look good, or want to adjust anything?

**Rules:**
- If the user specified source quality preferences (e.g. "McKinsey, Gartner, scientific publications only"), carry those criteria forward into the research queries AND into the curation rules in Step 4
- Always default to **deep** mode unless the user explicitly requests fast
- Create the notebooks (`notebook_create`) only after the user confirms the plan
- If the user adjusts the plan, present the updated table and confirm again

> [!IMPORTANT]
> **Never skip this step.** Even if the user seems ready to go, always present the plan table for confirmation. This is the user's only chance to direct the research before the autonomous pipeline takes over.

> ✅ **User confirmed? Check Step 0 off the list. Continue to Step 1.**

---

### Step 1: Start Research

```
research_start(notebook_id, query, source="web", mode="deep"|"fast")
```

- **Deep** (~5 min, ~40-80 sources): comprehensive research
- **Fast** (~30s, ~10 sources): quick lookups

For multiple notebooks, launch all `research_start` calls in parallel.

> ✅ **Done? Check Step 1 off the list. Continue to Step 2.**

---

### Step 2: Poll Until Complete

**Pass `max_wait=1800` to the `research_status` tool call.** This makes the tool poll internally (every ~30 seconds) for up to 30 minutes before returning. The tool returns immediately when research completes - `max_wait` is just the ceiling.

```
research_status(notebook_id, query="<original query>", max_wait=1800)
```

**Use `max_wait=1800` for both fast and deep mode.** This is a buffer, not a target. Fast research typically finishes in under a minute and the tool returns as soon as it does. Deep research may take 5-15 minutes.

If `status` is still `in_progress` after the call returns (meaning 30 minutes passed without completion), call `research_status` again with the same `max_wait=1800` to continue waiting.

> [!NOTE]
> **How `max_wait` works:** It is the total number of seconds the tool spends internally polling before returning a response. It is NOT a polling interval. With `max_wait=1800`, the tool makes one call, handles all waiting internally, and only returns when done or when 30 minutes have passed. This avoids rapid-fire agent-level tool calls.

- Always use `query` for matching (task IDs change during deep research)
- If the tool returns `in_progress` after two consecutive 30-minute waits (60+ minutes total), tell the user:
  > "Research is still running. I'll stop checking now. Take a look in a few minutes and when you think it's done, just tell me and I'll import the results!"
- Poll multiple notebooks in parallel
- **Auth recovery:** If any MCP call fails with an auth/session error during polling, run `nlm login` yourself (do not ask the user to run it), tell them a browser is opening, wait for confirmation, then resume polling

> ✅ **Done? Check Step 2 off the list. Continue to Step 3.**

---

### Step 3: Import Sources

```
research_import(notebook_id, task_id)
```

- Call **immediately** when status returns `completed`
- Import all sources by default (omit `source_indices`)
- Import each notebook as it completes

> [!IMPORTANT]
> **Always auto-import.** Never leave research in "completed but not imported" state.

Log a brief one-liner per notebook: "[Title]: [N] sources imported." Do not present a formatted summary table. Do not ask the user what to do next.

> ✅ **Done? Check Step 3 off the list. Continue to Step 4.**

---

### Step 4: Curate Sources

Immediately after importing, auto-curate sources. Do NOT ask the user whether to curate.

#### 4a. Classify Sources

Use `notebook_query` to have NotebookLM classify its own sources:

```
Classify every source in this notebook. For each source, provide:
1. Source title
2. Publication year (or best estimate)
3. Source credibility tier:
   - TIER_1: Primary research institutions, academic papers, government reports, major consultancies, or any organization that conducted original research with documented methodology
   - TIER_2: Established journalism outlets with editorial oversight, official company filings, earnings reports, or industry body publications
   - TIER_3: Blogs, forums, social media, opinion pieces, listicles, content aggregators, or sources with no clear institutional backing
4. Data quality: ORIGINAL (contains its own data, surveys, experiments, or first-hand analysis) or DERIVATIVE (summarizes, repackages, or comments on other sources)

Be strict. If unsure about credibility, default to TIER_3. Format as a numbered list.
```

**Keep/Remove rules:**
- **Keep:** TIER_1 + ORIGINAL from the current year
- **Keep:** TIER_2 + ORIGINAL from the current year
- **Keep:** TIER_1 + DERIVATIVE only if the original source is NOT already present
- **Remove:** All TIER_3 sources
- **Remove:** Anything older than 12 months
- **Remove:** DERIVATIVE sources when a higher-tier ORIGINAL covering the same findings exists

#### 4b. Delete Low-Quality Sources

Auto-apply keep/remove rules. Delete removed sources with `source_delete(source_id, confirm=True)`. Log a brief summary of what was kept and removed. Do not present the list for user approval.

> ✅ **Done? Check Step 4 off the list. Continue to Step 5.**

---

### Step 5: Consensus Analysis

Run immediately after curation. No user interaction needed.

Query each notebook to map agreement vs. conflict:

```
Analyze the remaining sources for consensus and conflict:
1. What key findings do MULTIPLE sources agree on? List each and note how many sources support it.
2. Are there claims where sources directly contradict each other? List each conflict with the disagreeing sources.
3. Any outlier predictions supported by only a single source?

Focus on substantive claims, not stylistic differences.
```

This consensus map guides report structure:
- **Consensus findings** become the main body
- **Conflicts** are isolated into an appendix
- **Single-source outliers** are noted as "worth monitoring"

Log the consensus/conflict summary briefly. Do not ask the user what to do next.

> ✅ **Done? Check Step 5 off the list. Continue to Step 6.**

---

### Step 6: Update Research Index

Update `research/index.md` with the consensus and conflict findings.

> ✅ **Done? Check Step 6 off the list. Continue to Step 7.**

---

### Step 7: Continue to Report Generation

> [!IMPORTANT]
> **Do not stop. Do not ask the user what to do.** Read `workflows/report-handoff.md` in this extension folder and execute it now.
