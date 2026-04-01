---
name: web-blog
description: "Turn manuscripts into beautiful one-page blog articles with Vite, React, and Tailwind. Auto-creates a blog index when multiple articles exist."
---

# Web Blog

> **Manuscript to published blog article in one flow.** The agent builds a scroll-style one-pager from any manuscript, with dynamic content rendering based on available media.

This extension takes a manuscript (from the minibook-pipeline, research reports, or any structured markdown) and generates a deployed blog article using Vite + React + Tailwind. The page follows the editorial scroll pattern: hero section, chapter sections with scroll animations, data callouts with citations, and responsive dark mode.

---

## Prerequisites

- A manuscript file (typically `manuscript.md` from the minibook-pipeline)
- Optional: chapter images, video files, audio files

---

## Workflow

### Step 1 - Detect or Scaffold Project

**If an existing Vite+React project exists:**
- Use the existing project structure
- Add the blog page as a new route

**If no project exists:**
```bash
# turbo
bunx --bun create-vite@latest ./ -- --template react-ts
# turbo
bun install
# turbo
bun add framer-motion react-router-dom
# turbo
bun add -D tailwindcss @tailwindcss/vite
```

Set up Tailwind by adding the Vite plugin and importing Tailwind in the main CSS file. Use the `brand-identity` skill design tokens for the color palette and typography.

### Step 2 - Parse Manuscript

Read the manuscript and extract:

| Element | Detection | Component |
|---|---|---|
| `# Title` | First H1 | Hero title |
| `### Subtitle` | First H3 before any chapter | Hero subtitle |
| `*Tagline*` | First italic line before any chapter | Hero tagline |
| `## Chapter N: Title` | H2 headings | Chapter sections |
| `> **Bold text**` + `> *Source:*` | Blockquote pairs | DataCallout with citation |
| `![alt](path)` | Image references | ChapterImage (if file exists) |
| Tables | Markdown tables | Styled HTML tables |
| Body paragraphs | Everything else | FadeIn-wrapped paragraphs |

**Dynamic content detection** - only include components for media that actually exists:

```
Manuscript has images?     → Import and render ChapterImage components
Project has video files?   → Import and render VideoPlayer components
Project has audio files?   → Import and render AudioPlayer components
Manuscript has blockquotes → Render DataCallout with citations
Manuscript has tables?     → Render styled tables
Always:                    → FadeIn animations, hero, chapters, dividers
```

### Step 3 - Generate Components

Create a self-contained page component with these sub-components. Only include the components that are needed based on Step 2 detection:

#### Always included:

**FadeIn** - Scroll animation wrapper using framer-motion:
```tsx
function FadeIn({ children, delay = 0 }) {
    const ref = useRef(null);
    const isInView = useInView(ref, { once: true, margin: '-60px' });
    return (
        <motion.div ref={ref}
            initial={{ opacity: 0, y: 20 }}
            animate={isInView ? { opacity: 1, y: 0 } : { opacity: 0, y: 20 }}
            transition={{ duration: 0.6, delay, ease: 'easeOut' }}
        >{children}</motion.div>
    );
}
```

**DataCallout** - Styled blockquote with citation source:
```tsx
function DataCallout({ children, source }) {
    return (
        <blockquote className="blog-callout">
            <div className="blog-callout__content">{children}</div>
            <cite className="blog-callout__source">{source}</cite>
        </blockquote>
    );
}
```

**Divider** - Section separator between chapters:
```tsx
function Divider() {
    return <hr className="blog-divider" />;
}
```

#### Conditionally included (only if media exists):

**ChapterImage** - Lazy-loaded image with fade-in (only if images exist)

**VideoPlayer** - Embedded video with caption (only if video files exist)

**AudioPlayer** - Audio card with title and description (only if audio files exist)

### Step 4 - Generate Blog CSS

Create a blog-specific CSS file that integrates with the project's design tokens. Use Tailwind utilities for layout and custom classes for editorial styling:

**Required classes:**
- `.blog-page` - article container (max-width, centered, padding)
- `.blog-hero` - hero section (large title, centered)
- `.blog-hero__title` - main title styling
- `.blog-hero__subtitle` - subtitle styling
- `.blog-hero__tagline` - italic tagline
- `.blog-chapter` - chapter section container
- `.blog-chapter__title` - chapter heading (H2)
- `.blog-callout` - blockquote with left border accent
- `.blog-callout__source` - italic citation below callout
- `.blog-divider` - styled horizontal rule between sections
- `.blog-image` - chapter image container
- `.blog-table-wrapper` - responsive table container

**Design system integration:**
- Import color tokens from `brand-identity` (or Tailwind config)
- Dark mode support via `@media (prefers-color-scheme: dark)` or class-based toggle
- Responsive typography (clamp-based fluid sizes)
- Generous whitespace for editorial readability

### Step 5 - Register Route

**Single article (first blog post):**
- Create the page at `src/pages/<article-slug>.tsx`
- Add a route in the router: `/<article-slug>`
- No index page needed yet

**Multiple articles (2+ posts):**
- Create `src/pages/blog.tsx` - the blog index page
- Each article at `src/pages/blog/<article-slug>.tsx`
- Routes: `/blog` (index) and `/blog/<article-slug>` (individual articles)

### Step 6 - Blog Index (auto-created at 2+ articles)

When the second article is added, automatically create a blog index page at `/blog`:

- Card grid layout showing all articles
- Each card shows: cover image (if exists), title, subtitle, and a short excerpt
- Clicking a card navigates to the individual article page
- Responsive grid (1 column mobile, 2-3 columns desktop)
- Same dark mode support as article pages
- When the index is created, update routing so the first article also moves under `/blog/<slug>`

### Step 7 - Offer Next Steps

After the blog page is generated:

> "Your blog article is live at `/<article-slug>`. Here's what you can do next:
>
> 1. **Add another article** - I'll create it the same way and auto-generate a blog index
> 2. **Deploy to Cloudflare Pages** - put it online (uses the `cloudflare-mcp` extension)
> 3. **Customize the design** - adjust colors, typography, or layout
>
> Or just keep building - the article is ready whenever you want to publish."

---

## Image Placement Rules

Follow the same rules as the `notion-publishing` extension:

1. Title, subtitle, tagline, and prelude text come before any image
2. Cover image after the prelude hook paragraphs
3. Chapter images immediately after chapter headings
4. Never two images back-to-back
5. No images within 2 blocks of a data callout
6. Tables stand alone (no adjacent images)

---

## Agent Rules

### Core behaviors
- **Dynamic rendering only.** Never include video/audio players if no media files exist. Only render components for content that is actually present
- **Brand-identity integration.** Use the project's design tokens from the `brand-identity` skill. Fall back to sensible defaults if no design system exists
- **One source of truth.** The `manuscript.md` remains canonical. The blog page is a rendered view
- **Progressive enhancement.** Single articles work standalone. Blog index appears automatically when needed
- **Mobile-first.** All components must be responsive. Test at 320px, 768px, and 1200px widths

### When to suggest this extension
- After the minibook-pipeline produces a manuscript
- When the user asks to "put this on a website" or "make a blog post"
- When research reports need a public-facing presentation
- When the user says "build a web page" from any structured content
