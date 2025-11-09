#!/bin/bash
# Load current milestone context for the session

MILESTONE_FILE=".iron-claude/milestone.json"

if [ -f "$MILESTONE_FILE" ]; then
  # Read milestone data
  MILESTONE_NAME=$(jq -r '.name // "Unnamed Milestone"' "$MILESTONE_FILE")
  MILESTONE_DESC=$(jq -r '.description // ""' "$MILESTONE_FILE")
  MILESTONE_CREATED=$(jq -r '.created_at // ""' "$MILESTONE_FILE")

  # Export for use in other hooks
  export MILESTONE="$MILESTONE_NAME"
  export MILESTONE_DESCRIPTION="$MILESTONE_DESC"

  # Print to session
  echo "📍 Current Milestone: $MILESTONE_NAME"
  if [ -n "$MILESTONE_DESC" ]; then
    echo "   Description: $MILESTONE_DESC"
  fi
  echo "   Started: $MILESTONE_CREATED"
  echo ""
  echo "🎯 Remember: TDD workflow (Red → Green → Refactor)"
  echo "✅ Four personas will review at completion"
else
  echo "ℹ️  No active milestone. Use /milestone-planning to set one up."
  export MILESTONE="No milestone set"
fi

exit 0
