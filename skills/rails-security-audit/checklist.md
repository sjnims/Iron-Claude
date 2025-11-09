# Rails Security Review Checklist

Comprehensive security review checklist based on OWASP Top 10 and Rails best practices.

## Authentication

### Password Security

- [ ] Using `has_secure_password` (bcrypt)
- [ ] Minimum password length (12+ characters recommended)
- [ ] Password complexity requirements (if needed)
- [ ] Account lockout after failed attempts
- [ ] Password reset tokens expire (1-2 hours)
- [ ] Password reset tokens single-use only

### Session Management

- [ ] Session timeout configured (2 hours max recommended)
- [ ] Secure cookie flag in production
- [ ] HTTPOnly cookie flag set
- [ ] SameSite cookie attribute configured
- [ ] Session fixation protection (Rails default)
- [ ] CSRF protection enabled (Rails default)

### Multi-Factor Authentication (if applicable)

- [ ] TOTP/SMS properly implemented
- [ ] Backup codes provided
- [ ] Rate limiting on MFA attempts

## Authorization

### Access Control

- [ ] Authorization checks on all protected actions
- [ ] Users can only access own resources
- [ ] Admin actions require admin role
- [ ] Using authorization library (Pundit/CanCanCan)
- [ ] Authorization policies tested

### Privilege Escalation

- [ ] Role changes require admin approval
- [ ] No client-side role checks only
- [ ] Admin functions not accessible via direct URL

## Input Validation

### Mass Assignment

- [ ] Strong Parameters used in all controllers
- [ ] Only whitelisted attributes permitted
- [ ] Nested attributes properly filtered
- [ ] No `params.permit!` (permits all)

### SQL Injection

- [ ] No string interpolation in WHERE clauses
- [ ] Using parameterized queries
- [ ] ActiveRecord query interface used
- [ ] Raw SQL uses bind parameters

### Cross-Site Scripting (XSS)

- [ ] Output escaped by default (Rails default)
- [ ] `raw` and `html_safe` used cautiously
- [ ] User content sanitized (if HTML allowed)
- [ ] JSON responses escaped

### Command Injection

- [ ] No unsanitized user input in system calls
- [ ] Avoiding `eval`, `send` with user input
- [ ] File uploads validated and scoped

## Data Protection

### Secrets Management

- [ ] API keys in `credentials.yml.enc`, not ENV
- [ ] Master key not in version control
- [ ] Secrets not logged
- [ ] Parameter filtering configured

### Sensitive Data

- [ ] PII encrypted at rest (if applicable)
- [ ] Credit cards not stored (use Stripe/payment gateway)
- [ ] Passwords never logged
- [ ] Sensitive fields filtered in logs

### HTTPS/TLS

- [ ] force_ssl enabled in production
- [ ] HSTS header configured
- [ ] Valid SSL certificate
- [ ] Redirects HTTP → HTTPS

## Database Security

### Migrations

- [ ] No irreversible data loss
- [ ] Sensitive data migrated securely
- [ ] Proper foreign key constraints

### Database Access

- [ ] Database user has minimal permissions
- [ ] Database not publicly accessible
- [ ] Connection over SSL (if remote)

## File Uploads

### Validation

- [ ] File type whitelist (not blacklist)
- [ ] File size limits enforced
- [ ] Filename sanitized
- [ ] Virus scanning (if applicable)

### Storage

- [ ] Files not executable
- [ ] Uploaded files outside webroot (or via CDN)
- [ ] Access control on file downloads

## API Security (if applicable)

### Authentication

- [ ] API keys/tokens properly secured
- [ ] Token expiration implemented
- [ ] CORS configured correctly

### Rate Limiting

- [ ] Rate limiting on authentication endpoints
- [ ] Rate limiting on expensive operations
- [ ] DDoS protection configured

## Dependencies

### Gem Security

- [ ] Bundle Audit passing (no known CVEs)
- [ ] Dependencies up to date
- [ ] Unmaintained gems removed

### Supply Chain

- [ ] Gemfile.lock committed
- [ ] Trusted gem sources only

## Logging & Monitoring

### Security Events

- [ ] Failed login attempts logged
- [ ] Authorization failures logged
- [ ] Suspicious activity alerted

### Log Security

- [ ] Passwords filtered from logs
- [ ] API keys filtered from logs
- [ ] PII filtered from logs

## Rails Configuration

### Production Settings

- [ ] `config.force_ssl = true`
- [ ] `config.action_dispatch.show_exceptions = false`
- [ ] `config.consider_all_requests_local = false`

### Security Headers

- [ ] X-Frame-Options set (clickjacking protection)
- [ ] X-Content-Type-Options set
- [ ] X-XSS-Protection set (legacy browsers)
- [ ] Content-Security-Policy configured

## Testing

### Security Tests

- [ ] Authentication tests comprehensive
- [ ] Authorization tests for all roles
- [ ] Input validation tested
- [ ] Negative test cases (malicious input)

## Omakase Stack Specific

### Solid Queue

- [ ] Job payloads don't contain secrets
- [ ] Failed jobs reviewed for sensitive data leaks

### Solid Cache

- [ ] Cached data doesn't include secrets
- [ ] Cache invalidation on permission changes

## Post-Deployment

### Monitoring

- [ ] Error tracking configured (Sentry/Honeybadger)
- [ ] Uptime monitoring configured
- [ ] Security alerts configured

### Incident Response

- [ ] Security incident plan documented
- [ ] Contact information for security issues

## Scoring

- **Critical**: All Authentication, Authorization, Input Validation items
- **High**: Data Protection, Database Security, File Uploads
- **Medium**: API Security, Dependencies, Logging
- **Low**: Testing, Monitoring

**Target**: 100% of Critical items, 95%+ of High items
