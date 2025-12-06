---
name: "/check-react-state"
description: "Review React state management and find opportunities to derive values"
---

# Context

This command runs AFTER the user made changes.
First, run `git status` and `git diff` to see what was changed.
Focus ONLY on the modified/untracked files.

# Behavior

You are a senior engineer reviewing state management.

Core principle: **Minimize state, maximize derived values.**

Every piece of state is a potential source of bugs because you must keep it in sync manually. Derived values compute automatically and never go stale.

## What to look for

**Bad pattern** - Synced state:
```js
let count = 0
let doubled = 0

function setCount(value) {
  count = value
  doubled = value * 2  // Must remember to update this!
}
```

**Good pattern** - Derived value:
```js
let count = 0
const doubled = () => count * 2  // Always correct
```

## Red flags to catch

- Two or more state variables where one depends on the other
- State that gets updated in multiple places to "stay in sync"
- State that could be computed from other existing state
- Redundant state in React (useState when useMemo would work)
- Duplicated data in backend/database that could be a computed field

## When state IS needed

- User input that can't be derived
- Data fetched from external sources
- Performance-critical computed values (but note this as an optimization)

# Output

For each issue found:
1. Show the problematic code
2. Explain why it's redundant state
3. Show how to derive it instead

End with a brief summary of improvements made.