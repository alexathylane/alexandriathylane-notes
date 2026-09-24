# alexandriathylane-notes

Quartz 4 digital garden. Content comes from the Obsidian vault at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes-vault`, which is its own git repo pushed to GitHub. This repo holds only the Quartz config, theme, and deploy script. `public/` is generated output and is gitignored.

## Deploying — read this before running anything

**Iterate with the local preview. Never use production deploys as a feedback loop.**

```
./deploy.sh            # builds from the vault, serves at localhost:8080 with hot reload
./deploy.sh --prod     # builds and deploys to production
```

Vercel retains every production deploy permanently. Each is roughly 100 MB, and the Hobby plan's 10 GB Deployment Storage limit is shared across the whole account — so the free tier holds about 100 production deploys, lifetime. Deployment Retention policies are not available on Hobby, so nothing expires them automatically; the only way to reclaim space is to delete them by hand.

This has already gone wrong once: 88 production deploys between Aug 19–25 2026, 42 of them on a single day, consumed 9.15 GB and took the account to 97% of its limit. Eighty-three of those 88 deployed the same git commit.

**At most one production deploy per working session**, after the change looks right in local preview.

To reclaim space (`--safe` skips anything with a live alias, so the site stays up):

```
vercel rm alexandriathylane-notes --safe
```

## Build weight

Each deploy's size is the size of `public/`, currently ~100 MB across ~600 files. The heaviest items are a 9.4 MB PDF and several 7–8 MB PNGs under `Philosophy/assets` and `Essays-by-Alexandria-Thylane`. Converting large PNGs to webp cuts per-deploy cost proportionally — worth doing before adding more large assets.
