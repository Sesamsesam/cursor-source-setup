---
name: brand-identity
description: "Design tokens and CSS architecture for the Liftoff visual identity. Ensures every project looks premium from line one."
---

# Brand Identity

> **🤖 You don't need to do any of this manually.** The agent handles setup and usage automatically. If it ever needs you to do something, it will tell you exactly what and when.

<!-- ═══════════════════════════════════════════════════ -->
<!-- USER OVERVIEW                                      -->
<!-- ═══════════════════════════════════════════════════ -->

## What Is This?
A ready-to-use design system with CSS custom properties, utility classes, and theming rules. CSS is the visual design code that makes your build look good. Drop this into any project and immediately get a premium, cohesive visual identity without having to describe it everytime, it's like a design template.

## Why Does It Exist?
Without a design system, every project starts with random colors and inconsistent spacing. This gives the agent a concrete library so every UI looks intentional and polished.

## What It Does For You
The agent references these tokens when generating CSS. Every color, shadow, and gradient uses a centralized variable. Change one token - the entire app updates.

---

## Activation
- New projects with UI components
- Generating CSS/styling code
- "Make it look better" or "improve the design"

## How It Works

A **design token** is a named variable for a visual value - a color, a shadow, a spacing size. Instead of writing `color: #3B82F6` in 50 places, define once as `--ag-blue: #3B82F6` and reference everywhere. Want to try a different look? Change the token, every component using it updates automatically.

The tokens are organized into categories:
- **Gradients** - the signature blue-to-cyan sweep
- **Accent colors** - supporting purples, pinks, and blues for highlights
- **Surfaces** - backgrounds with subtle transparency
- **Shadows** - the "Blueprint Lift" effect that makes cards float
- **Typography** - font families, weights, letter-spacing
- **Spacing & Radius** - consistent padding/margins and corners

**Light vs Dark mode:** Same token names in both modes. `:root` = light defaults, `.dark` = overrides.

<!-- ═══════════════════════════════════════════════════ -->
<!-- TOKENS & CLASSES                                   -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Core Design Tokens

```css
:root {
  /* ─── Primary Gradient (Ocean Blue) ─── */
  --gradient-start: #3B82F6;
  --gradient-end: #06B6D4;
  --gradient-accent: linear-gradient(135deg, var(--gradient-start), var(--gradient-end));
  --gradient-accent-vertical: linear-gradient(180deg, var(--gradient-start), var(--gradient-end));

  /* ─── Accent Colors ─── */
  --ag-purple: #8B5CF6;
  --ag-blue: #3B82F6;
  --ag-pink: #EC4899;
  --color-accent-subtle: rgba(59, 130, 246, 0.08);

  /* ─── Mastery Gold (Light Mode) ─── */
  --mastery-gradient: linear-gradient(135deg, #D4AF37, #F5D67B, #C9A227);

  /* ─── Surfaces ─── */
  --surface-1: rgba(255, 255, 255, 0.95);
  --surface-elevated: #ffffff;
  --border-1: rgba(0, 0, 0, 0.08);

  /* ─── Shadows (Blueprint Lift) ─── */
  --shadow-card: 0 10px 40px rgba(0, 0, 0, 0.12), 0 4px 12px rgba(0, 0, 0, 0.08);
  --shadow-card-hover: 0 20px 50px rgba(0, 0, 0, 0.15), 0 8px 20px rgba(0, 0, 0, 0.10);

  /* ─── Typography ─── */
  --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", sans-serif;
  --font-heading-weight: 600;
  --font-heading-tracking: -0.02em;

  /* ─── Spacing Scale ─── */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 16px;
  --space-lg: 24px;
  --space-xl: 32px;
  --space-2xl: 48px;
  --space-3xl: 64px;

  /* ─── Border Radius ─── */
  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-pill: 9999px;
}

/* ─── Dark Mode Overrides ─── */
.dark {
  --surface-1: rgba(15, 23, 42, 0.8);
  --surface-elevated: #1e293b;
  --border-1: rgba(255, 255, 255, 0.1);
  --color-accent-subtle: #2a2a2a;

  /* Aurora Glow - replaces Blueprint Lift shadows */
  --shadow-card: 0 0 20px rgba(255, 255, 255, 0.12), 0 0 8px rgba(255, 255, 255, 0.08);
  --shadow-card-hover: 0 0 30px rgba(255, 255, 255, 0.18), 0 0 12px rgba(255, 255, 255, 0.10);

  /* Contrast Pivot - Gold → Teal for legibility */
  --mastery-gradient: linear-gradient(135deg, #22D3EE, #2DD4BF, #5EEAD4);
}
```

## Utility Classes

```css
/* ─── Surfaces ─── */
.surface-card {
  background: var(--surface-1);
  border: 1px solid var(--border-1);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-card);
}

.surface-elevated {
  background: var(--surface-elevated);
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow-card);
}

/* ─── Gradients ─── */
.gradient-bg { background: var(--gradient-accent); }
.gradient-bg-vertical { background: var(--gradient-accent-vertical); }
.gradient-text {
  background: var(--gradient-accent);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
.gradient-text-gold {
  background: var(--mastery-gradient);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* ─── Glass Card ─── */
.glass-card {
  background: var(--surface-1);
  backdrop-filter: blur(10px);
  border: 1px solid var(--border-1);
  border-radius: var(--radius-lg);
  transition: all 0.3s ease;
}
```

<!-- ═══════════════════════════════════════════════════ -->
<!-- RULES & GUARDRAILS                                 -->
<!-- ═══════════════════════════════════════════════════ -->

---

## Theme Transition Rule

> [!CAUTION]
> **Never** use `* { transition: ... }` for theme switching. It hijacks `transform` transitions on every component, breaking hover animations.

```css
/* ✅ Correct - targeted transitions */
body, .surface-card, .surface-elevated, .glass-card {
  transition: background-color 0.15s ease, border-color 0.15s ease, box-shadow 0.15s ease;
}

/* ❌ Wrong - universal selector kills component animations */
* { transition: background-color 0.15s ease; }
```

## Typography Standards

- **Headings:** `var(--font-sans)`, weight `var(--font-heading-weight)`, tracking `var(--font-heading-tracking)`
- **Subtitles:** 60% opacity, weight 400
- **Body:** 16px base, 1.6 line-height
- **No em dashes** - use hyphens or rewrite

## Hover Standard

```css
.interactive-element {
  transition: transform 0.05s ease;
}
.interactive-element:hover {
  transform: translateY(-1px);
  box-shadow: var(--shadow-card-hover);
}
```

## Design Guardrails

### Anti-Patterns (Never)
- No tap targets under `44x44px` on mobile
- No more than 3 primary colors per view
- No more than 2 font families per page
- No hamburger menus on desktop
- No hover-dependent interactions on touch devices
- No `#000000` on `#FFFFFF` - use `#1E293B` on `#F8FAFC`
- No color-only information (add icons or labels)

### Accessibility (Always)

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

- WCAG AA: `4.5:1` contrast for body text, `3:1` for large text
- Visible focus indicators on all interactive elements
- All images must have `alt` text
- Use `rem` for font sizes, not `px`
