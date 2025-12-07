# Automaton

Central repo for AI coding agent commands and skills. Sync them to any project with a single command.

## Structure

```
automaton/
├── .agents/
│   ├── commands/         # Slash commands (markdown)
│   └── skills/           # Complex behaviors (for openskills)
├── sync.sh               # Sync to any project
└── templates/            # Templates for new commands/skills
```

## Quick Start

```bash
# Sync to a project for your preferred agent
./sync.sh --claude ~/code/my-project
./sync.sh --droid ~/code/my-project
./sync.sh --all ~/code/my-project
```

## Supported Agents

| Agent | Flag | Target Directory |
|-------|------|------------------|
| Claude Code | `--claude` | `.claude/commands/` + `.claude/skills/` |
| OpenCode | `--opencode` | `.opencode/command/` |
| Codex CLI | `--codex` | `~/.codex/prompts/` (global) |
| Droid CLI | `--droid` | `.factory/commands/` + `.factory/skills/` |
| GitHub Copilot | `--copilot` | `.github/prompts/` |
| CAD / pi-coding-agent | `--cad` | `.agent/skills/` + `.agents/commands/` |

## Usage

```bash
# Single agent
./sync.sh --claude ~/code/my-project

# Multiple agents
./sync.sh --claude --droid --opencode ~/code/my-project

# All agents at once
./sync.sh --all ~/code/my-project

# Copy files instead of symlink (for repos you'll share)
./sync.sh --claude --mode mirror ~/code/my-project

# Only sync commands or skills
./sync.sh --cad --commands-only ~/code/my-project
./sync.sh --cad --skills-only ~/code/my-project
```

## Available Commands & Skills

| Type | Name | Description |
|------|------|-------------|
| skill | `code-reviewer` | Review code for quality and bugs |
| skill | `programming-ruby` | Ruby best practices |
| skill | `programming-rails` | Rails best practices |
| skill | `inertia-rails` | Inertia.js + Rails + React |
| command | `/remove-slop` | Remove AI-generated code slop |
| command | `/check-react-state` | Review React state vs derived values |

## Create New

### New Command
```bash
cp templates/slash-command-template.md .automaton/commands/my-command.md
# Edit the file, then sync to your projects
```

### New Skill
```bash
mkdir -p .automaton/skills/my-skill
cp templates/skill-template.md .automaton/skills/my-skill/SKILL.md
# For CAD users: run `openskills sync` in the target project
```

## Tooling

### kit-dev-mcp

Fast repository indexing, symbol lookup, and dependency graphs:

```bash
uv tool install --from cased-kit kit-dev-mcp
```

Docs: https://kit-mcp.cased.com/docs

### beads

Issue tracking for AI agents: https://github.com/steveyegge/beads

```bash
bd quickstart  # Interactive guide
```
