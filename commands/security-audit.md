---
description: Comprehensive security audit with automated Brakeman scan and manual review
---

# Security Audit

Comprehensive security audit combining automated vulnerability scanning with expert manual review from the Code Reviewer persona.

## What This Command Does

- 🔍 Runs **Brakeman** (static analysis security scanner)
- 🔍 Runs **Bundle Audit** (dependency vulnerability check)
- 🔍 Manual code review by **@code-reviewer** persona
- 📋 Generates prioritized security report
- ⚠️ Blocks if high/critical vulnerabilities found

## When to Use

- ✅ Before deploying to production
- ✅ After adding new dependencies
- ✅ When handling sensitive data (auth, payments, PII)
- ✅ As part of regular security hygiene (weekly/monthly)
- ✅ After security-related code changes

## Security Checks Performed

### 1. Brakeman Static Analysis

Scans for:
- SQL Injection
- Cross-Site Scripting (XSS)
- Command Injection
- Mass Assignment
- Dangerous Send
- File Access
- Cross-Site Request Forgery (CSRF)
- Insecure Redirects
- Unsafe Deserialization

### 2. Dependency Vulnerabilities

Checks:
- Known CVEs in gems
- Outdated dependencies with security patches
- Unmaintained gems with known issues

### 3. Manual Code Review (@code-reviewer)

Reviews:
- Strong Parameters usage
- Authorization checks
- Authentication security (password hashing, session management)
- Secrets management (credentials.yml.enc)
- Input validation
- Rate limiting
- CORS configuration
- Cookie security flags

## Example Usage

```
/security-audit
# Full security audit

/security-audit --quick
# Skip manual review, automated scans only

/security-audit --verbose
# Detailed output with code examples
```

## Sample Output

```markdown
# Security Audit Report

**Scan Date**: 2025-11-08 14:45:00 UTC
**Branch**: main
**Commit**: a1b2c3d

---

## 🔴 CRITICAL Issues (Must Fix Immediately)

### 1. SQL Injection in ArticlesController#search
**Severity**: CRITICAL
**Location**: `app/controllers/articles_controller.rb:42`
**Detected By**: Brakeman

**Vulnerable Code**:
```ruby
def search
  @articles = Article.where("title LIKE '%#{params[:q]}%'")
end
```

**Exploitation Risk**: HIGH
An attacker could inject SQL to:
- Extract all database data
- Modify records
- Drop tables
- Bypass authentication

**Example Attack**:
```
?q='; DROP TABLE users; --
```

**Fix**:
```ruby
def search
  @articles = Article.where("title LIKE ?", "%#{params[:q]}%")
end
```

**Estimated Fix Time**: 5 minutes
**Priority**: P0 - IMMEDIATE

---

### 2. Mass Assignment Vulnerability in UsersController
**Severity**: CRITICAL
**Location**: `app/controllers/users_controller.rb:18`
**Detected By**: @code-reviewer

**Vulnerable Code**:
```ruby
def update
  @user = User.find(params[:id])
  @user.update(params[:user])  # No Strong Parameters!
end
```

**Exploitation Risk**: HIGH
Attacker could:
- Elevate privileges (set admin: true)
- Modify other users' data
- Bypass payment status

**Fix**:
```ruby
def update
  @user = User.find(params[:id])
  @user.update(user_params)
end

private

def user_params
  params.require(:user).permit(:name, :email)
end
```

**Estimated Fix Time**: 10 minutes
**Priority**: P0 - IMMEDIATE

---

## 🟠 HIGH Priority Issues (Fix Before Deploy)

### 3. XSS Vulnerability in Comments
**Severity**: HIGH
**Location**: `app/views/comments/_comment.html.erb:5`
**Detected By**: Brakeman

**Vulnerable Code**:
```erb
<%= raw comment.body %>
```

**Exploitation Risk**: MEDIUM-HIGH
Attacker could:
- Inject JavaScript to steal cookies
- Redirect users to phishing sites
- Deface the page

**Fix**:
```erb
<%= sanitize comment.body, tags: %w[p b i strong em], attributes: %w[href] %>
```

**Estimated Fix Time**: 15 minutes
**Priority**: P1 - Before Deploy

---

### 4. Missing Authorization Check
**Severity**: HIGH
**Location**: `app/controllers/articles_controller.rb:28`
**Detected By**: @code-reviewer

**Vulnerable Code**:
```ruby
def destroy
  @article = Article.find(params[:id])
  @article.destroy
  # Any user can delete any article!
