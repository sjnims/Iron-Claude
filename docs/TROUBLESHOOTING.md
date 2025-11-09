# Troubleshooting

Common issues and solutions when using Iron Claude.

## Installation Issues

### Plugin Not Found

**Symptom**:
```bash
claude plugin install iron-claude
# Error: Plugin 'iron-claude' not found
```

**Solution**:
```bash
# Install from local directory
git clone https://github.com/yourusername/iron-claude.git
claude plugin install ./iron-claude

# Verify installation
claude plugin list
```

### Plugin Fails to Load

**Symptom**:
```
Error loading plugin: iron-claude
```

**Check**:
1. Valid `plugin.json` format
```bash
jq . iron-claude/.claude-plugin/plugin.json
```

2. All required files present
```bash
ls -la iron-claude/.claude-plugin/
ls -la iron-claude/agents/
ls -la iron-claude/commands/
```

3. Scripts are executable
```bash
chmod +x iron-claude/hooks/scripts/*.sh
chmod +x iron-claude/skills/*/scripts/*.sh
```

---

## Personas Not Responding

### Persona Doesn't Activate

**Symptom**:
```
@product-manager review this UX
# No response
```

**Solutions**:

1. **Check invocation syntax**
```
✅ @product-manager review this
✅ /review-feature
❌ product-manager review this  # Missing @
❌ @pm review this  # Wrong name
```

2. **Verify persona files exist**
```bash
ls iron-claude/agents/
# Should show: product-manager.md, devops-engineer.md, qa-tester.md, code-reviewer.md
```

3. **Check plugin.json references agents**
```json
{
  "agents": ["agents/"]  // Must be present
}
```

### Persona Gives Generic Responses

**Symptom**: Persona doesn't use specialized knowledge

**Solution**: Provide context
```
# Vague
@devops-engineer help

# Specific
@devops-engineer review my Kamal deployment config for zero-downtime deploys
Files: config/deploy.yml
Concern: Health checks timing out
```

---

## Hooks Not Running

### PostToolUse Hook Doesn't Fire

**Symptom**: RuboCop doesn't auto-format, tests don't run after edits

**Check**:

1. **Hook configuration**
```bash
cat iron-claude/hooks/hooks.json
# Should have PostToolUse section
```

2. **Scripts are executable**
```bash
ls -la iron-claude/hooks/scripts/
# Should show -rwxr-xr-x (executable)

chmod +x iron-claude/hooks/scripts/*.sh
```

3. **Script paths correct**
```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/hooks/scripts/rubocop-check.sh"
  // Not: "./hooks/scripts/rubocop-check.sh"
}
```

### Stop Hook Doesn't Block

**Symptom**: Session ends without milestone validation

**Check**:

1. **Hook configuration has Stop section**
```bash
jq '.hooks.Stop' iron-claude/hooks/hooks.json
```

2. **Prompt returns blocking decision**
```json
{
  "decision": "block",  // Must be "block" to prevent ending
  "reason": "Tests not written"
}
```

3. **Milestone context loaded**
```bash
# SessionStart should load milestone
cat .iron-claude/milestone.json
```

---

## Command Issues

### Command Not Found

**Symptom**:
```
/review-feature
# Command not found
```

**Solutions**:

1. **Check command files exist**
```bash
ls iron-claude/commands/
# Should show: review-feature.md, pre-deploy.md, etc.
```

2. **Verify plugin.json references commands**
```json
{
  "commands": ["commands/"]
}
```

3. **Reload plugin**
```bash
claude plugin reload iron-claude
```

### Command Doesn't Invoke Personas

**Symptom**: `/review-feature` runs but doesn't invoke personas

**Check command file format**:
```markdown
---
description: Command description
---

# Command Name

Invoke personas: @qa-tester, @code-reviewer, @devops-engineer, @product-manager
```

---

## GitHub Integration

### MCP Server Not Connecting

**Symptom**:
```
Error: GitHub MCP server failed to start
```

**Solutions**:

1. **Check GITHUB_TOKEN set**
```bash
echo $GITHUB_TOKEN
# Should show: ghp_xxxxx

# If empty:
export GITHUB_TOKEN="your_token_here"
```

2. **Install GitHub MCP server**
```bash
npx @modelcontextprotocol/server-github
```

3. **Verify .mcp.json**
```bash
cat iron-claude/.mcp.json
# Should reference github server
```

### PR Reviews Not Working

**Symptom**: No automated PR comments

**Check**:

1. **GitHub App installed on repo**
2. **Workflow file configured**
3. **Secrets set in repository settings**
   - `GITHUB_TOKEN`
   - `ANTHROPIC_API_KEY`

---

## Test-Related Issues

### RuboCop Fails

**Symptom**:
```
RuboCop: Too many offenses detected
```

