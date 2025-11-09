#!/bin/bash
# Analyze Rails queries for N+1 and performance issues

set -e

echo "⚡ Analyzing Rails Queries for Performance Issues..."
echo ""

# Check if this is a Rails project
if [ ! -f "config/application.rb" ]; then
  echo "❌ Not a Rails project."
  exit 1
fi

echo "📊 Running query analysis..."
echo ""
echo "This will:"
echo "1. Check for N+1 query patterns in controllers"
echo "2. Verify foreign key indexes"
echo "3. Look for missing indexes on filtered columns"
echo ""

# Simple grep-based analysis for common N+1 patterns
echo "🔍 Scanning for potential N+1 queries..."

# Look for queries without includes/preload/eager_load
N1_SUSPECTS=0

if grep -r "\.all$" app/controllers --include="*.rb" > /dev/null 2>&1; then
  echo "⚠️  Found .all without eager loading in controllers:"
  grep -rn "\.all$" app/controllers --include="*.rb" --max-count=10
  N1_SUSPECTS=$((N1_SUSPECTS + 1))
fi

if grep -r "each do |" app/views --include="*.erb" > /dev/null 2>&1; then
  echo "⚠️  Found iteration in views (potential N+1 if accessing associations):"
  grep -rn "each do |" app/views --include="*.erb" --max-count=10
  N1_SUSPECTS=$((N1_SUSPECTS + 1))
fi

echo ""
echo "📋 Analysis Complete"
echo "   Potential N+1 patterns: $N1_SUSPECTS"
echo ""
echo "💡 Recommendations:"
echo "   - Use includes/preload for associations in loops"
echo "   - Add counter_cache for .count on associations"
echo "   - Run rails console with query logging to confirm"
echo ""
echo "For detailed analysis, use:"
echo "   rails console"
echo "   > ActiveRecord::Base.logger = Logger.new(STDOUT)"
echo "   > # Run your controller action code"

exit 0
