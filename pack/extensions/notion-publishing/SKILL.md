---
name: notion-publishing
description: "Publish manuscripts, reports, or any structured content to Notion with proper formatting, image placement, and block mapping."
---

# Notion Publishing

> **Any manuscript or report to a formatted Notion page.** The agent handles block mapping, image placement, and publishing. You pick the target workspace.

This extension takes any structured markdown content (minibooks, research reports, briefings) and publishes it as a beautifully formatted Notion page with images, headings, callouts, and proper layout.

> **First-time setup:** See [SETUP.md](./SETUP.md) in this folder for Notion MCP connection via OAuth.

---

## Prerequisites

1. Notion MCP must be connected and authenticated (run SETUP.md if not)
2. A target workspace or parent page must be identified

**Quick health check:** Before publishing, verify the connection by listing pages. If it fails, re-run the OAuth flow from SETUP.md Step 2.

---

## Image Placement Rules

These rules ensure readable, visually balanced layout:

1. **Title > Subtitle > Tagline > Prelude text first.** The hook paragraphs appear before any image. Pull readers in with words before visuals
2. **Cover image after the prelude hook.** Place the cover image after the first 2-3 prelude paragraphs, before the rest of the prelude content
3. **Chapter images after the chapter heading.** Place chapter images immediately after the `## Chapter N: Title` heading, before the first body paragraph
4. **Never two images back-to-back.** There must be at least one paragraph of text between any two images
5. **Data callouts are text-only zones.** No images within 2 blocks of a blockquote citation
6. **Tables stand alone.** No image directly above or below a table

## Notion Block Mapping

Map Markdown elements to Notion blocks:

| Markdown | Notion Block |
|---|---|
| `# Title` | Page title |
| `### Subtitle` | Heading 3 |
| `*Tagline*` | Italic paragraph |
| `---` | Divider |
| `## Chapter N: Title` | Heading 2 |
| `> **Bold text**` | Callout block (or quote block) |
| `> *Source:...*` | Quote block (italic) |
| Body paragraphs | Paragraph blocks |
| Tables | Table blocks |
| Images | Image blocks (embedded via URL) |

## Publishing Steps

1. **Identify source material** - Ask the user which manuscript or report to publish. Look for the source file (e.g., `manuscript.md`, a research report, or any structured markdown)
2. **Identify target** - Ask the user where to publish in Notion (which workspace, which parent page). List available pages to help them choose
3. **Create the Notion page** under the target parent page
4. **Add the title** as the page title
5. **Walk through the content** section by section:
   - Convert each Markdown element to the appropriate Notion block
   - Preserve heading hierarchy
   - Apply image handling strategy (see below)
6. **Add source attribution** at the bottom as a toggleable section
7. **Share the link** - Provide the user with the Notion page URL

## Image Handling

Images work via **external URLs**. The image must be publicly accessible (e.g., hosted on R2, Unsplash, GitHub raw, or any public URL). Local file paths are not supported.

**Strategy:**

1. **External URL** - If images are already at a public URL, embed them directly as image blocks with captions
2. **Upload first** - If images are local files, upload them to a public URL first (e.g., via Cloudflare R2 using the `cloudflare-mcp` extension), then embed the URL
3. **Never silently drop images** - Always inform the user which images were placed and which need uploading

> [!NOTE]
> Tested and confirmed: both OAuth and API key approaches support image blocks via external URLs. The OAuth approach is recommended as it requires no key management.

---

## Agent Rules

### Core behaviors
- **Never publish without user approval.** Always confirm the target page and content before creating
- **Preserve structure.** The Notion page should mirror the manuscript's heading hierarchy exactly
- **Handle images gracefully.** If an image fails to upload, note it and continue with the rest - don't abort the entire publish
- **One source of truth.** The original markdown file remains the canonical version. The Notion page is a published copy
- **Idempotent publishing.** If the user asks to re-publish, update the existing page rather than creating a duplicate

### When content has no images
- Skip all image placement rules
- Still apply the block mapping for text, headings, callouts, and tables
- The flow works the same - just without the image insertion steps
