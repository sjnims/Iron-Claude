# Getting Started with Iron Claude

Complete guide to installing and using Iron Claude for your first Rails 8 feature.

## Prerequisites

- Claude Code installed
- Rails 8 application (or willingness to create one)
- Git configured
- GitHub account (optional, for PR automation)

## Installation

### From Marketplace (Recommended - Coming Soon)

```bash
claude plugin install iron-claude
```

### From Source

```bash
# Clone the repository
git clone https://github.com/sjnims/Iron-Claude.git

# Install the plugin
claude plugin install ./iron-claude

# Verify installation
claude plugin list
# Should show: iron-claude v1.0.0
```

## Initial Setup

### 1. Configure GitHub Integration (Optional)

```bash
# Set your GitHub token
export GITHUB_TOKEN="your_github_personal_access_token"

# Or add to your shell profile (~/.zshrc or ~/.bashrc)
echo 'export GITHUB_TOKEN="your_token"' >> ~/.zshrc
```

### 2. Configure RuboCop (Optional but Recommended)

```bash
# In your Rails project
bundle add rubocop --group development
bundle exec rubocop --auto-gen-config
```

### 3. Set Up Brakeman (Security Scanning)

```bash
bundle add brakeman --group development
```

## Your First Feature with Iron Claude

Let's build a simple "Articles" CRUD feature using Iron Claude's full workflow.

### Step 1: Start a New Session

```bash
cd your-rails-app
claude
```

You'll see Iron Claude load the milestone context (if any exists).

### Step 2: Plan the Feature

```
/milestone-planning articles CRUD
```

**Iron Claude Response**:

```markdown
# Milestone Plan: Articles CRUD

## Milestones

### 1. Article Model (30min)
- TDD: Write validation tests first
- Implement model with validations
- Files: app/models/article.rb, test/models/article_test.rb

### 2. Articles Controller (1hr)
- TDD: Write controller tests
- Implement RESTful actions
- Hotwire: Use Turbo Frames for inline editing

### 3. Views (45min)
- Index, show, new, edit templates
- Hotwire patterns for UX
- Mobile responsive

Ready to start with Milestone 1? Let's write the first test!
```

### Step 3: Write Tests First (TDD)

```
Let's start Milestone 1. I'll write the first test for the Article model.
```

**Iron Claude (@qa-tester)**:

```markdown
Perfect! Here's the test structure:

# test/models/article_test.rb
require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "requires title" do
    article = Article.new(body: "Content")
    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
  end

  test "requires body" do
    article = Article.new(title: "Title")
    assert_not article.valid?
  end

  test "saves with valid attributes" do
    article = Article.new(title: "Title", body: "Content")
    assert article.save
  end
end

Now run the test (it should fail - RED):
bin/rails test test/models/article_test.rb

After it fails, implement the Article model to make it pass!
```

### Step 4: Implement (Make Tests Pass)

```
The tests failed as expected. Now I'll implement the Article model.
```

**Iron Claude**:

```ruby
# app/models/article.rb
class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
end

# Migration
rails generate model Article title:string body:text
rails db:migrate

# Run tests again
bin/rails test test/models/article_test.rb
# Should be GREEN ✅
```

### Step 5: Review the Milestone

```
/review-feature
```

**Iron Claude** invokes all 4 personas:

**@qa-tester**: ✅ Tests pass, coverage 100% for Article model
**@code-reviewer**: ✅ Validations correct, following Rails conventions
**@devops-engineer**: ⚠️ Add index to articles.title if filtering by title
**@product-manager**: ✅ N/A for model-only milestone

```markdown
## Review Result

Status: ✅ Approved with 1 recommendation

Recommendation: Add index to title if you'll filter/search by it.

Ready to move to Milestone 2!
```

### Step 6: Continue with Remaining Milestones

Repeat the TDD cycle for controller and views:

1. Write failing tests
2. Implement to pass
3. Review with `/review-feature`

### Step 7: Pre-Deployment Check

```
/pre-deploy
```

**Iron Claude** runs comprehensive checks:

- ✅ All tests passing (coverage 94%)
- ✅ Security: Brakeman clean
- ✅ Performance: No N+1 queries
- ✅ Kamal: Health check configured
- ✅ Database: Migrations reversible

```markdown
🚀 **GO FOR DEPLOYMENT**

Confidence: HIGH
```

### Step 8: Deploy

```bash
kamal deploy
```

## Understanding the Personas

### When Each Persona Activates

**Product Manager** 🎨:

- Feature planning
- UX review
- Hotwire pattern selection
- Accessibility checks

**QA Tester** 🧪:

- When you start coding (enforces TDD)
- Coverage validation
- Edge case review

**Code Reviewer** 🔒:

- Security concerns
- Convention violations
- Pre-merge checks

**DevOps Engineer** 🚀:

- Pre-deployment
- Performance issues
- Infrastructure questions

## Customizing Your Workflow

### Adjust Coverage Requirements

```json
// .iron-claude/config.json
{
  "review": {
    "minCoverage": 85  // Lower from default 90%
  }
}
```

### Disable Specific Personas

```json
{
  "review": {
    "enabledPersonas": [
      "qa-tester",
      "code-reviewer"
      // Disabled: devops-engineer, product-manager
    ]
  }
}
```

### Skip Hooks Temporarily

```bash
# In emergency (use sparingly!)
export IRON_CLAUDE_SKIP_HOOKS=true
```

## Troubleshooting

### Hooks Not Running

```bash
# Check hook configuration
cat .claude-plugin/hooks/hooks.json

# Verify scripts are executable
ls -la hooks/scripts/
# Should show: -rwxr-xr-x for .sh files
```

### Personas Not Responding

Ensure you're invoking them correctly:

```
@product-manager review this UX
/review-feature
```

Not:

```
product-manager review this  # Missing @
```

### RuboCop Errors

```bash
# Auto-generate config
bundle exec rubocop --auto-gen-config

# Auto-fix offenses
bundle exec rubocop --auto-correct-all
```

## Next Steps

- **Read** [Personas Documentation](PERSONAS.md) for deep dive
- **Learn** [TDD Workflows](WORKFLOWS.md) for mastery
- **Understand** [Philosophy](PHILOSOPHY.md) for the "why"
- **Build** your next feature!

---

**You're ready!** Start building with Iron Claude and ship Rails 8 apps with confidence 🚀
