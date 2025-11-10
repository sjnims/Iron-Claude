---
name: hotwire-patterns
description: Expert guidance on Hotwire/Turbo 8 patterns for Rails 8 applications following DHH's omakase philosophy. Use when choosing between Turbo morphing/frames/streams, implementing real-time features, optimizing perceived performance, or converting from React/Vue to Hotwire.
---

# Hotwire Patterns Skill

Expert guidance on Hotwire/Turbo 8 patterns for Rails 8 applications following DHH's omakase philosophy.

## Skill Overview

Progressive disclosure skill providing Hotwire pattern recommendations and examples.

## When to Use

- Choosing between Turbo morphing, frames, and streams
- Implementing real-time features
- Optimizing perceived performance
- Progressive enhancement questions
- Converting from React/Vue to Hotwire

## Decision Tree

### Step 1: Does it need interactivity without page refresh?

- **No** → Standard Rails form/link
- **Yes** → Continue to Step 2

### Step 2: How much of the page updates?

- **Full page** → Turbo morphing
- **Multiple sections** → Turbo Streams
- **Single section** → Turbo Frame
- **Small interaction** → Stimulus controller

## Pattern Library

### Turbo Drive (Default)

Standard navigation with automatic AJAX

### Turbo Frames

Lazy-loaded sections, inline editing

### Turbo Streams

Real-time updates, multiple targets

### Page Morphing

Smooth full-page updates

### Stimulus

Minimal JavaScript for interactions

## Examples

See `examples/` directory for:

- Inline editing (Turbo Frame)
- Real-time notifications (Turbo Stream)
- Infinite scroll (Stimulus + Turbo Frame)
- Form validation (Turbo Frame)

## Integration

- `@product-manager` persona
- `/review-feature` command
- UX validation

## Output Format

```markdown
## Recommended Pattern: [Pattern Name]

**Why**: [Reasoning]

**Example Code**:
[Code snippet]

**Fallback**: [Non-JS version]
```
