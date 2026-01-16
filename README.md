# Alexandria's Notes

Quartz-powered digital garden publishing an Obsidian vault as a searchable, interconnected website.

**Live:** https://notes.alexandriathylane.com

## Tech Stack

- **Generator:** Quartz 4.5 (static site generator for Obsidian)
- **Content Source:** External Obsidian vault (iCloud-synced)
- **Hosting:** Vercel (static files)
- **Features:** Full-text search, graph visualization, backlinks, dark mode

---

## Quick Start

All commands run from **this repository** (`alexandriathylane-notes/`), not the Obsidian vault.

```bash
# From: ~/Code/alexandriathylane-notes/

# Install dependencies
npm install

# Build from Obsidian vault
npx quartz build --directory "/path/to/your/vault"

# Build and serve locally (with hot reload)
npx quartz build --directory "/path/to/your/vault" --serve

# Deploy to production
./deploy.sh
```

---

## Key Concept: External Vault

**The Obsidian vault lives OUTSIDE this repository.**

```
This Repo                          External (iCloud)
────────────                       ─────────────────
alexandriathylane-notes/           notes-vault/
├── quartz/                        ├── Philosophy/
├── quartz.config.ts               ├── Gender/
├── public/ (output)               ├── AI/
└── deploy.sh                      └── index.md
         │                                │
         └────── reads at build time ─────┘
```

- **Vault location:** `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes-vault/`
- **How it works:** Quartz reads the vault via `--directory` flag at build time — no copying or syncing
- **Workflow:** Edit notes in Obsidian → run `./deploy.sh` from this repo → site updates

> **Important:** You never need to `cd` into the vault. All build/deploy commands run from this repository.

---

## Project Structure

```
alexandriathylane-notes/
├── quartz/                     # Quartz framework (don't modify)
│   ├── components/             # UI components (search, graph, etc.)
│   ├── plugins/                # Content transformers & emitters
│   └── styles/                 # Base SCSS styles
├── quartz.config.ts            # Site configuration
├── quartz.layout.ts            # Page layout definition
├── content/                    # Local content (unused — using external vault)
├── public/                     # Built output (deployed to Vercel)
│   ├── index.html
│   ├── Philosophy/
│   ├── Gender/
│   └── ...
├── deploy.sh                   # Build + deploy script
├── vercel.json                 # Vercel configuration
├── .vercelignore               # Files excluded from deploy
└── package.json
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Content Workflow                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   ┌──────────────┐                                                   │
│   │   Obsidian   │  ◄── Edit notes locally                          │
│   │   (iCloud)   │      Syncs across devices                        │
│   └──────┬───────┘                                                   │
│          │                                                           │
│          │  npx quartz build --directory "vault-path"                │
│          ▼                                                           │
│   ┌──────────────┐                                                   │
│   │    Quartz    │  ◄── Parses Markdown                             │
│   │   Build      │      Applies plugins (syntax, links, math)       │
│   │   Process    │      Generates HTML + search index               │
│   └──────┬───────┘                                                   │
│          │                                                           │
│          ▼                                                           │
│   ┌──────────────┐    ┌──────────────┐                              │
│   │   /public    │───►│   Vercel     │                              │
│   │  (static)    │    │   Hosting    │                              │
│   └──────────────┘    └──────┬───────┘                              │
│                              │                                       │
│                              ▼                                       │
│                   notes.alexandriathylane.com                        │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Configuration

### quartz.config.ts

```typescript
configuration: {
  pageTitle: "Alexandria's Notes",
  baseUrl: "notes.alexandriathylane.com",

  // Content to exclude from build
  ignorePatterns: [
    "_Unpublished",           // Private drafts
    "Alexandria Thylane Rohn.md",  // Old bio
    ".obsidian",              // Obsidian config
    ".git",
    "private",
    "templates"
  ],

  // Theme colors (matches main site)
  colors: {
    darkMode: {
      secondary: "#9b6dff",   // Purple accent
      tertiary: "#6ba3ff",    // Blue accent
    },
    lightMode: {
      secondary: "#7b4ddf",
      tertiary: "#4b83df",
    }
  }
}
```

### Enabled Plugins

| Plugin | Purpose |
|--------|---------|
| `ObsidianFlavoredMarkdown` | Wiki-links, callouts, embeds |
| `SyntaxHighlighting` | Code blocks with GitHub themes |
| `TableOfContents` | Auto-generated TOC |
| `CrawlLinks` | Builds link graph |
| `Latex` | Math rendering via KaTeX |
| `ContentIndex` | Search index, sitemap, RSS |

---

## Deployment

All deployment commands run from **this repository** (`alexandriathylane-notes/`).

### Using deploy.sh (Recommended)

```bash
# From: ~/Code/alexandriathylane-notes/
./deploy.sh
```

This script:
1. Builds from the vault using `npx quartz build --directory "..."`
2. Deploys `/public` to Vercel

### Manual Deployment

```bash
# From: ~/Code/alexandriathylane-notes/

# Build
npx quartz build --directory "/Users/alexandriarohn/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes-vault"

# Deploy (from the public subfolder)
cd public && vercel --prod --yes
```

### Vercel Configuration

`vercel.json`:
```json
{
  "cleanUrls": true,      // /page instead of /page.html
  "trailingSlash": false
}
```

---

## Development

### Local Preview

```bash
# From: ~/Code/alexandriathylane-notes/
npx quartz build --directory "/path/to/vault" --serve --port 8080
```

Opens at http://localhost:8080 with hot reload.

### Adding Content

1. Create/edit `.md` files in your **Obsidian vault** (in Obsidian app or any editor)
2. Run `./deploy.sh` from **this repo** to publish

### Excluding Content

Add patterns to `ignorePatterns` in `quartz.config.ts`:
```typescript
ignorePatterns: [
  "_Unpublished",
  "private/**",
  "drafts/**"
]
```

### Customizing Theme

Edit `colors` in `quartz.config.ts`. The current theme matches the main site (alexandriathylane.com).

---

## Features

| Feature | Description |
|---------|-------------|
| **Full-text search** | Searches all note content |
| **Graph view** | Visual map of note connections |
| **Backlinks** | Shows what links to current note |
| **Dark/Light mode** | Toggle with moon/sun icon |
| **Table of Contents** | Auto-generated from headings |
| **Tags** | Click tags to see related notes |
| **Breadcrumbs** | Navigation trail at top |

---

## Vault Structure

The published vault contains notes organized by topic:

```
notes-vault/
├── index.md                    # Homepage
├── Philosophy/
├── Gender/
├── Artificial Intelligence & LLMs/
├── Cognitive Science/
├── Feminism/
├── LGBTQ+/
├── Software Engineering/
├── Essays by Alexandria Thylane/
├── _Unpublished/              # (excluded from build)
└── ...
```

---

## Related Projects

- **Main Website:** https://github.com/alexathylane/alexandriathylane.com
- **Live Site:** https://alexandriathylane.com
