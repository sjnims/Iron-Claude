---
description: Plan feature milestones with TDD workflow and acceptance criteria
---

# Milestone Planning

Interactive feature planning that helps you break down user stories into testable milestones following TDD workflow and Rails 8 best practices.

## What This Command Does

Helps you plan features by:

1. Breaking down user stories into milestones
2. Defining acceptance criteria for each milestone
3. Setting up TDD workflow (test-first approach)
4. Identifying Hotwire patterns needed
5. Planning database schema and migrations
6. Creating `.iron-claude/milestone.json` for tracking

## When to Use

- ✅ Starting a new feature
- ✅ Breaking down large user stories
- ✅ Planning sprint work
- ✅ Defining acceptance criteria
- ✅ Setting up TDD workflow

## Example Usage

```
/milestone-planning
# Interactive: Will ask questions about your feature

/milestone-planning user authentication system
# With feature name provided

/milestone-planning "Add real-time notifications with Turbo Streams"
# With detailed feature description
```

## Planning Workflow

### Step 1: Feature Discovery

You'll be asked:

- **What user problem does this solve?**
- **What's the happy path user flow?**
- **What are the edge cases?**
- **What data needs to persist?**

**Example**:

```
Feature: User Authentication
Problem: Users need secure login to access their data
Happy Path: Sign up → Verify email → Log in → Access dashboard
Edge Cases: Wrong password, expired tokens, duplicate emails
Data: Users table (email, password_digest, confirmed_at)
```

### Step 2: Milestone Breakdown

Feature is broken into testable milestones:

**Example for User Authentication:**

1. **User Model with Validation** (30min)
   - Tests: Validations, password hashing
   - Files: `app/models/user.rb`, `test/models/user_test.rb`

2. **Sign Up Flow** (1hr)
   - Tests: Controller tests, system test
   - Files: `app/controllers/registrations_controller.rb`

3. **Email Confirmation** (45min)
   - Tests: Token generation, expiration, confirmation
   - Files: `app/models/user.rb`, `app/mailers/user_mailer.rb`

4. **Sign In/Out** (45min)
   - Tests: Session management, authentication
   - Files: `app/controllers/sessions_controller.rb`

5. **Password Reset** (1hr)
   - Tests: Token flow, email delivery, password update
   - Files: `app/controllers/password_resets_controller.rb`

### Step 3: TDD Workflow Setup

For each milestone:

1. **RED** - Write failing tests first
2. **GREEN** - Minimal code to pass
3. **REFACTOR** - Improve while keeping green

**Example Test-First Approach:**

```ruby
# Step 1: RED - Write failing test
test "requires email" do
  user = User.new(password: "password123")
  assert_not user.valid?
end

# Step 2: GREEN - Make it pass
class User < ApplicationRecord
  validates :email, presence: true
end

# Step 3: REFACTOR - Improve
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
```

### Step 4: Hotwire Pattern Selection

For each UI milestone, identify the right Hotwire pattern:

- **Turbo Drive**: Standard navigation (default)
- **Turbo Frames**: Lazy-loaded sections, inline editing
- **Turbo Streams**: Real-time updates, flash messages
- **Page Morphing**: Smooth full-page updates
- **Stimulus**: Minimal JavaScript for interactions

**Example**:

```
Sign Up Form:
- Pattern: Turbo Frame (inline validation)
- Why: Show errors without page reload
- Fallback: Standard form POST

Flash Messages:
- Pattern: Turbo Stream
- Why: Dismiss without page reload
- Fallback: Session flash (page reload)
```

### Step 5: Database Schema Planning

Plan migrations needed:

```ruby
# Migration 1: Create users table
create_table :users do |t|
  t.string :email, null: false, index: { unique: true }
  t.string :password_digest, null: false
  t.string :confirmation_token, index: true
  t.datetime :confirmed_at
  t.string :reset_password_token, index: true
  t.datetime :reset_password_sent_at
  t.timestamps
end
```

### Step 6: Acceptance Criteria

Define done criteria for each milestone:

**Example**:

