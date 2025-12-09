---
name: "/review-changes"
description: "Review local changes before committing - check quality, bugs, and best practices"
agent: agent
---

# Context

This command runs AFTER you finish coding a feature and want to review your changes before committing and pushing.

First, run `git status` and `git diff` to understand what changed.

# Behavior

You are a senior code reviewer analyzing the uncommitted changes.

## Step 1: Understand the Changes

1. Get status: `git status`
2. Get the full diff: `git diff` (or `git diff --cached` if already staged)
3. For new files: `git ls-files --others --exclude-standard`

## Step 2: High-Level Summary

Analyze and present:

- **Purpose**: What is the overall goal of these changes?
- **Scope**: New files? Modified? Deleted?
- **APIs/Functions**: New endpoints, functions, methods introduced?
- **Data structures**: New types, interfaces, schemas?
- **Dependencies**: Any new libraries added?
- **Architectural changes**: Design pattern changes?
- **Breaking changes**: Will this break existing functionality?

## Step 3: Dependency Check

For any new dependencies:
- Are they actively maintained?
- Flag if archived, deprecated, or unmaintained
- Check if similar libraries already exist in the codebase

## Step 4: Impact Assessment

- How does this affect existing code?
- What areas need to be aware of these changes?
- Documentation implications?
- Performance impact?

## Step 5: Review Focus Areas

Provide a prioritized list of files/areas to review:

1. **Foundational changes first** (schemas, types, core logic)
2. **Core implementation** (main business logic)
3. **Usage/Integration** (how it's used elsewhere)
4. **Tests** (test coverage gaps)

For each item, note what to focus on:
- Design/API considerations
- Complex logic needing examination
- Edge cases and error handling
- Performance concerns
- Security implications
- Test coverage gaps
- Code style/consistency

## Step 6: Suggested Comments

For each issue found, prepare a comment:

- Keep it short and focused
- Use a suggestion-based tone ("Consider...", "Might be worth...", "Nit: ...")
- Only be strongly opinionated if there's an obvious bug
- Include file path and specific concerns

Format:
```
File: <path>
Issue: <what's the problem>
Suggestion: <how to fix it>
```

## Step 7: Summary

Present findings as a review summary. I will tell you:
- Which suggestions to keep
- Changes needed
- Whether it's ready to commit

Do NOT push or commit until I approve.

# Output Format

Present your findings in clear sections. Wait for my feedback before making any changes.
