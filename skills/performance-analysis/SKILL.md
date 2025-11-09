# Performance Analysis Skill

Deep performance analysis for Rails 8 applications focusing on N+1 queries, indexing, and caching strategies.

## Skill Overview

Progressive disclosure skill for identifying and fixing performance issues in Rails apps with Solid Stack.

## When to Use

- N+1 query detection needed
- Slow endpoint investigation
- Database index optimization
- Caching strategy review
- Pre-deployment performance check

## Progressive Disclosure Flow

### Level 1: Quick Scan

- Run query analysis script
- Count queries per action
- Identify obvious N+1 patterns

### Level 2: Index Analysis

- Check foreign keys for indexes
- Review WHERE clause columns
- Identify composite index opportunities

### Level 3: Deep Optimization (On Request)

- Fragment caching opportunities
- Counter cache recommendations
- Background job candidates
- Solid Cache configuration review

## Tools Available

### Query Analyzer

```bash
./scripts/analyze-queries.sh
```

## Integration

- `/performance-check` command
- `@devops-engineer` persona
- Pre-deploy validation

## Output Format

```markdown
## Performance Analysis

### N+1 Queries Found: X
[Details]

### Missing Indexes: X
[Recommendations]

### Optimization Opportunities
[Specific fixes with code examples]
```
