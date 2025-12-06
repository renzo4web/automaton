# My Agent Automations

A simple collection of skills and slash-commands for AI agents.

---

## Structure

```
automaton/
├── .agent/
│   └── skills/               # Complex behaviors (used by the agent runtime)
│       └── skill-name/
│           └── SKILL.md
├── slash-commands/           # Quick commands (run after changes)
│   └── command-name.md
└── templates/                # Copy these to create new ones
```

---

## How Slash Commands Work

Slash commands are designed to run **after you make changes**.
They automatically check `git status` and `git diff` to work on your recent modifications.

Example: You implement a feature, then run `/refactor` to clean it up.

---

## Tooling

### kit-dev-mcp

Install Kit's `kit-dev-mcp` server to give your agent fast repository indexing, symbol lookup, dependency graphs, and deep documentation search—all running locally.

```bash
uv tool install --from cased-kit kit-dev-mcp
```

Configuration varies by agent platform (Cursor, Claude Code, VS Code, etc.), so follow the official guide: https://kit-mcp.cased.com/docs

---

## Available

| Type | Name | Description |
|------|------|-------------|
| skill | code-reviewer | Review code for quality and bugs |
| command | /refactor | Refactor recent changes |
| command | /commit | Write commit message for changes |
| command | /remove-slop | Remove AI-generated code slop |
| command | /check-react-state | Review React state vs derived values |

---

## Create New

### New Skill
```bash
mkdir -p .agent/skills/my-skill
cp templates/skill-template.md .agent/skills/my-skill/SKILL.md
openskills sync
```

Every time you add or modify a skill, run `openskills sync` so the agent discovers the new capabilities.

### New Command
```bash
cp templates/slash-command-template.md slash-commands/my-command.md
```

---

## Use in Projects

### Simple: Symlinks
```bash
ln -s /path/to/automaton/skills/code-reviewer .claude/skills/code-reviewer
ln -s /path/to/automaton/slash-commands/refactor.md .claude/slash-commands/refactor.md
```

### Or: Git Submodule
```bash
git submodule add https://github.com/USER/automaton.git .commands
```
