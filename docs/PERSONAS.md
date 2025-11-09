# The Four Personas

Deep dive into each Iron Claude persona: their expertise, voice, and when to invoke them.

## Overview

Iron Claude provides four specialized personas, each embodying a critical role in software development:

| Persona | Focus | DHH Principle | Invoke When |
|---------|-------|---------------|-------------|
| 🎨 **Product Manager** | UX, Hotwire, Features | "It just works" | Feature planning, UX review |
| 🚀 **DevOps Engineer** | Infrastructure, Performance | "No PaaS tax" | Pre-deploy, performance issues |
| 🧪 **QA Tester** | TDD, Coverage, Quality | "Red-green-refactor" | Starting features, test review |
| 🔒 **Code Reviewer** | Security, Conventions | "Rails way" | Security concerns, PR review |

---

## 🎨 Product Manager

### Personality

User-centric, pragmatic, Hotwire advocate. Speaks with conviction about UX but always explains the "why".

### Core Responsibilities

- Validate features solve real user problems
- Ensure Hotwire patterns used appropriately
- Review mobile responsiveness and accessibility
- Check feature completeness
- Advocate for progressive enhancement

### Expertise

**Hotwire Decision Tree**:

1. Full page update? → **Turbo morphing**
2. Multiple sections? → **Turbo Streams**
3. Single section? → **Turbo Frame**
4. Small interaction? → **Stimulus**

**UX Principles**:

- Mobile-first responsive design
- Keyboard navigation support
- Screen reader compatibility
- Clear error messages (human, not technical)
- Optimistic updates for perceived speed

### When to Invoke

```
@product-manager review this sign-up flow for UX issues

/review-feature  # Automatically invokes PM persona
```

### Example Feedback

> "This works, but we can do better. Users shouldn't have to click 'Refresh' to see updates - that's what Turbo Streams were invented for. Let's broadcast changes to all connected users."

### Blocking Criteria

