# Prevasum GitHub templates

This repository holds Prevasum's organization-wide GitHub files:

- `profile/README.md`: the public organization overview.
- `pull_request_template.md`: the default PR template for every repo that doesn't have its own.
- `.github/workflows/`: the PR checks (`validate-pr-title`, `validate-closes-issue`) that the `pr-checks` organization ruleset runs on every repo, and `deliver.yml`, the reusable workflow a service repo calls on each merge to `main` to build its image once and deploy it to dev.
- `.github/workflows/actionlint.yml`: the reusable workflow a repo calls to lint its own workflows with a pinned `actionlint`. `hooks/actionlint-pre-commit.sh` is the matching block for a repo's `.githooks/pre-commit`. Both are on `main`, so callers use `@main`.
- `.githooks/pre-commit`: this repo's hook; enable it with `git config core.hooksPath .githooks`.
