# Rails Security Audit Skill

Comprehensive security auditing for Rails 8 applications with automated scanning and progressive disclosure.

## Skill Overview

This skill provides deep security expertise for Rails applications, combining automated tools (Brakeman, Bundle Audit) with expert manual review patterns.

## When to Use

- Reviewing authentication/authorization code
- Auditing user input handling
- Checking for OWASP Top 10 vulnerabilities
- Pre-deployment security validation
- After adding new dependencies

## Progressive Disclosure Flow

### Level 1: Quick Scan (Automatic)
- Run Brakeman static analysis
- Run Bundle Audit for CVEs
- Report critical issues only

### Level 2: Manual Review Checklist
- Load security checklist.md
- Review Strong Parameters usage
- Check authorization implementation
- Verify secrets management

### Level 3: Deep Dive (On Request)
- Detailed code review by @code-reviewer persona
- Custom vulnerability patterns
- Security best practices recommendations

## Tools Available

### Brakeman Scanner
```bash
./scripts/brakeman.sh
```
Automated Rails security scanner

### Security Checklist
```markdown
checklist.md
```
Comprehensive manual review checklist

## Integration

This skill works with:
- `/security-audit` command
- `@code-reviewer` persona
- Pre-deploy hooks
- CI/CD security gates

## Example Invocation

User request: "Review my authentication code for security issues"

**Skill response**:
1. Run Brakeman on authentication files
2. Load and review against checklist
3. Provide specific recommendations
4. Escalate to @code-reviewer if complex

## Output Format

```markdown
## Security Audit Results

### Automated Scan (Brakeman)
- [List of findings]

### Manual Review
- [Checklist items marked complete/incomplete]

### Recommendations
- [Prioritized fixes]
```
