---
name: minibook-pipeline
description: "End-to-end minibook creation: write a manuscript from research, generate chapter imagery, and hand off for publishing."
---

# Minibook Pipeline

> **Research to published book in three steps.** The agent handles writing, image generation, and review artifacts. You approve the outline, review the prose, and pick the visual style.

This extension turns grounded research (typically from NotebookLM) into a polished, illustrated minibook. It codifies the workflow used to produce "The AI Shift" - an 8-chapter, 45,000-character book synthesized from four research briefings.

---

## Prerequisites

This extension needs research to write from. Before starting:

1. Check `research/reports/` for existing research reports or briefings
2. If none exist, use the `notebooklm-research` extension to run deep research and download reports first. The user can also provide their own source materials (PDFs, articles, notes)
3. Do not proceed until source materials are available in the project

> [!IMPORTANT]
> **The golden rule: no research, no book.** Never start writing a minibook without grounded source material. If the user pushes to skip research, explain that the quality of the book depends entirely on the quality of the research feeding it.

---

## Project Structure

Every minibook follows a consistent folder layout inside the active project:

```
<project-root>/
  research/
    Minibook/
      <book-slug>/
        manuscript.md          # The finished prose (source of truth)
        outline.md             # Chapter outline (approved before writing)
        images/
          cover.png            # Cover / hero image
          ch1.png              # One image per chapter
          ch2.png
          ...
        sources/               # Research inputs (briefings, PDFs, notes)
          briefing-1.md
          briefing-2.md
          ...
```

**Rules:**
- `<book-slug>` is lowercase, hyphenated (e.g., `the-ai-shift`, `quantum-careers`)
- The `manuscript.md` is the single source of truth for all prose
- Images are always named `cover.png`, `ch1.png`, `ch2.png`, etc.
- Source materials go in `sources/` for traceability
- The agent creates this structure automatically when starting a new minibook

---

## Workflow 1: Write and Illustrate

Takes grounded research and produces a structured minibook manuscript with chapter images in one continuous flow.

### Step 1 - Gather Sources

Collect all research materials into `sources/`:
- NotebookLM briefing reports (download via `mcp_notebooklm_download_artifact`)
- PDFs, articles, notes, or any other reference material
- The agent should summarize the source inventory before proceeding

### Step 2 - Create Outline

Before writing any prose, produce `outline.md` with:
- **Title, subtitle, and tagline** (one line each)
- **Chapter list** with:
  - Chapter number and title
  - 2-3 sentence summary of what the chapter covers
  - Key data points or quotes to include
  - The core metaphor or framing device
- **Target audience** statement
- **Estimated length** (word count)

> [!IMPORTANT]
> **Stop and get user approval on the outline before writing.** Never proceed to prose without explicit approval.

### Step 3 - Pre-Writing Questions

After outline approval, ask these two questions **one at a time** (wait for each answer before asking the next):

**Question 1 - Reading length:**
> "How long should the book be? A 5-minute, 10-minute, 20-minute, or 30+ minute read?"

Use this to calibrate character count and elaboration depth:
- 5 min: ~5,000 characters, concise and punchy
- 10 min: ~12,000 characters, moderate depth
- 20 min: ~25,000 characters, thorough coverage
- 30+ min: ~45,000+ characters, comprehensive deep-dive

**Question 2 - Reader and angle:**
> "Who is the reader, and what angle do you want them to walk away with?"

### Step 4 - Write Manuscript

Write the **complete manuscript first**, then generate all images in Step 4b. This ensures every image is informed by the actual chapter content.

Produce `manuscript.md` with placeholder image references:

**Document structure:**
```
# [Title]

### [Subtitle]

*[Tagline]*

---

## Prelude: [Hook Title]

[Hook paragraphs - the most compelling entry point]

![Cover](research/Minibook/<book-slug>/images/cover.png)

[Remaining prelude paragraphs]

---

## Chapter 1: [Title]

![Chapter 1](research/Minibook/<book-slug>/images/ch1.png)

[Body prose]

---

## Chapter 2: [Title]

![Chapter 2](research/Minibook/<book-slug>/images/ch2.png)

[Body prose]

...

---

## Conclusion: [Title]

[Closing prose]

---

*[Source attribution paragraph]*
```

