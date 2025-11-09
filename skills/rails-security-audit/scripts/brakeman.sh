#!/bin/bash
# Automated Brakeman security scan for Rails applications

set -e

echo "🔍 Running Brakeman Security Scan..."
echo ""

# Check if Brakeman is installed
if ! command -v brakeman &> /dev/null; then
  echo "⚠️  Brakeman not installed."
  echo "   Install with: gem install brakeman"
  echo ""
  echo "   Or add to Gemfile:"
  echo "   gem 'brakeman', group: :development"
  exit 1
fi

# Check if this is a Rails project
if [ ! -f "config/application.rb" ]; then
  echo "❌ Not a Rails project. Brakeman requires Rails."
  exit 1
fi

# Run Brakeman with JSON output for parsing
echo "Scanning for security vulnerabilities..."
echo ""

# Run Brakeman, save to temp file
TEMP_FILE=$(mktemp) || { echo "Failed to create temp file"; exit 1; }

# Temporarily allow errors (brakeman returns non-zero when vulnerabilities found)
set +e
if ! brakeman --format json --output "$TEMP_FILE" --quiet --no-pager; then
  # Brakeman failed - check if we got any output
  if [ ! -s "$TEMP_FILE" ]; then
    echo "❌ Brakeman scan failed"
    rm -f "$TEMP_FILE"
    exit 1
  fi
fi
set -e

# Parse results
if command -v jq &> /dev/null; then
  # Use jq if available for pretty output
  WARNINGS=$(jq -r '.warnings | length' "$TEMP_FILE" 2>/dev/null || echo "0")
  ERRORS=$(jq -r '.errors | length' "$TEMP_FILE" 2>/dev/null || echo "0")

  echo "📊 Scan Results:"
  echo "   Warnings: $WARNINGS"
  echo "   Errors: $ERRORS"
  echo ""

  if [ "$WARNINGS" -gt 0 ]; then
    echo "⚠️  Security warnings found:"
    echo ""
    jq -r '.warnings[] | "[\(.confidence)] \(.warning_type): \(.message)\n   File: \(.file):\(.line)\n"' "$TEMP_FILE"
  fi

  if [ "$ERRORS" -gt 0 ]; then
    echo "❌ Scan errors:"
    echo ""
    jq -r '.errors[]' "$TEMP_FILE"
  fi

  if [ "$WARNINGS" -eq 0 ] && [ "$ERRORS" -eq 0 ]; then
    echo "✅ No security warnings found!"
  fi
else
  # Fallback: show raw JSON
  echo "📄 Raw Results (install jq for pretty output):"
  cat "$TEMP_FILE"
fi

# Save full report
REPORT_FILE="tmp/brakeman-report.json"
mkdir -p tmp
cp "$TEMP_FILE" "$REPORT_FILE"
echo ""
echo "📋 Full report saved to: $REPORT_FILE"

# Cleanup
rm -f "$TEMP_FILE"

# Exit with error if warnings found
WARNINGS=$(jq -r '.warnings | length' "$REPORT_FILE" 2>/dev/null || echo "0")
if [ "$WARNINGS" -gt 0 ]; then
  exit 1
fi

exit 0
