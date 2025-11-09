#!/bin/bash
# scripts/lint-shell.sh
# Lint all shell scripts in the project using ShellCheck

set -e

echo "🔍 Linting shell scripts..."

# Check if ShellCheck is installed
if ! command -v shellcheck &> /dev/null; then
  echo "❌ ShellCheck not found"
  echo ""
  echo "Install ShellCheck:"
  echo "  macOS:   brew install shellcheck"
  echo "  Ubuntu:  sudo apt-get install shellcheck"
  echo "  Fedora:  sudo dnf install shellcheck"
  echo ""
  exit 1
fi

# Track failures
failed=0
total=0

# Find and check all shell scripts
# Using -print0 and read -d '' to handle filenames with spaces/special characters
while IFS= read -r -d '' script; do
  total=$((total + 1))
  echo "Checking $script"
  if ! shellcheck "$script"; then
    # ShellCheck already printed detailed error output
    failed=$((failed + 1))
  else
    echo "✅ Valid: $script"
  fi
done < <(find . -name "*.sh" \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -print0)

# Check if no scripts were found
if [ $total -eq 0 ]; then
  echo "⚠️  No shell scripts found"
  exit 0
fi

# Report results
echo ""
echo "📊 Results: $((total - failed))/$total scripts passed"

if [ $failed -gt 0 ]; then
  echo "❌ $failed script(s) failed ShellCheck"
  exit 1
fi

echo "✅ All scripts passed"