Image placement: cover after prelude hook, chapter images after headings, never two images back-to-back.

**Writing principles:**
- **Plain language.** No jargon unless immediately explained. Write as if the reader is smart but unfamiliar with the field
- **Second-person address.** "You" not "one" or "the reader"
- **Data-backed claims.** Every significant claim gets a blockquote citation:
  ```
  > **[Key statistic or finding in bold.]**
  > *Source: [Organization], "[Report Title]," [Year].*
  ```
- **Personal commentary.** Clearly marked with first-person ("I believe", "from my experience"). Adds authenticity but never replaces evidence
- **Chapter anatomy:** Hook paragraph > Data callout (blockquote) > Analysis > Practical implications > Transition to next chapter
- **Tables** for comparative data (job growth projections, framework comparisons)
- **No em dashes.** Use commas, semicolons, or restructure the sentence
- **Consistent voice.** Direct, conversational, occasionally urgent. Never academic

**Quality gates:**
- Every chapter must have at least one data-backed blockquote citation
- No unsourced statistics
- Transitions between chapters must be explicit ("And that brings us to...")
- The prelude must hook within the first two sentences
- The conclusion must include actionable next steps

### Step 4b - Generate Chapter Images

**After the full manuscript is written**, generate all images. Each image is crafted to match the specific content of its chapter.

Create N+1 images (cover + one per chapter):

| Image | Naming | Prompt Strategy |
|---|---|---|
| Cover | `cover.png` | Captures the book's overarching theme/metaphor |
| Chapter 1 | `ch1.png` | Visualizes the chapter's core concept or key finding |
| Chapter 2 | `ch2.png` | Visualizes the chapter's core concept or key finding |
| ... | `chN.png` | Each image ties to its chapter's central idea |

**Default style prompt (always applied):**

Every image prompt MUST include this style directive:

> "Modern minimalist editorial illustration. Clean lines, soft gradients on a light, airy canvas (whites, light grays, warm neutrals). Punctuated by deliberate, elegant strokes of accent color - think teal, soft coral, muted gold, or rich blue - that draw the eye and add visual energy without overwhelming the composition. Flat or semi-flat design with geometric simplicity. Generous whitespace. Typography-friendly layout. The overall feel should be fresh, premium, and inviting - minimalist but never dull. Inspired by the clean, approachable aesthetic of Google brand illustrations and modern consultancy report visuals. The image may include relevant text or labels if they enhance clarity to the chapter of the manuscript to which they are being created."

**Anti-patterns (never do these unless exclipcityly asked by the user):**
- Never cartoony, whimsical, or playful characters
- Never dark, dystopian, or dramatic lighting
- Never photorealistic human faces
- Never clip-art or stock illustration style
- Never overly complex or busy compositions
- Never neon or garish color palettes

**Rules:**
- Save to `research/Minibook/<book-slug>/images/`
- Each prompt combines the default style directive above with a description specific to the chapter's content
- Maintain visual consistency across all images (same palette, same rendering style)
- The user can regenerate individual images later if they want a different style

### Step 5 - Create Review Artifacts

After all chapters are written and images generated, create three deliverables before presenting to the user:

#### 5a. Image Review Carousel (artifact)

Create an artifact file with a carousel showing all generated images so the user can flip through and approve the visual style:

````carousel
![Cover](absolute/path/to/images/cover.png)
<!-- slide -->
![Chapter 1](absolute/path/to/images/ch1.png)
<!-- slide -->
![Chapter 2](absolute/path/to/images/ch2.png)
<!-- slide -->
...continue for all chapters
````

This lets the user quickly review image quality and consistency before reading the full manuscript.

#### 5b. Manuscript File (project file)