end
```

**Fix**:
```ruby
def destroy
  @article = current_user.articles.find(params[:id])
  @article.destroy
end

# Or with Pundit:
def destroy
  @article = Article.find(params[:id])
  authorize @article
  @article.destroy
end
```

**Estimated Fix Time**: 10 minutes
**Priority**: P1 - Before Deploy

---

## 🟡 MEDIUM Priority Issues (Should Fix Soon)

### 5. Insecure Session Configuration
**Severity**: MEDIUM
**Location**: `config/initializers/session_store.rb`
**Detected By**: @code-reviewer

**Issue**: Session timeout is 2 weeks, no secure flag

**Current**:
```ruby
Rails.application.config.session_store :cookie_store
```

**Recommended**:
```ruby
Rails.application.config.session_store :cookie_store,
  expire_after: 2.hours,
  secure: Rails.env.production?,
  httponly: true,
  same_site: :lax
```

**Estimated Fix Time**: 5 minutes
**Priority**: P2 - This Week

---

### 6. No Rate Limiting
**Severity**: MEDIUM
**Location**: Authentication endpoints
**Detected By**: @code-reviewer

**Issue**: Login endpoint vulnerable to brute force attacks

**Fix**: Add Rack::Attack
```ruby
# Gemfile
gem 'rack-attack'

# config/initializers/rack_attack.rb
Rack::Attack.throttle('login/email', limit: 5, period: 60) do |req|
  req.params['email'] if req.path == '/login' && req.post?
end
```

**Estimated Fix Time**: 20 minutes
**Priority**: P2 - This Week

---

## ✅ PASSED Checks

- ✅ CSRF protection enabled
- ✅ Password hashing with bcrypt
- ✅ Secrets in credentials.yml.enc (not ENV)
- ✅ No known CVEs in dependencies
- ✅ Secure cookie flags in production
- ✅ SQL injection protection (except issue #1)
- ✅ Strong Parameters in most controllers

---

## 📊 Summary

**Total Issues**: 6
- 🔴 Critical: 2 (MUST FIX NOW)
- 🟠 High: 2 (FIX BEFORE DEPLOY)
- 🟡 Medium: 2 (FIX THIS WEEK)
- ✅ Passed: 7 checks

**Overall Risk Level**: 🔴 **HIGH**

**Recommendation**: ❌ **DO NOT DEPLOY** until critical and high issues are resolved.

**Estimated Total Fix Time**: 1 hour

---

## Action Plan

### Immediate (Next 30min)
1. Fix SQL injection in ArticlesController#search (5min)
2. Add Strong Parameters to UsersController (10min)
3. Sanitize comment body HTML (15min)

### Before Deploy (Next 30min)
4. Add authorization check to ArticlesController#destroy (10min)
5. Review other controllers for missing authorization (20min)

### This Week
6. Configure secure session settings (5min)
7. Implement rate limiting with Rack::Attack (20min)
8. Security team review (optional)

---

## Automated Scan Output

### Brakeman
```
Brakeman 6.1.2
Rails 8.0.0

== Warnings ==

Confidence: High
Category: SQL Injection
Message: Possible SQL injection
Code: Article.where("title LIKE '%#{params[:q]}%'")
File: app/controllers/articles_controller.rb
Line: 42
```

### Bundle Audit
```
Name: rack
Version: 2.2.8
CVE: CVE-2024-XXXXX
Criticality: High
URL: https://nvd.nist.gov/vuln/detail/CVE-2024-XXXXX
Solution: upgrade to ~> 2.2.9
```

---

## Next Steps

1. Fix critical issues immediately
2. Run `/security-audit` again to validate fixes
3. Add to CI/CD pipeline
4. Schedule monthly security audits

**Security is not optional. Fix these issues before deploying.**
```

## Configuration

`.iron-claude/config.json`:
```json
{
  "security": {
    "blockOnCritical": true,
    "blockOnHigh": true,
    "brakemanConfidence": ["high", "medium"],
    "bundleAuditSeverity": ["critical", "high"],
    "manualReviewEnabled": true
  }
}
```

## CI/CD Integration

```yaml
# .github/workflows/security.yml
name: Security Audit

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
      - run: gem install brakeman bundler-audit
      - run: /security-audit
      - name: Block if vulnerabilities
        if: failure()
        run: exit 1
```

---

**Remember**: Security vulnerabilities compound over time. Fix them when they're small, before they become breaches.
