---
description: Pre-deployment checklist and validation - zero-downtime deploy readiness
---

# Pre-Deploy

Comprehensive pre-deployment validation to ensure your Rails 8 app is ready for production with zero downtime and no surprises.

## What This Command Does

This command performs a systematic pre-deployment check across all critical areas:

- ✅ Test suite and coverage validation
- ✅ Security audit (Brakeman, bundle audit)
- ✅ Performance analysis (N+1 queries, missing indexes)
- ✅ Kamal deployment configuration
- ✅ Database migration safety
- ✅ Health check functionality
- ✅ Solid Stack configuration
- ✅ Environment variables and secrets

**Result**: Clear GO/NO-GO recommendation with specific blockers if any.

## When to Use

- ✅ Before deploying to production
- ✅ Before merging to main/master branch
- ✅ As part of CI/CD pipeline
- ✅ After major refactoring
- ✅ Before tagging a release

## The Pre-Deploy Checklist

### 1. Test Suite Status (@qa-tester)

```bash
# Automatically runs:
bundle exec rails test
```

**Validates**:

- [ ] All tests passing (0 failures, 0 errors)
- [ ] Test coverage ≥ 90% (SimpleCov)
- [ ] No skipped or pending tests
- [ ] System tests for critical paths

**Blocks if**:

- Any test failures
- Coverage < 90%
- Critical paths untested

### 2. Security Audit (@code-reviewer)

```bash
# Automatically runs:
bundle exec brakeman --quiet
bundle audit check --update
```

**Validates**:

- [ ] No known security vulnerabilities
- [ ] Dependencies up to date
- [ ] Strong Parameters implemented
- [ ] CSRF protection enabled
- [ ] No secrets in code
- [ ] Authorization checks present

**Blocks if**:

- High/critical Brakeman warnings
- Known CVEs in dependencies
- Missing authorization

### 3. Performance Check (@devops-engineer)

```bash
# Analyzes:
- N+1 queries in critical paths
- Missing database indexes
- Slow endpoints (> 200ms)
- Background job configuration
```

**Validates**:

- [ ] No N+1 query bombs
- [ ] Database indexes for foreign keys
- [ ] Indexes for WHERE/ORDER BY columns
- [ ] Fragment caching for expensive views
- [ ] Background jobs for slow operations

**Blocks if**:

- Critical N+1 queries detected
- Missing indexes on high-traffic queries

### 4. Kamal Configuration (@devops-engineer)

```bash
# Validates config/deploy.yml
```

**Checks**:

- [ ] Service name and image defined
- [ ] Server hosts configured
- [ ] Health check path set (e.g., `/up`)
- [ ] Health check timeout appropriate
- [ ] Deploy timeout sufficient for asset compilation
- [ ] Drain timeout set (minimum 30s)
- [ ] Registry credentials configured
- [ ] Environment variables complete

**Blocks if**:

- No health check configured
- Missing required environment variables
- Invalid deploy configuration

### 5. Database Migrations (@devops-engineer + @code-reviewer)

```bash
# Analyzes pending migrations
bundle exec rails db:migrate:status
```

**Validates**:

- [ ] Migrations are reversible
- [ ] No destructive operations without safety measures
- [ ] No `remove_column` without coordination
- [ ] Foreign keys and indexes added
- [ ] Migration tested on production-like data

**Blocks if**:

- Irreversible migrations
- Potential data loss without confirmation
- Table locks on large tables

### 6. Health Check Endpoint (@devops-engineer)

```bash
# Tests health check locally
curl http://localhost:3000/up
```

**Validates**:

- [ ] Health check responds < 1 second
- [ ] Returns 200 for healthy state
- [ ] Validates database connection
- [ ] Checks Solid Queue connectivity
- [ ] Verifies cache availability

**Blocks if**:

- Health check missing or broken
- Response time > 1 second
- Doesn't check critical services

### 7. Solid Stack Configuration (@devops-engineer)

**Validates**:

- [ ] Solid Queue configured for job types
- [ ] Solid Cache sized appropriately
- [ ] Solid Cable set up for WebSockets
- [ ] Database connections configured
- [ ] Worker processes defined

**Warns if**:

- Shared database might need performance tuning
- Cache size might be insufficient

### 8. Asset Precompilation (@devops-engineer)

```bash
# Test asset compilation
RAILS_ENV=production bundle exec rails assets:precompile
```

**Validates**:

- [ ] Assets compile without errors
- [ ] Propshaft configuration correct
- [ ] Importmap dependencies resolved
- [ ] CSS and JS bundles generated

**Blocks if**:

- Asset compilation fails

### 9. Rollback Plan (@devops-engineer)

**Validates**:

- [ ] Previous deployment version recorded
- [ ] Rollback command documented
- [ ] Database rollback strategy defined
- [ ] Monitoring and alerts configured

**Warns if**:

- No documented rollback procedure

## Example Usage

```
# Basic pre-deploy check
/pre-deploy

# Pre-deploy for specific environment
/pre-deploy staging

# Pre-deploy with detailed output
/pre-deploy --verbose

# Skip specific checks (use cautiously!)
/pre-deploy --skip security
```

