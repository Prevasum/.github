# Copy this block into a repo's `.githooks/pre-commit`, after the
# Markdown-only exit. Keep its version in line with `ACTIONLINT_VERSION` in
# Prevasum/.github's `.github/workflows/actionlint.yml`.

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
