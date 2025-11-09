# Iron Claude Philosophy

Understanding the "why" behind Iron Claude's design and DHH's omakase principles.

## The Omakase Philosophy

**Omakase** (お任せ) - "I'll leave it up to you"

In sushi restaurants, omakase means trusting the chef to select and prepare the best experience. In Rails, it means trusting the framework's opinionated choices.

### DHH's Core Principles

#### 1. Convention over Configuration

**Bad** (Configuration Hell):
```ruby
# config/initializers/pagination.rb
Kaminari.configure do |config|
  config.default_per_page = 25
  config.max_per_page = 100
  config.window = 4
  config.outer_window = 0
  config.left = 0
  config.right = 0
  config.page_method_name = :page
  config.param_name = :page
end
```

**Good** (Convention):
```ruby
# Rails default pagination just works
@articles = Article.page(params[:page])
```

**Iron Claude enforces**: @code-reviewer blocks non-conventional patterns.

#### 2. The Majestic Monolith

**Resist Distribution**:
- One codebase (easier to understand)
- One deployment (simpler operations)
- One database (no eventual consistency)

**When to Distribute**:
- Team > 12 developers (coordination cost)
- Specific performance needs (e.g., separate search service)
- Different deployment cadences

**Iron Claude enforces**: @devops-engineer questions complexity, advocates simplicity.

#### 3. No Build, No PaaS

**The Build Tax**:
- Webpack config (100+ lines)
- Node dependencies (100+ MB)
- Build time (minutes)
- Build failures (random)

**The Rails 8 Way**:
```ruby
# import map just works
# Pin npm packages to importmap
pin "turbo-rails", to: "turbo.min.js"

# No build step, no node_modules
```

**The PaaS Tax**:
- Heroku: $50/month → $2,500/month at scale (50x!)
- Locked into platform
- Limited control

**The Kamal Way**:
- VPS: $5/month → $50/month at scale
- Full control
- Zero-downtime deploys

**Iron Claude enforces**: @devops-engineer validates Kamal config, blocks PaaS dependencies.

#### 4. Database-Backed Everything

**Old Way**:
- Redis for cache (memory, costly, volatile)
- Redis for jobs (Sidekiq)
- Redis for WebSockets (Action Cable)
- 3 services to manage!

**Solid Stack Way**:
- Solid Cache (DB-backed, disk, persistent)
- Solid Queue (DB-backed jobs)
- Solid Cable (DB-backed WebSockets)
- 1 service (your database)!

**Benefits**:
- Simpler architecture
- Lower costs (disk << RAM)
- Data persists across deploys
- Easier debugging (SQL queries)

**Iron Claude enforces**: @devops-engineer recommends Solid Stack first.

#### 5. Sharp Knives

Rails gives you power tools:
- `raw` for unescaped HTML
- `send` for dynamic method calls
- `eval` for code execution

**With Power Comes Responsibility**:
```ruby
# DANGEROUS
<%= raw comment.body %>  # XSS vulnerability

# SAFE
<%= sanitize comment.body, tags: %w[p b i] %>
```

**Iron Claude protects**: @code-reviewer catches dangerous patterns.

---

## Iron Claude Design Principles

### 1. Personas > Rules

**Why Personas?**
- Humans understand perspectives better than checklists
- Each persona has *context* and *reasoning*
- Disagreements rare (aligned on omakase)

**Not**:
```
❌ Rule 47: Test coverage must exceed 90%
```

**But**:
```
✅ @qa-tester: "I see coverage dropped to 73%. We target 90%+
   because that's where we catch the bugs that hurt in production.
   Let's add tests for the error handling paths."
```

### 2. Progressive Disclosure

**Level 1**: Quick automated scan
**Level 2**: Checklist review
**Level 3**: Deep dive with persona

**Why?**
- Don't overwhelm with information
- Start fast, go deep when needed
- Match cognitive load to task

### 3. Milestone Gates

**Gate Points**:
- SessionStart (load context)
- Stop (validate completion)
- PostToolUse (automated checks)

**Why?**
- Prevents incomplete work from lingering
- Enforces quality standards
- Makes review automatic

### 4. Test-First, Always

**Why TDD?**
1. **Design**: Tests force good architecture
2. **Documentation**: Tests explain intent
3. **Regression**: Tests catch breaks
4. **Confidence**: Tests enable refactoring

