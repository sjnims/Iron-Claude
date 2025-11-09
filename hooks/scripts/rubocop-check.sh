#!/bin/bash
# Auto-format Ruby code with RuboCop

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

# Check if RuboCop is available
if ! command -v rubocop &> /dev/null; then
  echo "⚠️  RuboCop not found. Skipping auto-format."
  echo "   Install with: gem install rubocop"
  exit 0
fi

# Check if this is a Rails project with RuboCop config
if [ ! -f ".rubocop.yml" ]; then
  echo "ℹ️  No .rubocop.yml found. Skipping auto-format."
  exit 0
fi

# Run RuboCop with auto-correct
echo "🔧 Auto-formatting with RuboCop..."

# Check result
if rubocop --auto-correct "$FILE_PATH"; then
  echo "✅ RuboCop: No issues found"
else
  echo "⚠️  RuboCop found issues that couldn't be auto-corrected"
  echo "   Run manually: rubocop $FILE_PATH"
fi

exit 0  # Don't block even if there are issues
