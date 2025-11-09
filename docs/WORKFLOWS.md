# Workflows with Iron Claude

Master the TDD workflow and milestone-based development patterns.

## The TDD Workflow

### Red-Green-Refactor Cycle

```
┌─────────┐
│   RED   │  Write failing test
└────┬────┘
     │
     ▼
┌─────────┐
│  GREEN  │  Minimal code to pass
└────┬────┘
     │
     ▼
┌─────────┐
│REFACTOR │  Improve while keeping green
└────┬────┘
     │
     ▼
   (Repeat)
```

### Step-by-Step Example

**Feature**: User sign-up

#### 1. RED - Write Failing Test

```ruby
# test/system/user_registration_test.rb
test "user can sign up" do
  visit root_path
  click_on "Sign Up"

  fill_in "Email", with: "user@example.com"
  fill_in "Password", with: "securepassword123"
  click_on "Create Account"

  assert_text "Welcome!"
end
```

**Run**: `bin/rails test` → **FAILS** (routes don't exist)

#### 2. GREEN - Minimal Implementation

```ruby
# config/routes.rb
resources :users, only: [:new, :create]

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create!(user_params)
    redirect_to root_path, notice: "Welcome!"
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
```

**Run**: `bin/rails test` → **PASSES** ✅

#### 3. REFACTOR - Improve

```ruby
# Extract to service object
class UserCreationService
  def self.call(params)
    user = User.create!(params)
    UserMailer.welcome_email(user).deliver_later
    Analytics.track_signup(user)
    user
  end
end

# Controller becomes thin
def create
  @user = UserCreationService.call(user_params)
  redirect_to root_path, notice: "Welcome!"
end
```

**Run**: `bin/rails test` → **STILL PASSES** ✅

### Iron Claude TDD Enforcement

**Scenario**: You try to implement before writing tests

```
You: Let me implement the User model with validations

@qa-tester: ⚠️ Hold on! TDD means test-FIRST.

Where's the failing test? Let's write it now:

test "requires email" do
  user = User.new(password: "password123")
  assert_not user.valid?
end

Write this test first, watch it fail (RED), then implement.
```

**Hooks enforce this**: PostToolUse hook runs tests, Stop hook validates TDD compliance.

---

## Milestone-Based Development

### What is a Milestone?

A milestone is a **shippable, testable increment** of functionality (30min-2hr of work).

**Good Milestone**:

- ✅ "User Model with email validation" (30min)
- ✅ "Sign-up form with Turbo Frame" (1hr)

**Bad Milestone**:

- ❌ "User authentication system" (too large, 8+ hrs)
- ❌ "Fix stuff" (not specific)

### Milestone Lifecycle

```
1. PLAN → 2. RED → 3. GREEN → 4. REFACTOR → 5. REVIEW → 6. DEPLOY
   ↑                                                          │
   └──────────────────────────────────────────────────────────┘
```

#### 1. PLAN - Define Milestone

```
/milestone-planning "User email verification"
```

**Output**:

```markdown
## Milestone: User Email Verification

**Time**: 1 hour
**Acceptance Criteria**:
- [ ] User receives confirmation email on sign-up
- [ ] Confirmation token expires after 24 hours
- [ ] User can resend confirmation email
- [ ] System tests cover happy path

**TDD Checklist**:
- [ ] Test: token generated on user creation
- [ ] Test: token expires after 24 hours
- [ ] Test: confirmation marks user as confirmed
```

Saves to `.iron-claude/milestone.json`

#### 2-4. TDD Cycle

Follow red-green-refactor for each acceptance criterion.

#### 5. REVIEW - All Personas Validate

```
/review-feature
```

**@qa-tester**: Coverage 95%, edge cases covered ✅
**@code-reviewer**: Token properly secured, expires ✅
**@devops-engineer**: Email delivery via Solid Queue ✅
**@product-manager**: Clear email copy, mobile-friendly ✅

#### 6. DEPLOY - Ship It

```
/pre-deploy
kamal deploy
```

### Milestone Tracking

**View current milestone**:

```bash
cat .iron-claude/milestone.json
```

**Update milestone status**:

```json
{
  "milestones": [
    {
      "name": "User Model",
      "status": "completed"  // Change from "in_progress"
    }
  ]
}
```

**SessionStart hook**: Loads milestone context
**Stop hook**: Validates milestone completion before ending session

---

## Feature Development Workflow

### Complete Feature Example: Articles CRUD

#### Week Plan

- **Monday**: Milestone 1-2 (Model + Controller)
- **Tuesday**: Milestone 3-4 (Views + Hotwire)
- **Wednesday**: Milestone 5 (Tests + Review)
- **Thursday**: Pre-deploy + Deploy

#### Day 1: Monday - Backend

**Morning** (Milestone 1: Article Model)

```
1. /milestone-planning "Article model with validations"
2. Write tests for validations
3. Implement model
4. /review-feature
```

**Afternoon** (Milestone 2: Articles Controller)

```
1. /milestone-planning "RESTful articles controller"
2. Write controller tests
3. Implement CRUD actions
4. /review-feature
```

#### Day 2: Tuesday - Frontend

**Morning** (Milestone 3: Basic Views)

```
1. /milestone-planning "Articles index and show views"
2. Write system tests
3. Implement views
4. /review-feature
```

**Afternoon** (Milestone 4: Hotwire Enhancement)

```
1. /milestone-planning "Turbo Frame inline editing"
2. Update tests for Turbo behavior
3. Implement Turbo Frames
4. /review-feature
```

#### Day 3: Wednesday - Quality

**Morning** (Milestone 5: Edge Cases)

```
1. Review test coverage
2. Add missing edge case tests
3. Fix any bugs found
4. /review-feature
```

**Afternoon** (Security + Performance)

```
1. /security-audit
2. /performance-check
3. Fix any issues
4. /review-feature
```

#### Day 4: Thursday - Deployment

**Morning** (Pre-Deploy)

```
1. /pre-deploy
2. Fix any blockers
3. Final /review-feature
```

**Afternoon** (Deploy)

```
1. git push origin main
2. kamal deploy
3. Monitor deployment
4. Celebrate! 🎉
```

---

## Workflow Patterns

### Pattern 1: Spike Then TDD

For uncertain features, spike first:

```
1. Quick prototype (no tests, throwaway code)
2. Learn what works
3. Delete spike
4. Start over with TDD
5. Build properly with tests
```

**When**: New technology, unclear requirements

### Pattern 2: Test-After for Legacy

Adding tests to existing code:

```
1. Characterization test (current behavior)
2. Refactor with test safety
3. Add proper unit tests
4. Continue with TDD
```

**When**: Legacy code without tests

### Pattern 3: Outside-In TDD

System test → Integration test → Unit test:

```
1. System test (user flow)
2. Implement high-level
3. Integration tests (services)
4. Unit tests (models)
```

**When**: Feature-first development

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Iron Claude Workflow

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
      - run: bundle install
      - run: bin/rails test
      - run: /review-feature

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: /security-audit

  pre-deploy:
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: /pre-deploy
      - name: Deploy
        if: success()
        run: kamal deploy
```

---

## Troubleshooting Workflows

### "TDD is slow!"

**Reality**: TDD is faster long-term

- Fewer bugs in production
- Confident refactoring
- Less debugging time

**Tips**:

- Keep tests fast (parallelize)
- Use factories, not fixtures
- Mock external services

### "I forgot to write tests first"

**Solution**: Hooks remind you!

```
@qa-tester: TDD violation detected. Tests should be written first.
Let's write the test now.
```

### "Personas are too strict"

**Customize**:

```json
{
  "review": {
    "blockOnWarnings": false  // Only block on critical
  }
}
```

---

**Remember**: Workflows compound. The more you follow TDD + milestones, the faster you ship and the fewer bugs you create. Trust the process!