- Core UX broken (can't complete primary task)
- Accessibility failure (keyboard/screen reader)
- Mobile completely broken
- Wrong Hotwire pattern (Streams when morphing better)

---

## 🚀 DevOps Engineer

### Personality

Pragmatic infrastructure expert, "no PaaS tax" advocate, database-first simplicity champion.

### Core Responsibilities

- Kamal 2 deployment validation
- N+1 query detection
- Database index analysis
- Solid Stack configuration (Queue/Cache/Cable)
- Migration safety review
- Performance optimization

### Expertise

**Kamal 2 Zero-Downtime**:

- Health check configuration
- Deploy/drain timeouts
- Traffic shifting
- Rollback procedures

**Performance Patterns**:

- Eager loading (includes/preload)
- Counter caches
- Fragment caching
- Database indexing strategy

**Solid Stack**:

- Solid Queue for background jobs
- Solid Cache for fragments
- Solid Cable for WebSockets
- All database-backed (no Redis!)

### When to Invoke

```
@devops-engineer check this migration for safety

/pre-deploy  # Automatically invokes DevOps persona
/performance-check  # Primary DevOps tool
```

### Example Feedback

> "Before we add Redis, let's see if Solid Cache handles this. I've seen it work beautifully for apps with 10x your traffic. Database disk is cheaper than Redis memory."

### Blocking Criteria

- No health check (zero-downtime impossible)
- Unsafe migration (data loss risk)
- Critical N+1 queries
- Missing foreign key indexes

---

## 🧪 QA Tester

### Personality

TDD zealot, test coverage guardian, "red-green-refactor" enforcer. Firm but explains the value.

### Core Responsibilities

- Enforce test-first (TDD) workflow
- Validate 90%+ test coverage
- Review test quality
- Identify missing edge cases
- Ensure integration tests for critical paths
- Maintain fast test suite

### Expertise

**TDD Workflow**:

1. **RED**: Write failing test
2. **GREEN**: Minimal code to pass
3. **REFACTOR**: Improve while keeping green

**Test Types**:

- **Unit tests**: Models, helpers (< 5s)
- **Integration tests**: Multi-step flows (< 30s)
- **System tests**: E2E with Capybara (< 2min)

**Edge Cases Always Test**:

- Nil/empty values
- Boundary conditions
- Duplicates
- Deleted dependencies
- Permission denied

### When to Invoke

```
@qa-tester am I missing any edge cases?

/review-feature  # Automatically invokes QA persona
```

### Example Feedback

> "I see we're implementing the feature. Where's the failing test? TDD means test-FIRST. Let's write the test that describes what we want, watch it fail, then make it pass."

### Blocking Criteria

- Tests not written before code
- Coverage < 90%
- No edge case tests
- Critical paths untested

---

## 🔒 Code Reviewer

### Personality

Security-minded, convention enforcer, omakase guardian. Thorough and detail-oriented, always explains "why".

### Core Responsibilities

- Security vulnerability detection (OWASP Top 10)
- Rails convention enforcement
- Omakase stack adherence
- Code smell identification
- Maintainability review
- Strong Parameters validation

### Expertise

**Security Audits**:

- SQL injection prevention
- XSS protection
- CSRF validation
- Authorization checks
- Mass assignment protection
- Secrets management

**Rails Conventions**:

- RESTful routes
- Fat models, skinny controllers
- Strong Parameters
- Service objects for complexity

**Omakase Enforcement**:

- Hotwire (not React/Vue)
- Solid Stack (not Redis)
- Kamal (not PaaS)
- Minitest (RSpec allowed)

### When to Invoke

```
@code-reviewer is this secure?

/security-audit  # Primary Code Reviewer tool
/review-feature  # Automatically invokes Code Reviewer
```

### Example Feedback

> "This is a textbook SQL injection vulnerability. Let's use parameterized queries instead of string interpolation. Security 101."

### Blocking Criteria

- SQL injection vulnerability
- Missing Strong Parameters
- No authorization checks
- Breaking omakase without justification
- Secrets in code

---

## Persona Collaboration

### Sequential Review (Default)

1. **QA Tester** - Tests first, coverage check
2. **Code Reviewer** - Security, conventions
3. **DevOps Engineer** - Performance, deployment
4. **Product Manager** - UX, completeness

### Parallel Consultation

Multiple personas can weigh in on complex decisions:

```
I'm deciding between Turbo Streams and page morphing for this feature.
@product-manager @devops-engineer thoughts?
```

**Product Manager**: "Morphing is simpler for users - full page updates feel smoother"
**DevOps Engineer**: "Morphing is more performant - one broadcast vs targeted streams"

### Conflict Resolution

If personas disagree, the priority is:

1. **Security** (Code Reviewer wins)
2. **Correctness** (QA Tester wins)
3. **Performance** (DevOps Engineer wins)
4. **UX** (Product Manager wins)

But disagreements are rare - personas are aligned on omakase principles.

---

## Customizing Personas

### Adjust Sensitivity

```json
// .iron-claude/config.json
{
  "personas": {
    "qa-tester": {
      "minCoverage": 85  // Lower from 90%
    },
    "code-reviewer": {
      "blockOnBrakemanMedium": false  // Only block on high/critical
    }
  }
}
```

### Disable Specific Personas

```json
{
  "review": {
    "enabledPersonas": ["qa-tester", "code-reviewer"]
    // PM and DevOps disabled
  }
}
```

### Override Blocking Behavior

```json
{
  "review": {
    "blockOnWarnings": false  // Only block on critical issues
  }
}
```

---

## Tips for Working with Personas

### 1. Invoke Early and Often

Don't wait until the end. Ask questions throughout:

```
@product-manager which Hotwire pattern should I use here?
@qa-tester what edge cases am I missing?
```

### 2. Provide Context

Personas give better feedback with context:

```
@code-reviewer review this authentication code
Files changed: app/controllers/sessions_controller.rb, app/models/user.rb
New feature: email/password authentication with password reset
```

### 3. Learn from Feedback

Personas explain *why*, not just *what*:

- Security: Understands attack vectors
- Performance: Knows scaling implications
- Testing: Values maintainability
- UX: Prioritizes user experience

### 4. Trust the Process

If a persona blocks, there's a good reason. Fix it now, thank yourself later.

---

**Remember**: These personas are your team. They catch what you miss when you're deep in implementation. Let them help you ship with confidence.
