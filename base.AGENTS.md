
<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: Bash("openskills read <skill-name>")
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<skill>
<name>code-reviewer</name>
<description>"Review code for quality, bugs, and best practices"</description>
<location>project</location>
</skill>

<skill>
<name>inertia-rails</name>
<description>Building full-stack applications with Inertia.js in Rails using React. Use when working with Inertia responses, forms, props, redirects, React page components, or Rails controllers in an Inertia project.</description>
<location>project</location>
</skill>

<skill>
<name>programming-rails</name>
<description>Best practices for Ruby on Rails development across models, controllers, services, and background jobs</description>
<location>project</location>
</skill>

<skill>
<name>programming-ruby</name>
<description>Best practices when developing in Ruby codebases</description>
<location>project</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>

You have access to kit-dev-mcp server with powerful code intelligence tools.

MANDATORY WORKFLOW for code tasks:
1. open_repository(path) - Load the codebase
2. get_file_tree() - Understand structure
3. extract_symbols() - Analyze code (cached)
4. For new libraries: deep_research_package()

TOOL DESCRIPTIONS:
- open_repository: Opens local/remote repositories
- get_file_tree: Shows project structure
- extract_symbols: Fast symbol extraction with caching
- get_file_content_multi: Read multiple files at once
- search_text: Powerful regex search
- find_symbol_usages: Find where symbols are used
- get_dependency_graph: Map import relationships
- deep_research_package: Research from multiple documentation sources

Always use these tools proactively. Don't wait to be asked.
Better context = Better code.

## Quick Commands for Agents

### Creating Issues
```bash
bd create "Task description"
bd create "Task description" -p 0 -t feature  # High priority feature
bd create "Task description" -d "Detailed description" --assignee agent-name
```

### Finding Work
```bash
bd ready        # Show issues ready to work on (no blockers)
bd list         # List all issues
bd list --status open  # Filter by status
bd show <issue-id>     # View issue details
```

### Managing Issues
```bash
bd update <issue-id> --status in_progress   # Claim work
bd update <issue-id> --status done          # Mark complete
bd close <issue-id>                         # Close issue
```

### Dependencies
```bash
bd dep add <blocker-id> <blocked-id>  # Add blocking dependency
bd dep tree <issue-id>                # View dependency tree
bd dep cycles                         # Detect circular dependencies
```

## Beads workflow for coding agents

This repository uses **Beads** (`bd`) as the primary task tracker and long-term memory for AI coding agents (Copilot, Claude, Codex, Cursor, etc.).  
You MUST use Beads for planning and tracking work instead of ad-hoc markdown plans or scattered TODO comments.

### Planning and microtasks

- For any non-trivial feature, bugfix, or refactor:
  - Prefer a short **planning pass** before coding.
  - Create **one parent issue** for the feature with `bd new`.
  - Create **3–7 small child issues** (microtasks) with `bd new --parent <parent-id>`.
    - Each child should be ~10–30 minutes of work.
    - Use `--blocks` to express ordering (“do A before B”).
    - Use `--discovered-from` for follow-up work or tech debt you discover.
- Do NOT produce large “plans” in markdown; the plan should live in Beads issues.

### Executing work (one microtask at a time)

- Before coding:
  - Run `bd ready` (or `bd ready --json`) and choose ONE relevant ready issue.
  - Show which issue you picked (e.g. `bd show <id>`).
- Implement **only that one** issue:
  - Apply code changes.
  - Add/update tests as appropriate.
  - Run the project’s test/build/linters from the other sections of AGENTS.md.
- When the microtask is complete and checks pass:
  - Close it with `bd close <id> --body "What changed and how it was verified."`
- If checks fail and you cannot fully fix them:
  - Leave the issue open or file a new Beads issue describing the failing state.
- **Important:** After finishing a microtask, STOP.  
  Do **not** automatically start another Beads issue. Report back so the user can review and manually test before continuing.

### “Let’s land the plane”

When the user says **“let’s land the plane”** or **“land the plane”**, treat this as a special, mandatory wrap-up flow:

1. **File remaining work**
   - Create Beads issues for any follow-ups, bugs, or tech debt discovered but not completed.
2. **Run quality gates**
   - Run the relevant tests, linters, and builds described elsewhere in AGENTS.md.
   - If something is broken and cannot be fully fixed now, file high-priority Beads issues describing the problem.
3. **Update Beads**
   - Close all finished issues with clear summaries.
   - Update status/priority for any partially completed work.
4. **Suggest next steps**
   - Choose one good Beads issue for the next session.
   - Provide the user with:
     - A brief summary of what was completed
     - Any follow-up issues created
     - Confirmation that everything has been pushed
     - A recommended prompt to continue work next time

Landing the plane is **only complete** when tests or lint have been run, Beads is up to date, and all changes are pushed to the remote with a clean git state.
