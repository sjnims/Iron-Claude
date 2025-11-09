# Contributing to Iron Claude

Thank you for your interest in contributing to Iron Claude! This guide will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contribution Workflow](#contribution-workflow)
- [Pull Request Process](#pull-request-process)
- [Testing Requirements](#testing-requirements)
- [What to Contribute](#what-to-contribute)
- [Style Guidelines](#style-guidelines)

## Code of Conduct

We are committed to providing a welcoming and inclusive experience for everyone. We expect all contributors to:

- Be respectful and considerate
- Focus on constructive feedback
- Embrace the Rails omakase philosophy
- Prioritize simplicity over complexity

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:

   ```bash
   git clone https://github.com/YOUR-USERNAME/Iron-Claude.git
   cd Iron-Claude
   ```

3. **Add upstream remote**:

   ```bash
   git remote add upstream https://github.com/sjnims/Iron-Claude.git
   ```

## Development Setup

### Prerequisites

- [Claude Code](https://claude.com/claude-code) installed
- Basic understanding of Claude Code plugins
- Familiarity with Rails 8 omakase stack
- [ShellCheck](https://www.shellcheck.net/) for shell script linting (optional but recommended)

### Installing for Development

```bash
# Install the plugin from your local clone
claude plugin install .

# Test the installation
claude plugin list
```

### Installing ShellCheck

ShellCheck automatically lints shell scripts during development:

```bash
# macOS
brew install shellcheck

# Ubuntu/Debian
sudo apt-get install shellcheck

# Fedora
sudo dnf install shellcheck
```

**Automatic Linting**: When you edit `.sh` files, ShellCheck runs automatically via hooks.

**Manual Linting**: To lint all shell scripts at once:

```bash
./scripts/lint-shell.sh
```

### Testing Your Changes

```bash
# Create a test Rails 8 app
rails new test-app
cd test-app

# Test plugin commands
claude
# Then use /review-feature, /pre-deploy, etc.
```

## Contribution Workflow

We follow a standard GitHub workflow:

1. **Create a branch** from `main`:

   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   ```

2. **Make your changes** following our guidelines

3. **Test thoroughly** - see [Testing Requirements](#testing-requirements)

4. **Commit** with clear messages:

   ```bash
   git commit -m "Add user authentication persona"
   ```

5. **Push** to your fork:

   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

## Pull Request Process

1. **Update documentation** - Update README.md, docs/, or other files as needed
2. **Describe your changes** - Use the PR template and explain what and why
3. **Reference issues** - Link to any related GitHub issues
4. **Wait for review** - A maintainer will review your PR
5. **Address feedback** - Make requested changes if needed
6. **Merge** - Once approved, we'll merge your PR

### PR Checklist

- [ ] Branch is up to date with `main`
- [ ] Changes follow omakase philosophy
- [ ] Documentation is updated
- [ ] PR description is clear and complete
- [ ] All tests pass (if applicable)
- [ ] Shell scripts pass ShellCheck (run `./scripts/lint-shell.sh`)
- [ ] No breaking changes (or clearly documented)

## Testing Requirements

### For Personas and Skills

- **Manual testing** - Test with real Rails 8 applications
- **Edge cases** - Try boundary conditions and error scenarios
- **Documentation** - Include usage examples

### For Commands

- **Integration testing** - Verify the command works end-to-end
- **Error handling** - Test with invalid inputs
- **Output validation** - Ensure clear, helpful output

### For Shell Scripts

- **ShellCheck validation** - All scripts must pass ShellCheck
- **Manual testing** - Test scripts in relevant environments
- **Error handling** - Validate input parameters and fail gracefully

### Philosophy

While Iron Claude is a Claude Code plugin (not a Rails app), we still embrace TDD principles:

- Test your changes before submitting
- Verify persona prompts produce expected behavior
- Check that skills integrate correctly

## What to Contribute

We welcome contributions in these areas:

### High Priority

- **Additional Personas**: Database Architect, UX Designer, Security Specialist
- **Hotwire Examples**: Real-world Turbo/Stimulus patterns
- **Skills**: Rails-specific analysis and automation
- **Documentation**: Tutorials, guides, troubleshooting

### Medium Priority

- **Command Improvements**: Enhance existing commands
- **Bug Fixes**: Fix issues and edge cases
- **Performance**: Speed up plugin operations
- **Translations**: Help internationalize documentation

### Examples

#### Adding a New Persona

1. Create `.claude/personas/your-persona.md`
2. Define clear responsibilities
3. Include examples and patterns
4. Update `docs/PERSONAS.md`
5. Test with real scenarios

#### Adding a New Skill

1. Create `.claude/skills/your-skill.md`
2. Define scope and usage
3. Provide examples
4. Update documentation
5. Test integration

#### Adding a New Command

1. Create `.claude/commands/your-command.md`
2. Write clear usage instructions
3. Include examples
4. Update README.md
5. Test thoroughly

## Style Guidelines

### Markdown Files

- Use clear, concise language
- Include code examples
- Add links to relevant documentation
- Follow existing formatting patterns

### Persona/Skill/Command Files

- **Be specific**: Clear, actionable instructions
- **Be Rails 8 focused**: Embrace the omakase stack
- **Be practical**: Real-world examples
- **Be consistent**: Follow existing patterns

### Omakase Adherence

Iron Claude strictly follows DHH's Rails 8 omakase:

**YES**:

- Hotwire (Turbo + Stimulus)
- Solid Queue, Cache, Cable
- Kamal deployment
- PostgreSQL or SQLite
- Minitest

**NO**:

- React/Vue/Angular
- Redis/Sidekiq
- Heroku/Render
- RSpec (use Minitest)

### Git Commit Messages

- Use present tense ("Add feature" not "Added feature")
- Be descriptive but concise
- Reference issues when applicable:

  ```
  Add database architect persona

  - Creates persona with schema design focus
  - Includes migration review patterns
  - Adds N+1 query detection

  Closes #42
  ```

## Questions?

- **Issues**: Open a [GitHub issue](https://github.com/sjnims/Iron-Claude/issues)
- **Discussions**: Use [GitHub Discussions](https://github.com/sjnims/Iron-Claude/discussions)
- **Documentation**: Check [docs/](docs/)

## Recognition

Contributors are recognized in:

- GitHub contributors list
- Release notes for significant contributions
- Special thanks in documentation

---

**Thank you for helping make Iron Claude better!** Your contributions help solo Rails developers ship with confidence.