**Solutions**:

1. **Auto-generate config**
```bash
bundle exec rubocop --auto-gen-config
```

2. **Auto-fix offenses**
```bash
bundle exec rubocop --auto-correct-all
```

3. **Disable specific cops** (.rubocop.yml)
```yaml
AllCops:
  NewCops: enable
  Exclude:
    - 'db/**/*'
    - 'bin/**/*'
```

### Tests Don't Run

**Symptom**: PostToolUse hook doesn't run tests

**Check**:

1. **Rails project with bin/rails**
```bash
ls bin/rails
# Should exist
```

2. **Test file naming**
```bash
# Correct: *_test.rb or *_spec.rb
test/models/user_test.rb  ✅
test/models/user.rb  ❌
```

3. **Test dependencies**
```bash
bundle install
```

---

## Performance Issues

### Brakeman Scan Slow

**Symptom**: Security audit takes > 2 minutes

**Solutions**:

1. **Exclude unnecessary paths**
```ruby
# config/brakeman.yml
skip_files:
  - node_modules/
  - vendor/
```

2. **Use confidence filter**
```bash
brakeman --confidence-level 2  # High only
```

### Hooks Slow Down Workflow

**Symptom**: Each file save takes 10+ seconds

**Solutions**:

1. **Optimize test suite**
```ruby
# Parallelize tests
class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
end
```

2. **Skip hooks temporarily** (emergency only!)
```bash
export IRON_CLAUDE_SKIP_HOOKS=true
```

3. **Adjust timeouts**
```json
{
  "hooks": {
    "PostToolUse": [{
      "timeout": 10  // Reduce from 30
    }]
  }
}
```

---

## Configuration Issues

### Milestone Not Loading

**Symptom**: SessionStart doesn't show milestone context

**Check**:

1. **Milestone file exists**
```bash
cat .iron-claude/milestone.json
# Should contain milestone data
```

2. **Script executable**
```bash
chmod +x iron-claude/hooks/scripts/load-milestone.sh
```

3. **jq installed** (for parsing JSON)
```bash
brew install jq  # macOS
sudo apt-get install jq  # Linux
```

### Personas Too Strict

**Symptom**: Every commit blocked by Code Reviewer

**Customize**:
```json
// .iron-claude/config.json
{
  "review": {
    "blockOnWarnings": false,  // Only block on critical
    "enabledPersonas": ["qa-tester"]  // Disable others
  }
}
```

---

## Deployment Issues

### Kamal Health Check Fails

**Symptom**:
```
Health check failed: connection refused
```

**Solutions**:

1. **Verify health endpoint**
```ruby
# config/routes.rb
get "up" => "rails/health#show"
```

2. **Check app_port in deploy.yml**
```yaml
proxy:
  app_port: 3000  # Not 80!
```

3. **Test locally**
```bash
rails s
curl http://localhost:3000/up
# Should return: OK
```

### Pre-Deploy Blocks Deployment

**Symptom**: `/pre-deploy` fails with critical issues

**Don't**:
- Skip the check
- Disable personas
- Rush to deploy

**Do**:
1. Read the blocker carefully
2. Fix the issue (usually < 30min)
3. Re-run `/pre-deploy`
4. Deploy confidently

**Remember**: Blockers are there to save you from production incidents!

---

## Getting Help

### Enable Debug Logging

```bash
export IRON_CLAUDE_DEBUG=true
claude
```

### Check Plugin Logs

```bash
cat ~/.claude/logs/iron-claude.log
```

### Minimal Reproduction

Create minimal example:
```bash
rails new test-app
cd test-app
claude plugin install iron-claude
# Try to reproduce issue
```

### Report Issue

```markdown
**Issue**: Persona doesn't respond

**Steps**:
1. Install Iron Claude
2. Run: @product-manager help
3. Expected: Response from PM persona
4. Actual: No response

**Environment**:
- Claude Code version: 1.2.3
- Iron Claude version: 1.0.0
- OS: macOS 14.5
- Rails version: 8.0.0

**Logs**:
[Attach relevant logs]
```

---

## Common Solutions Summary

| Issue | Quick Fix |
|-------|-----------|
| Plugin not loading | `chmod +x hooks/scripts/*.sh` |
| Persona not responding | Use `@persona-name` syntax |
| Hooks not running | Check `hooks.json` paths |
| GitHub not connecting | Set `GITHUB_TOKEN` env var |
| RuboCop errors | `rubocop --auto-gen-config` |
| Tests too slow | Parallelize with `parallelize()` |
| Health check fails | Verify `/up` endpoint |
| Too strict | Customize `.iron-claude/config.json` |

---

**Still stuck?** Open an issue: https://github.com/yourusername/iron-claude/issues

**Remember**: Most issues are configuration or path-related. Check file permissions and paths first!
