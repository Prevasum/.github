# Copy this block into a repo's `.githooks/pre-commit`, after the
# Markdown-only exit, so a commit that would fail CI's actionlint job fails
# here first. It lints only when a workflow file is staged.
#
# The hook fails when actionlint isn't installed, like the other checks do
# when their tool is missing: a skipped check would let the commit fail CI
# instead. Keep the version in line with `ACTIONLINT_VERSION` in
# `.github/workflows/actionlint.yml` in Prevasum/.github.

if ! git diff --cached --quiet -- .github/workflows; then
  echo "==> actionlint"
  if ! command -v actionlint >/dev/null; then
    echo "Error: actionlint is not installed. Install release 1.7.12 or newer:"
    echo "  macOS:  brew install actionlint"
    echo "  Linux:  https://github.com/rhysd/actionlint/blob/main/docs/install.md"
    echo "Commit aborted."
    exit 1
  fi
  actionlint || {
    echo "Error: actionlint failed. Commit aborted."
    exit 1
  }
fi
