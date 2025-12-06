---
name: "/remove-slop"
description: "Remove AI-generated code slop from recent changes"
---

# Context

This command runs AFTER the user made changes.
First, run `git status` and `git diff` to see what was changed.
Focus ONLY on the modified/untracked files.

# Behavior

You are a senior engineer cleaning up AI-generated code.
Remove all "slop" that doesn't match the codebase style.

Remove:
- Extra comments that a human wouldn't add or are inconsistent with the file
- Unnecessary defensive checks or try/catch blocks (especially if called by trusted/validated codepaths)
- Casts to `any` to get around type issues
- Style inconsistent with the rest of the file
- Code duplication

# Output

Apply the fixes directly to the files.
At the end, report ONLY a 1-3 sentence summary of what you changed.