```markdown
## Milestone: Sign Up Flow

### Acceptance Criteria
- [ ] User can sign up with email/password
- [ ] Validation errors shown inline (Turbo Frame)
- [ ] Confirmation email sent (background job)
- [ ] Test coverage ≥ 90%
- [ ] System test for happy path
- [ ] Mobile responsive
- [ ] Accessible (keyboard navigation)
- [ ] Security: Strong Parameters, CSRF protection

### Definition of Done
- [ ] All acceptance criteria met
- [ ] Tests passing (TDD followed)
- [ ] Code reviewed (@code-reviewer)
- [ ] Performance validated (@devops-engineer)
- [ ] UX approved (@product-manager)
```

## Generated Milestone File

Creates `.iron-claude/milestone.json`:

```json
{
  "name": "User Authentication",
  "description": "Secure email/password authentication system",
  "created_at": "2025-11-08T14:30:00Z",
  "milestones": [
    {
      "id": 1,
      "name": "User Model with Validation",
      "estimated_time": "30min",
      "status": "pending",
      "acceptance_criteria": [
        "Email validation with format check",
        "Password hashing with bcrypt",
        "Test coverage ≥ 90%"
      ],
      "tdd_checklist": [
        "Write failing validation tests",
        "Implement validations",
        "Add password hashing tests",
        "Implement has_secure_password"
      ]
    }
  ],
  "hotwire_patterns": {
    "sign_up_form": {
      "pattern": "Turbo Frame",
      "reason": "Inline validation without page reload"
    },
    "flash_messages": {
      "pattern": "Turbo Stream",
      "reason": "Dismissible without reload"
    }
  },
  "database_changes": [
    {
      "type": "create_table",
      "table": "users",
      "columns": ["email", "password_digest", "confirmation_token", "confirmed_at"]
    }
  ]
}
```

## Sample Output

```markdown
# Milestone Plan: User Authentication

## Feature Summary
**Problem**: Users need secure login to access their data
**Solution**: Email/password authentication with confirmation
**Estimated Total Time**: 4 hours

## Milestones

### 1. User Model with Validation ⏱️ 30min
**Status**: Pending
**TDD Workflow**:
1. RED: Write failing validation tests
2. GREEN: Add validations to User model
3. REFACTOR: Extract validation logic to concern

**Acceptance Criteria**:
- [ ] Email format validation
- [ ] Password minimum length (12 chars)
- [ ] Unique email constraint
- [ ] Test coverage ≥ 90%

**Files**:
- `app/models/user.rb`
- `test/models/user_test.rb`

---

### 2. Sign Up Flow ⏱️ 1hr
**Status**: Pending
**Hotwire Pattern**: Turbo Frame (inline validation)
**TDD Workflow**:
1. RED: Write failing controller tests
2. GREEN: Implement registrations controller
3. REFACTOR: Extract to service object

**Acceptance Criteria**:
- [ ] User can sign up with email/password
- [ ] Errors shown inline (no page reload)
- [ ] Confirmation email queued
- [ ] System test for flow
- [ ] Mobile responsive

**Files**:
- `app/controllers/registrations_controller.rb`
- `app/views/registrations/new.html.erb`
- `test/controllers/registrations_controller_test.rb`
- `test/system/user_registration_test.rb`

---

## Database Migrations

```ruby
# db/migrate/XXXXXX_create_users.rb
class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :confirmation_token
  end
end
```

## Next Steps

1. Run `/milestone-planning` saved to `.iron-claude/milestone.json`
2. Start with Milestone 1 (TDD workflow)
3. Run `/review-feature` after each milestone
4. Update milestone status as you progress
5. Run `/pre-deploy` before shipping

---

**Ready to start?** Let's build this feature test-first! 🚀

```

## Tips

**Start Small**: Break features into 30min-1hr milestones
**Test First**: Always RED → GREEN → REFACTOR
**One Pattern at a Time**: Don't mix Turbo Frames and Streams unnecessarily
**Validate Often**: Run `/review-feature` after each milestone
**Track Progress**: Update milestone.json as you work

---

**Remember**: Good planning prevents problems. A clear milestone plan with TDD workflow means faster development and fewer bugs.
