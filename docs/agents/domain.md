# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **The Terms table in `COMPANY.md`**, first. It holds the terms every Prevasum repo shares, and lives in the `Prevasum/docs` repo, at `../docs/COMPANY.md` when the repos sit side by side in the workspace. Read it here because a session opened in this repo alone doesn't load it. Without a local copy, fetch it with `gh api repos/Prevasum/docs/contents/COMPANY.md -H "Accept: application/vnd.github.raw"`.
- Then **`CONTEXT.md`** at the repo root for the terms only this repo uses, or
- **`CONTEXT-MAP.md`** at the repo root if it exists: it points at one `CONTEXT.md` per context. Read each one relevant to the topic.
- **`docs/adr/`**: read ADRs that touch the area you're about to work in. In multi-context repos, also check `src/<context>/docs/adr/` for context-scoped decisions.

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest creating them upfront. The `/prevasum-eng-domain-modeling` skill (reached via `/prevasum-eng-grill-with-docs`, `/prevasum-eng-improve-codebase-architecture`, and `/prevasum-eng-design-doc`) creates them lazily when terms or decisions actually get resolved.

## File structure

Single-context repo (most repos):

```
/
├── CONTEXT.md
├── docs/adr/
│   ├── 0001-event-sourced-orders.md
│   └── 0002-postgres-for-write-model.md
└── src/
```

Multi-context repo (presence of `CONTEXT-MAP.md` at the root):

```
/
├── CONTEXT-MAP.md
├── docs/adr/                          ← system-wide decisions
└── src/
    ├── ordering/
    │   ├── CONTEXT.md
    │   └── docs/adr/                  ← context-specific decisions
    └── billing/
        ├── CONTEXT.md
        └── docs/adr/
```

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a test name), use the term as defined in `COMPANY.md` or `CONTEXT.md`. Don't drift to synonyms the glossary explicitly avoids.

If the concept you need isn't in either glossary yet, that's a signal: either you're inventing language the project doesn't use (reconsider) or there's a real gap (note it for `/prevasum-eng-domain-modeling`). A missing term that another Prevasum repo uses goes in `COMPANY.md` through a `docs` PR; a term only this repo uses goes in `CONTEXT.md`.

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 (event-sourced orders), but worth reopening because…_
