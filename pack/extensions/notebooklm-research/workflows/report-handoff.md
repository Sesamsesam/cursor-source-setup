---
description: "Generate reports from research, download locally, and hand off to minibook pipeline."
---

# Report Generation & Handoff

> **This workflow continues autonomously from deep-research.md.** Complete every step before stopping.

## Checklist

- [ ] Step 8: Generate reports
- [ ] Step 9: Download reports locally
- [ ] Step 10: → Continue to minibook-pipeline extension

---

### Step 8: Generate Reports

Ask **one short focusing question**, then proceed immediately (do not wait long):

> "Generating reports for each notebook. Any specific angle, or should I go broad?"

If the user doesn't answer quickly, go broad.

**Generate per notebook using `studio_create`:**

```python
studio_create(
    notebook_id="[current notebook ID]",
    artifact_type="report",
    report_format="Create Your Own",
    custom_prompt="""Create a comprehensive, consensus-driven report. Follow this structure:

    (1) EXECUTIVE OVERVIEW - Landscape summary based on majority source agreement.

    (2) CONSENSUS FINDINGS - Main body. Only findings supported by 2+ sources. Organize thematically, not by source. Cite all supporting sources inline. Must read as one coherent narrative.

    (3) SUPPORTING DATA - Key statistics and projections reinforcing consensus. Cite origins.

    (4) FORWARD-LOOKING OUTLOOK - Converging predictions. Note confidence (strong consensus vs. emerging trend).

    (5) CONTESTED AREAS (appendix) - Separated from main narrative. Each conflict: what each side claims, which sources support each position.

    (6) OUTLIER SIGNALS (appendix) - Single-source claims lacking corroboration. Present as "worth monitoring."

    Main body (1-4) must be unified with no contradictions. All disagreements in 5-6 only.""",
    confirm=True
)
```

> ✅ **Done? Check Step 8 off the list. Continue to Step 9.**

---

### Step 9: Download Reports Locally

**Immediately after generating, download each report** into `research/reports/`:

```python
download_artifact(
    notebook_id="[notebook ID]",
    artifact_type="report",
    output_path="research/reports/[slug]_briefing.md"
)
```

**If `download_artifact` fails**, use the fallback:

```python
notebook_query(
    notebook_id="[notebook ID]",
    query="Reproduce the full text of the Briefing Doc report that was just generated, preserving all headings, citations, and formatting."
)
# Save the response as research/reports/[slug]_briefing.md
```

**Naming convention:** lowercase slug from notebook title + `_briefing.md`

After all reports are downloaded, update `research/index.md`.

> ✅ **Done? Check Step 9 off the list. Continue to Step 10.**

---

### Step 10: Continue to Minibook

> [!IMPORTANT]
> **Do not stop. Do not ask what to do next.** Transition to the minibook pipeline:

> "Your research reports are downloaded and ready! Next up, let's turn this into a polished minibook. I'll draft an outline for your approval."

Read the `minibook-pipeline` extension's SKILL.md and begin the minibook workflow, passing the research reports from `research/reports/` as source material.

**Only if the user explicitly declines the minibook**, offer alternatives:
- **Publish reports to Notion** - activate `notion-publishing` extension
- **Build a web blog** - activate `web-blog` extension
- **Keep as-is** - end the workflow
