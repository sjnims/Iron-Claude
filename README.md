<p align="center">
  <img src="docs/images/banner.svg?v=3" alt="Iron Claude Banner">
</p>

# Iron Claude

> **An Opinionated Claude Code Plugin For Rails Developers**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Rails](https://img.shields.io/badge/Rails-8.0-red.svg)](https://rubyonrails.org)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-blue.svg)](https://claude.com/claude-code)
[![CI](https://github.com/sjnims/Iron-Claude/actions/workflows/test.yml/badge.svg)](https://github.com/sjnims/Iron-Claude/actions/workflows/test.yml)

Iron Claude is a comprehensive Claude Code plugin that embodies DHH's omakase philosophy, providing four specialized personas that catch blind spots, enforce TDD workflows, and help solo developers ship production-ready Rails 8 applications with confidence.

## 🎯 Features

- **🤖 Four Expert Personas**: Product Manager, DevOps Engineer, QA Tester, Code Reviewer
- **⚡ Powerful Commands**: `/review-feature`, `/pre-deploy`, `/milestone-planning`, `/security-audit`, `/performance-check`
- **🎓 Specialized Skills**: Rails security audit, performance analysis, Hotwire patterns
- **🪝 Milestone-Based Hooks**: Automatic quality gates and TDD enforcement
- **🚢 GitHub Integration**: PR reviews, issue triage, CI/CD automation

## 🚀 Quick Start

### Installation

**From Marketplace (Recommended)**

```bash
# Add the Iron Claude marketplace (GitHub shorthand)
/plugin marketplace add sjnims/Iron-Claude

# Install the plugin
/plugin install iron-claude
```

Or use the direct marketplace URL:

```bash
# Add via marketplace.json URL
/plugin marketplace add https://raw.githubusercontent.com/sjnims/Iron-Claude/main/.claude-plugin/marketplace.json

# Install the plugin
/plugin install iron-claude
```

**From Source (Alternative)**

For development or testing:

```bash
git clone https://github.com/sjnims/Iron-Claude.git iron-claude
/plugin install ./iron-claude
```

### First Feature

```bash
# 1. Plan with TDD
/milestone-planning "User authentication"

# 2. Build (test-first!)
# Write tests → Implement → Review

# 3. Review
/review-feature

# 4. Pre-deploy check
/pre-deploy

# 5. Deploy confidently
kamal deploy
```

## 📚 Documentation

- **[Getting Started](docs/GETTING_STARTED.md)** - Installation and first feature walkthrough
- **[Personas](docs/PERSONAS.md)** - Deep dive into each persona
- **[Workflows](docs/WORKFLOWS.md)** - TDD and milestone patterns
- **[Philosophy](docs/PHILOSOPHY.md)** - DHH's omakase principles
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** - Common issues and solutions

## 🎨 The Four Personas

### 🎨 Product Manager

UX validation, Hotwire patterns, accessibility, feature completeness

### 🚀 DevOps Engineer

Kamal deployment, performance, N+1 detection, Solid Stack expertise

### 🧪 QA Tester

TDD enforcement, 90%+ coverage, edge cases, fast test suite

### 🔒 Code Reviewer

Security (OWASP Top 10), Rails conventions, omakase adherence

## 💪 The Omakase Stack

Iron Claude strictly enforces DHH's Rails 8 omakase:

**Frontend**: Hotwire (Turbo 8 + Stimulus), Importmap, Propshaft
**Backend**: Solid Queue, Solid Cache, Solid Cable
**Database**: PostgreSQL or SQLite
**Deployment**: Kamal 2 (zero-downtime)
**Testing**: Minitest (TDD workflow, 90%+ coverage)

**No**: React/Vue, Redis/Sidekiq, PaaS (Heroku/Render)

## 🤝 Contributing

Contributions welcome! See [Contributing Guidelines](CONTRIBUTING.md).

### Wanted

- Additional personas (Database Architect, UX Designer)
- More Hotwire examples
- Community skills
- Translations

## 📜 License

MIT License - see [LICENSE](LICENSE)

## 🙏 Credits

- Rails 8 omakase by [@dhh](https://github.com/dhh)
- Claude Code by [Anthropic](https://www.anthropic.com)
- Hotwire by [37signals](https://hotwired.dev)
- Kamal by [37signals](https://kamal-deploy.org)

---

**Ship with confidence. Ship with Iron Claude.** 🚀

For complete documentation, see [docs/README.md](docs/README.md)
