---
description: N+1 query detection, missing indexes, and performance analysis
---

# Performance Check

Comprehensive performance analysis to identify N+1 queries, missing database indexes, slow endpoints, and optimization opportunities.

## What This Command Does

- 🐌 Detects **N+1 queries** in controllers and models
- 📊 Identifies **missing database indexes**
- ⏱️ Analyzes **slow endpoints** (> 200ms)
- 💾 Reviews **caching strategy** (Solid Cache usage)
- ⚡ Suggests **optimization opportunities**
- 📋 @devops-engineer persona provides expert recommendations

## When to Use

- ✅ Before deploying new features
- ✅ When page load feels slow
- ✅ After adding new database queries
- ✅ As part of regular performance review
- ✅ When preparing for traffic spikes

## Performance Checks

### 1. N+1 Query Detection

Scans for:
- Missing `includes`/`preload`/`eager_load`
- Queries inside loops
- Counter cache opportunities
- Select N+1 (loading unnecessary columns)

**How We Detect**:
- Analyzes controller actions
- Reviews view templates
- Simulates request with query logging
- Counts database queries per action

### 2. Missing Database Indexes

Checks for:
- Foreign keys without indexes
- WHERE clause columns without indexes
- ORDER BY columns without indexes
- Composite index opportunities
- Unique constraints without indexes

### 3. Slow Endpoint Analysis

Identifies:
- Endpoints > 200ms (should be background jobs)
- Endpoints > 100ms (caching candidates)
- Endpoints with excessive queries
- Endpoints with large data transfers

### 4. Caching Opportunities

Reviews:
- Fragment caching for expensive views
- Solid Cache configuration
- Russian Doll caching patterns
- Cache expiration strategies

### 5. Background Job Candidates

Finds operations that should be async:
- Email sending (> 500ms)
- External API calls
- Report generation
- Image processing
- Batch operations

## Example Usage

```
/performance-check
# Full performance analysis

/performance-check articles
# Check specific controller/model

/performance-check --endpoints-only
# Only analyze slow endpoints
```

## Sample Output

```markdown
# Performance Analysis Report

**Date**: 2025-11-08 15:00:00 UTC
**Environment**: Development (simulated production load)
**Scope**: All controllers and models

---

## 🔴 CRITICAL Performance Issues

### 1. N+1 Query Bomb in ArticlesController#index
**Severity**: CRITICAL
**Impact**: 1 + N queries (N = number of articles)
**Location**: `app/controllers/articles_controller.rb:6`

**Current Code**:
```ruby
def index
  @articles = Article.all  # 1 query
end
```

**View Template** (`app/views/articles/index.html.erb`):
```erb
<% @articles.each do |article| %>
  <h2><%= article.title %></h2>
  <p>By <%= article.user.name %></p>  <!-- N queries! -->
  <p><%= article.comments.count %> comments</p>  <!-- N queries! -->