The `manuscript.md` file already created during Step 4 is the source of truth. It contains the full prose with relative image paths at the correct locations (as shown in the document structure above). This is what the agent uses when publishing to Notion or building a web page.

#### 5c. Visual Review Artifact (artifact)

Create a second artifact that is the **full manuscript with images rendered inline**. This uses absolute paths so images actually display inside Cursor:

```markdown
# [Title]
### [Subtitle]
*[Tagline]*

---

## Prelude: [Hook Title]
[Hook paragraphs]

![Cover](/absolute/path/to/images/cover.png)

## Chapter 1: [Title]
![Chapter 1](/absolute/path/to/images/ch1.png)
[Body prose]
...
```

This gives the user a "printed book" preview - they can scroll through the entire manuscript with images appearing between chapters, exactly as a reader would experience it. The .md file in the project folder only shows file paths, but this artifact renders the actual images.

### Step 6 - User Review

Present all three deliverables:
1. **Image carousel** - "Flip through the images first - do they match the style you wanted?"
2. **Visual manuscript** - "Here's the full book with images rendered inline - scroll through it like a reader would"
3. **Manuscript file** - "The source file is at `research/Minibook/<slug>/manuscript.md` - this is what we'll use for publishing"

Expect iterative edits. The user may:
- Rewrite passages in their own voice
- Add personal commentary
- Adjust data framing
- Change chapter ordering
- Request image regeneration for specific chapters

After edits, update `manuscript.md` AND regenerate the visual review artifact to reflect changes. `manuscript.md` remains the source of truth.

---

## Publishing Handoff

After the user approves the manuscript and images, offer publishing options:

> "Your minibook is ready! What would you like to do with it?
>
> 1. **Publish to Notion** - a formatted page with all your images and chapters, ready to share
> 2. **Build a web blog** - a beautiful one-page blog article you can put online
>
> Or you can just keep the manuscript as-is and decide later."

**Branch routing:**
- If user picks **Notion**: activate the `notion-publishing` extension (follow the Activation Flow in the `liftoff-lifecycle` skill). If SETUP.md has not been completed, run it first. Pass the manuscript + images to it
- If user picks **web blog**: activate the `web-blog` extension and pass the manuscript + images. The extension scaffolds a Vite+React+Tailwind project and generates the blog article with dynamic content rendering
- If user says **later**: end the workflow. The manuscript and images are saved and ready whenever they want to publish

---

## Agent Rules

### When to suggest this extension
- User has completed research and mentions wanting to "write it up" or "make a book/report/guide"
- User has a collection of briefings or reports and wants to synthesize them
- User asks about creating long-form content from research

### Core behaviors
- **Never write prose without an approved outline.** The outline is the contract
- **Ground all claims in sources.** Flag any assertion that lacks a citation
- **Maintain consistent voice.** If the user edits passages, match their tone in subsequent writing
- **Write first, illustrate after.** Complete the full manuscript, then generate all images informed by the actual chapter content
- **Use the default image style.** Always apply the default style prompt. Never ask the user to choose an image style - they can adjust after
- **Respect the image placement rules.** Cover after prelude hook, chapter images after headings, never two images back-to-back
- **Create the folder structure first.** Before any writing begins, set up the project directories
- **One source of truth.** `manuscript.md` is always the canonical version. If edits happen elsewhere (Notion, a web component), sync back to `manuscript.md`
- **Ask the 2 pre-writing questions.** After outline approval, always ask about reading length and reader/angle before writing

### Quality checklist (run before publishing)
- [ ] Every chapter has at least one cited data point
- [ ] No orphaned images (every image is placed in the manuscript)
- [ ] `manuscript.md` has image paths at correct positions (after chapter headings)
- [ ] Image review carousel artifact was created and user approved images
- [ ] Visual review artifact was created with absolute paths (images render inline)
- [ ] Folder structure matches the convention
- [ ] Outline was approved before writing began
- [ ] User reviewed the complete manuscript
- [ ] User approved the image set
- [ ] Source attribution is present at the end