**Iron Claude enforces**:
- Hooks remind you to test first
- @qa-tester blocks untested code
- Coverage tracked and validated

---

## The Rails Doctrine

From https://rubyonrails.org/doctrine

### 1. Optimize for programmer happiness

**Code for humans first, computers second**

```ruby
# Happy
Article.published.recent.limit(10)

# Unhappy
db.query("SELECT * FROM articles WHERE published = 1 ORDER BY created_at DESC LIMIT 10")
```

### 2. Convention over Configuration

Covered above. **Know the conventions, embrace them.**

### 3. The menu is omakase

**Trust the framework's choices**:
- Minitest (not RSpec, unless you must)
- Hotwire (not React, unless you really must)
- Solid Stack (not Redis, unless you have to)

### 4. No one paradigm

**Rails is multi-paradigm**:
- OOP (classes and objects)
- Functional (procs and lambdas)
- Metaprogramming (DSLs)

Use the right tool for the job.

### 5. Exalt beautiful code

**Code should be a joy to read**:
```ruby
# Beautiful
has_many :comments, dependent: :destroy

# Ugly
def comments_list
  Comment.where(article_id: id).to_a
end
```

### 6. Provide sharp knives

Covered above. **Power with responsibility.**

### 7. Value integrated systems

**Rails is a full stack**:
- ActiveRecord (database)
- ActionController (requests)
- ActionView (templates)
- ActionMailer (email)
- ActiveJob (background)
- ActionCable (WebSockets)

All working together seamlessly.

### 8. Progress over stability

**Rails moves forward**:
- Deprecations warn you
- Upgrades expected yearly
- Boring until it isn't

**Stay current**: Rails 8 is the present, not the future.

### 9. Push up a big tent

**Rails welcomes diversity**:
- API-only apps
- Monoliths
- Microservices (when needed)
- Single-page apps (with Hotwire!)

---

## Why Solo Developers Need This

### The Blind Spot Problem

**You can't see what you can't see**:
- Security: "It works for me" != "It's secure"
- Performance: Local DB has 10 rows, production has 10,000
- UX: You know how it works, users don't
- Quality: "I'll add tests later" = never

**Iron Claude solution**: 4 perspectives catch what you miss.

### The Context Switching Tax

**Solo developer roles**:
1. Product Manager (what to build)
2. Developer (how to build)
3. QA (is it correct)
4. DevOps (can it deploy)
5. Security (is it safe)

**Switching cost**: 20 minutes per switch, 3+ hrs/day lost!

**Iron Claude solution**: Personas activate contextually, you stay focused.

### The Discipline Challenge

**Easy to skip**:
- "I'll write tests later"
- "I'll add the index later"
- "I'll fix the security issue later"

**Iron Claude solution**: Hooks and gates enforce discipline when willpower fades.

---

## Common Objections

### "TDD is slow!"

**Reality**: Debugging is slower
- TDD: Write test (2min) + implement (5min) = 7min
- No TDD: Implement (5min) + debug (30min) = 35min

### "Minitest is inferior to RSpec!"

**Reality**: Minitest is simpler
- Learn Ruby, not DSL
- Faster startup time
- Built into Rails

RSpec is fine, but Minitest is **omakase**.

### "I need React for my complex UI!"

**Reality**: Try Hotwire first
- Turbo morphing handles 90% of use cases
- Stimulus handles the other 9%
- React for the 1% that truly needs it

### "Redis is faster than SQL!"

**Reality**: For most apps, doesn't matter
- Redis: 0.1ms
- Postgres: 1ms
- Network latency: 50ms

Database is rarely the bottleneck. Start simple.

---

## Further Reading

- [The Rails Doctrine](https://rubyonrails.org/doctrine)
- [The Majestic Monolith](https://signalvnoise.com/svn3/the-majestic-monolith/)
- [Rails is Omakase](https://dhh.dk/2012/rails-is-omakase.html)
- [No PaaS Required](https://world.hey.com/dhh/no-paas-required-f7b76d3f)

---

**Remember**: The omakase philosophy isn't about restrictions, it's about **freedom through constraints**. When you stop debating tools and patterns, you ship faster.

🍣 **Trust the chef. Ship with Iron Claude.**