<% end %>
```

**Performance Impact**:
- 10 articles = 21 queries (1 + 10 + 10)
- 100 articles = 201 queries
- 1000 articles = 2001 queries 😱

**Query Log**:
```sql
Article Load (0.3ms)  SELECT "articles".* FROM "articles"
User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 1]]
(0.2ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."article_id" = ?  [["article_id", 1]]
User Load (0.2ms)  SELECT "users".* FROM "users" WHERE "users"."id" = ? LIMIT 1  [["id", 2]]
(0.2ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."article_id" = ?  [["article_id", 2]]
... (repeats for each article)
```

**Fix**:
```ruby
def index
  @articles = Article.includes(:user).all  # Eager load user
  # Total queries: 2 (articles + users)
end

# For comments count, add counter cache:
class Comment < ApplicationRecord
  belongs_to :article, counter_cache: true
end

# Migration:
add_column :articles, :comments_count, :integer, default: 0

# Now view uses cached count (no query!)
<%= article.comments_count %>
```

**Estimated Performance Gain**:
- Before: 201 queries (100 articles)
- After: 2 queries
- **99% reduction in database queries** 🚀

**Estimated Fix Time**: 15 minutes
**Priority**: P0 - Fix immediately

---

### 2. Missing Index on Foreign Key
**Severity**: CRITICAL
**Impact**: Full table scan on articles table
**Location**: `app/models/comment.rb`

**Issue**: `comments.article_id` has no index

**Query**:
```sql
SELECT "comments".* FROM "comments" WHERE "comments"."article_id" = ?
```

**Performance Impact**:
- Without index: O(n) - scans all comments
- With index: O(log n) - instant lookup
- 10,000 comments: 150ms → 1.5ms (100x faster)

**Fix**:
```ruby
# Migration
class AddIndexToCommentsArticleId < ActiveRecord::Migration[8.0]
  def change
    add_index :comments, :article_id
  end
end
```

**Estimated Performance Gain**: 100x faster comment lookups
**Estimated Fix Time**: 2 minutes
**Priority**: P0 - Fix immediately

---

## 🟠 HIGH Priority Issues

### 3. Slow Endpoint: ArticlesController#create
**Response Time**: 1.2 seconds
**Issue**: Synchronous email delivery
**Location**: `app/controllers/articles_controller.rb:18`

**Current Code**:
```ruby
def create
  @article = current_user.articles.build(article_params)

  if @article.save
    ArticleMailer.publication_notice(@article).deliver_now  # Blocks for 1s!
    redirect_to @article
  end
end
```

**Performance Impact**:
- User waits 1.2s for page to load
- Server thread blocked during email delivery
- Poor perceived performance

**Fix**:
```ruby
def create
  @article = current_user.articles.build(article_params)

  if @article.save
    ArticleMailer.publication_notice(@article).deliver_later  # Async!
    redirect_to @article
  end
end

# Solid Queue will handle delivery in background
```

**Estimated Performance Gain**:
- Before: 1.2s response time
- After: 50ms response time
- **96% faster perceived performance** 🚀

**Estimated Fix Time**: 2 minutes (change deliver_now → deliver_later)
**Priority**: P1 - Fix before deploy

---

### 4. Missing Composite Index
**Severity**: HIGH
**Impact**: Slow filtered queries
**Location**: Articles filtered by user and published status

**Query**:
```sql
SELECT "articles".* FROM "articles"
WHERE "articles"."user_id" = ? AND "articles"."published" = ?
ORDER BY "articles"."created_at" DESC
```

**Current Indexes**:
- `articles.user_id` ✅
- `articles.published` ❌
- `articles.created_at` ❌
- Composite index ❌

**Performance Impact**:
- Using only `user_id` index, then filtering published in memory
- Not using ORDER BY index

**Fix**:
```ruby
# Migration
class AddCompositeIndexToArticles < ActiveRecord::Migration[8.0]
  def change
    add_index :articles, [:user_id, :published, :created_at]
  end
end
```

**Estimated Performance Gain**: 10x faster filtered queries
**Estimated Fix Time**: 3 minutes
**Priority**: P1 - Fix before deploy

---

## 🟡 MEDIUM Priority Issues

### 5. Missing Fragment Caching
**Severity**: MEDIUM
**Impact**: Expensive view rendering
**Location**: `app/views/articles/show.html.erb`

**Issue**: Article view renders markdown and counts on every request

**Current**:
```erb
<%= markdown article.body %>  <!-- 50ms to render -->
<%= render article.comments %>  <!-- 20ms with 10 comments -->
```

**Fix** (Russian Doll Caching):
```erb
<% cache article do %>
  <%= markdown article.body %>

  <% cache [article, "comments"] do %>
    <%= render article.comments %>
  <% end %>
<% end %>
```

**Performance Impact**:
- First request: 70ms (cache miss)
- Subsequent requests: <1ms (cache hit)
- With Solid Cache: survives deploys

**Estimated Performance Gain**: 70x faster on cache hits
**Estimated Fix Time**: 10 minutes
**Priority**: P2 - This week

---

### 6. Select N+1 (Loading Unused Columns)
**Severity**: MEDIUM
**Impact**: Transferring unnecessary data
**Location**: `app/controllers/articles_controller.rb:6`

**Issue**: Loading full `body` field (potentially large) when only showing title

**Current**:
```ruby
@articles = Article.includes(:user).all
# Loads entire article record including large body field
```

**Fix**:
```ruby
@articles = Article.includes(:user).select(:id, :title, :user_id, :created_at)
# Only loads needed columns
```

**Performance Impact**:
- Before: 500KB transferred (100 articles with large bodies)
- After: 20KB transferred
- **96% reduction in data transfer**

**Estimated Fix Time**: 5 minutes
**Priority**: P2 - This week

---

## ✅ PASSED Checks

- ✅ Solid Queue configured for background jobs
- ✅ Solid Cache enabled
- ✅ No database queries in loops (except issue #1)
- ✅ Foreign keys have indexes (except issue #2)
- ✅ Using eager loading in most places
- ✅ Counter caches for associations (where implemented)
- ✅ Database connection pool sized appropriately

---

## 📊 Performance Metrics

### Query Analysis
- **Total Controllers Analyzed**: 12
- **N+1 Queries Found**: 3
- **Average Queries per Action**: 4.2
- **Max Queries in Single Action**: 21 (ArticlesController#index)

### Index Analysis
- **Tables Analyzed**: 8
- **Missing Foreign Key Indexes**: 2
- **Missing Filter Indexes**: 4
- **Composite Index Opportunities**: 3

### Endpoint Performance
- **Fast (< 100ms)**: 18 endpoints ✅
- **Acceptable (100-200ms)**: 5 endpoints ⚠️
- **Slow (> 200ms)**: 2 endpoints ❌

### Caching
- **Fragment Caching**: Used in 40% of views
- **Russian Doll Pattern**: Used in 20% of views
- **Solid Cache Hit Rate**: 85%
- **Caching Opportunities**: 6 views

---

## 📋 Prioritized Action Plan

### P0 - Immediate (Next 30min)
1. Fix N+1 in ArticlesController#index (15min)
2. Add index to comments.article_id (2min)
3. Add index to articles.user_id if missing (2min)

### P1 - Before Deploy (Next Hour)
4. Move email delivery to background (2min)
5. Add composite index for filtered queries (3min)
6. Review other endpoints for N+1 (30min)

### P2 - This Week
7. Add fragment caching to article views (10min)
8. Implement Select N+1 fix (5min)
9. Add counter caches where appropriate (20min)

**Total Estimated Fix Time**: 2 hours
**Estimated Performance Improvement**: 10x faster average response time

---

## Optimization Recommendations (@devops-engineer)

### Database
```ruby
# Add these indexes:
add_index :comments, :article_id
add_index :articles, [:user_id, :published, :created_at]
add_index :articles, :created_at  # For global recent articles

# Add counter caches:
add_column :articles, :comments_count, :integer, default: 0
add_column :users, :articles_count, :integer, default: 0
```

### Caching Strategy
```ruby
# Solid Cache configuration
config.cache_store = :solid_cache_store, {
  database: { writing: :cache },
  expires_in: 1.day,
  max_size: 10.gigabytes
}

# Russian Doll caching pattern
<% cache [article, article.comments.maximum(:updated_at)] do %>
  <%= render article %>
<% end %>
```

### Background Jobs
```ruby
# Move to Solid Queue:
ArticleMailer.publication_notice(@article).deliver_later
ReportGenerationJob.perform_later(report_id)
ImageProcessingJob.perform_later(image_id)
```

---

## Next Steps

1. Fix P0 issues immediately
2. Run `/performance-check` again to validate
3. Monitor production metrics after deploy
4. Schedule monthly performance reviews
5. Add performance tests to catch regressions

**Fast software is a feature. Slow software loses users.**
```

## Configuration

`.iron-claude/config.json`:
```json
{
  "performance": {
    "slowEndpointThreshold": 200,
    "maxQueriesPerAction": 10,
    "enableN1Detection": true,
    "enableIndexAnalysis": true,
    "blockOnCritical": true
  }
}
```

## CI/CD Integration

```yaml
# .github/workflows/performance.yml
name: Performance Check

on: [pull_request]

jobs:
  performance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
      - run: bundle install
      - run: /performance-check
      - name: Block if performance issues
        if: failure()
        run: exit 1
```

---

**Remember**: Performance isn't just about speed - it's about user experience. Every 100ms delay costs you users.