## Sample Output

```markdown
# Pre-Deployment Report

**Target Environment**: Production
**Branch**: main
**Commit**: a1b2c3d (feat: Add user authentication)
**Timestamp**: 2025-11-08 14:30:00 UTC

---

## ✅ All Checks Passed

### 1. Test Suite Status
- ✅ 187 tests, 0 failures, 0 errors
- ✅ Coverage: 94.2% (target: 90%)
- ✅ System tests cover critical paths
- ⏱️  Test suite runtime: 23.4s

### 2. Security Audit
- ✅ Brakeman: No security warnings
- ✅ Bundle Audit: All dependencies clean
- ✅ Strong Parameters implemented
- ✅ CSRF protection enabled
- ✅ Secrets in credentials.yml.enc

### 3. Performance Check
- ✅ No N+1 queries detected
- ✅ All foreign keys indexed
- ✅ Fragment caching configured
- ✅ Background jobs for email delivery

### 4. Kamal Configuration
- ✅ Health check: /up (timeout: 10s)
- ✅ Deploy timeout: 300s
- ✅ Drain timeout: 30s
- ✅ Registry: ghcr.io configured
- ✅ Environment variables complete

### 5. Database Migrations
- ✅ 3 pending migrations (all reversible)
- ✅ No destructive operations
- ✅ Indexes added for new columns
- ✅ Tested on staging data

### 6. Health Check
- ✅ Responds in 142ms
- ✅ Database connection validated
- ✅ Solid Queue operational
- ✅ Cache accessible

### 7. Solid Stack
- ✅ Solid Queue: 3 worker processes
- ✅ Solid Cache: 10GB limit
- ✅ Solid Cable: Configured
- ✅ Dedicated database for queue/cache

### 8. Asset Precompilation
- ✅ Assets compile successfully
- ✅ Propshaft configuration valid
- ✅ Total size: 2.3MB (gzipped: 512KB)

### 9. Rollback Plan
- ✅ Previous version: v1.2.4
- ✅ Rollback command documented
- ✅ Monitoring alerts configured

---

## 🚀 Deployment Recommendation

**STATUS**: ✅ **GO FOR DEPLOYMENT**

**Confidence Level**: HIGH

**Estimated Deploy Time**: ~5 minutes
- Build: ~2min
- Health check: ~30s
- Traffic shift: ~1min
- Drain: ~30s

**Rollback Time**: ~2 minutes (if needed)

## Deployment Commands

```bash
# 1. Commit and push
git push origin main

# 2. Deploy with Kamal
kamal deploy

# 3. Monitor deployment
kamal app logs -f

# 4. Verify health
curl https://myapp.com/up

# 5. (If needed) Rollback
kamal rollback
```

## Post-Deployment Checklist

After deployment, verify:

- [ ] Health check returns 200
- [ ] Critical user flows work
- [ ] Database migrations applied
- [ ] Background jobs processing
- [ ] No error spike in logs
- [ ] Performance metrics normal

---

**Ready to deploy?** Run `kamal deploy` 🚢

```

## When Deployment is Blocked

If any checks fail, you'll see:

```markdown
## ❌ DEPLOYMENT BLOCKED

**Blockers Found**: 3

### ❌ 1. Test Failures
- 2 failing tests in `test/controllers/users_controller_test.rb`
- Fix: Address test failures before deploying

### ❌ 2. Security Vulnerability
- Brakeman: SQL Injection in ArticlesController#search
- Severity: HIGH
- Fix: Use parameterized queries

### ❌ 3. Missing Health Check
- No /up endpoint configured
- Health check required for zero-downtime deployment
- Fix: Add health check route and controller

---

**STATUS**: ❌ **NO-GO - Fix 3 blockers**

**Estimated Fix Time**: 30-60 minutes

**Next Steps**:
1. Fix failing tests
2. Address SQL injection vulnerability
3. Add health check endpoint
4. Re-run /pre-deploy to validate
```

## Integration with CI/CD

### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Pre-Deploy Check

on:
  pull_request:
    branches: [main]

jobs:
  pre-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
      - name: Install dependencies
        run: bundle install
      - name: Run Iron Claude pre-deploy
        run: claude run /pre-deploy
      - name: Block merge if failed
        if: failure()
        run: exit 1
```

## Configuration

Customize thresholds in `.iron-claude/config.json`:

```json
{
  "preDeploy": {
    "minCoverage": 90,
    "maxHealthCheckTime": 1000,
    "requireSystemTests": true,
    "blockOnBrakemanWarnings": ["high", "critical"],
    "blockOnFailedTests": true,
    "requireRollbackPlan": true
  }
}
```

## Tips

1. **Run Early, Run Often** - Don't wait until deployment day
2. **Fix Blockers Immediately** - Don't accumulate technical debt
3. **Automate in CI** - Catch issues before they reach deployment
4. **Test Rollback** - Practice rollback procedure before you need it
5. **Monitor After Deploy** - Watch metrics for 30 minutes post-deploy

---

**Remember**: A few minutes of pre-deploy validation saves hours of production firefighting. Deploy with confidence, not hope.
