# Prevasum GitHub templates

This repository holds Prevasum's organization-wide GitHub files:

- `profile/README.md`: the public organization overview.
- `pull_request_template.md`: the default PR template for every repo that doesn't have its own.
- `.github/workflows/`: the PR checks (`validate-pr-title`, `validate-closes-issue`) that the `pr-checks` organization ruleset runs on every repo, and `deliver.yml`, the reusable workflow a service repo calls on each merge to `main` to build its image once and deploy it to dev.
