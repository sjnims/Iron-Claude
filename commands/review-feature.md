---
description: Comprehensive feature review by all 4 Iron Claude personas
---

# Review Feature

Invoke all four Iron Claude personas to perform a comprehensive, multi-perspective review of the current feature or milestone.

## What This Command Does

This command sequentially invokes each of the four specialized personas to review your work from their domain expertise:

1. **@qa-tester** - Test coverage, TDD compliance, edge cases
2. **@code-reviewer** - Security, Rails conventions, omakase adherence
3. **@devops-engineer** - Performance, deployment readiness, infrastructure
4. **@product-manager** - UX validation, Hotwire patterns, feature completeness

Each persona provides focused feedback from their perspective, and the results are synthesized into actionable recommendations.

## When to Use

- ✅ After completing a feature (before marking milestone done)
- ✅ Before creating a pull request
- ✅ When you want comprehensive feedback from all perspectives
- ✅ As a pre-merge quality gate
- ✅ When you're unsure if something is production-ready

## How It Works

### Step 1: QA Tester Review

The QA Tester reviews:

- Test coverage (target: 90%+)
- TDD workflow compliance (tests written first?)
- Edge case coverage
- Test quality and speed
- Integration test coverage for critical paths

**Blocks if**:

- Coverage < 90%
- No tests written
- Tests written after implementation
- Missing edge case tests

### Step 2: Code Reviewer Analysis

The Code Reviewer audits:

- Security vulnerabilities (OWASP Top 10)
- Rails conventions and best practices
- Omakase stack adherence
- Code smells and maintainability
- Strong Parameters and authorization

**Blocks if**:

- Security vulnerabilities found
- Breaking Rails conventions
- Non-omakase dependencies without justification
- Missing authorization checks

### Step 3: DevOps Engineer Check

The DevOps Engineer validates:

- N+1 queries and missing indexes
- Database migration safety
- Kamal deployment configuration
- Health check functionality
- Performance implications

**Blocks if**:

- N+1 query bombs
- Unsafe migrations
- Missing health checks
- Performance regressions

### Step 4: Product Manager Validation

The Product Manager ensures:

- Feature solves user problem
- Hotwire patterns used appropriately
- Mobile responsiveness
- Accessibility (keyboard, screen readers)
- User-facing error messages are clear

**Blocks if**:

- Poor UX or accessibility failures
- Wrong Hotwire pattern used
- Mobile experience broken
- Feature incomplete

### Step 5: Synthesis

After all personas provide feedback, the review is synthesized into:

- ✅ **Approved Items** - What's working well
- ⚠️ **Warnings** - Issues to be aware of (non-blocking)
- ❌ **Blockers** - Must be fixed before shipping
- 📋 **Action Items** - Prioritized list of next steps

## Example Usage

```
/review-feature

# Or specify what to review:
/review-feature articles CRUD implementation

# Or review before deployment:
/review-feature pre-deploy check for authentication feature
```

## What You'll Get

### Sample Output

```markdown
# Feature Review: User Authentication

## ✅ Approved (What's Working)

**QA Tester**:
- ✅ Test coverage: 94% (exceeds 90% target)
- ✅ TDD workflow followed (tests written first)
- ✅ Edge cases covered (nil, invalid, duplicate users)
- ✅ System tests for sign-up and sign-in flows

**Code Reviewer**:
- ✅ Using bcrypt for password hashing
- ✅ Strong Parameters implemented correctly
- ✅ CSRF protection enabled
- ✅ Rails conventions followed

**DevOps Engineer**:
- ✅ No N+1 queries detected
- ✅ Database indexes present on email lookups
- ✅ Health check includes session validation

**Product Manager**:
- ✅ Sign-up flow intuitive and mobile-friendly
- ✅ Error messages clear and helpful
- ✅ Progressive enhancement (works without JS)

## ⚠️ Warnings (Non-Blocking Issues)

**Code Reviewer**:
- ⚠️ Consider adding rate limiting for login attempts
- ⚠️ Session timeout is 2 weeks - consider shortening for security

**DevOps Engineer**:
- ⚠️ Email delivery is synchronous - consider background job for production

## ❌ Blockers (Must Fix Before Shipping)

**Code Reviewer**:
- ❌ Password reset tokens don't expire - security vulnerability
- ❌ Missing authorization check in ProfileController#update

**Product Manager**:
- ❌ Password requirements not displayed on sign-up form
- ❌ Screen reader can't navigate sign-in form (missing ARIA labels)

## 📋 Action Items

**Priority 1 (Security - Must Fix)**:
1. Add expiration to password reset tokens (Code Reviewer)
2. Implement authorization check for profile updates (Code Reviewer)

**Priority 2 (UX - Should Fix)**:
3. Display password requirements on sign-up form (Product Manager)
4. Add ARIA labels to authentication forms (Product Manager)

**Priority 3 (Enhancements - Nice to Have)**:
5. Add rate limiting for login attempts (Code Reviewer)
6. Move email delivery to background job (DevOps Engineer)
7. Consider shorter session timeout (Code Reviewer)

## Recommendation

**Status**: ⚠️ **BLOCKED** - Fix 2 security issues and 2 UX issues before deploying

**Estimated effort**: 1-2 hours

**Next steps**:
1. Fix password reset token expiration
2. Add profile update authorization
3. Improve form accessibility
4. Re-run /review-feature to validate fixes
```

## Tips for Best Results

### Provide Context

The more context you give, the better the review:

```
/review-feature

# Add context about what changed:
Working on: User authentication with email/password
Changed files: app/models/user.rb, app/controllers/sessions_controller.rb
Tests added: test/models/user_test.rb, test/system/authentication_test.rb
```

### Run After Test Suite Passes

Ensure your test suite is green before running the review:

```bash
bundle exec rails test
# All tests passing? Great!
/review-feature
```

### Iterate Based on Feedback

Fix blockers, then re-run:

```
/review-feature  # First run - finds 3 blockers
# Fix the blockers
/review-feature  # Second run - validates fixes
```

### Combine with Other Commands

```
/security-audit              # Deep dive on security
/performance-check           # Analyze queries and performance
/review-feature             # Comprehensive review from all personas
/pre-deploy                 # Final check before deployment
```

## Configuration

The review criteria can be customized in your project's `.iron-claude/config.json`:

```json
{
  "review": {
    "minCoverage": 90,
    "enabledPersonas": ["qa-tester", "code-reviewer", "devops-engineer", "product-manager"],
    "blockOnWarnings": false,
    "autoFixEnabled": true
  }
}
```

## Under the Hood

When you run `/review-feature`, Iron Claude:

1. Analyzes recent changes (git diff if available)
2. Runs SimpleCov for coverage data
3. Invokes each persona as a specialized subagent
4. Collects feedback from all four perspectives
5. Synthesizes into unified report
6. Prioritizes action items by severity
7. Provides clear recommendation (ship/block/fix)

---

**Remember**: The goal isn't perfection, it's catching blind spots. These four personas see what you can't when you're deep in implementation. Let them help you ship with confidence.
