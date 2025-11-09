#!/bin/bash
# Auto-lint shell scripts with ShellCheck

# Add validation
FILE_PATH="${1:-}"

if [ -z "$FILE_PATH" ]; then
  echo "Error: No file path provided" >&2
  exit 1
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "File not found: $FILE_PATH"
  exit 0  # Don't fail the hook
fi

# Check if ShellCheck is available
if ! command -v shellcheck &> /dev/null; then
  echo "⚠️  ShellCheck not found. Skipping linting."
  echo "   Install with: brew install shellcheck (macOS) or apt-get install shellcheck (Linux)"
  exit 0
fi

# Check if this is a shell script
if [[ ! "$FILE_PATH" =~ \.sh$ ]]; then
  echo "ℹ️  Not a shell script. Skipping."
  exit 0
fi

# Run ShellCheck
echo "🔍 Linting with ShellCheck..."

# Check result
if shellcheck "$FILE_PATH"; then
  echo "✅ ShellCheck: No issues found"
else
  echo "⚠️  ShellCheck found issues in $FILE_PATH"
  echo "   Fix issues before committing"
fi

exit 0  # Don't block even if there are issues
