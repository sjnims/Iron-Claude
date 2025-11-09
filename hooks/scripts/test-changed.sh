#!/bin/bash
# Run tests for changed test files

TEST_FILE="$1"

# Check if file exists
if [ ! -f "$TEST_FILE" ]; then
  echo "Test file not found: $TEST_FILE"
  exit 0
fi

# Check if this is a Rails project
if [ ! -f "bin/rails" ]; then
  echo "ℹ️  Not a Rails project. Skipping test run."
  exit 0
fi

# Check if file is a test file
if [[ ! "$TEST_FILE" =~ _test\.rb$ ]] && [[ ! "$TEST_FILE" =~ _spec\.rb$ ]]; then
  echo "ℹ️  Not a test file. Skipping."
  exit 0
fi

# Run the specific test file
echo "🧪 Running tests: $TEST_FILE"
echo ""

if [ -f "bin/rails" ]; then
  # Minitest (Rails default)
  bundle exec rails test "$TEST_FILE"
  TEST_RESULT=$?
else
  # RSpec (if used)
  bundle exec rspec "$TEST_FILE"
  TEST_RESULT=$?
fi

echo ""

if [ $TEST_RESULT -eq 0 ]; then
  echo "✅ All tests passed!"
else
  echo "❌ Tests failed. Fix the issues before continuing."
  echo ""
  echo "💡 TDD Reminder: Tests should pass before marking work complete."
fi

exit 0  # Don't block on test failure (let QA persona catch it)
