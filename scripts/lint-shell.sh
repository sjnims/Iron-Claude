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

# Find all shell scripts
shell_scripts=$(find . -name "*.sh" \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*")

if [ -z "$shell_scripts" ]; then
  echo "⚠️  No shell scripts found"
  exit 0
fi

# Track failures
failed=0
total=0

# Check each script
while IFS= read -r script; do
  total=$((total + 1))
  echo "Checking $script"
  if ! shellcheck "$script"; then
    # ShellCheck already printed detailed error output
    failed=$((failed + 1))
  else
    echo "✅ Valid: $script"
  fi
done <<< "$shell_scripts"

# Report results
echo ""
echo "📊 Results: $((total - failed))/$total scripts passed"

if [ $failed -gt 0 ]; then
  echo "❌ $failed script(s) failed ShellCheck"
  exit 1
fi

echo "✅ All scripts passed"
