# Automaton

Central repo for AI coding agent commands and skills. Sync them to any project with a single command.

## Quick Start

```bash
# 1. Clone automaton (once, anywhere on your machine)
git clone https://github.com/renzo4web/automaton ~/automaton

# 2. Sync to your project
~/automaton/sync.sh --cad ~/code/my-project
```

That's it! Files are **copied** to your project, so you can customize them.

## How It Works

1. `sync.sh` pulls the latest changes from this repo
2. Copies commands/skills to your project's agent directories
3. Detects local modifications and warns you (won't overwrite by default)

## Updating

Just run `sync.sh` again:

```bash
~/automaton/sync.sh --cad ~/code/my-project
```

- New files → copied
- Unchanged files → skipped
- Modified files → skipped (use `--force` to overwrite)

## Supported Agents

| Agent | Flag | Target Directory |
|-------|------|------------------|
| Claude Code | `--claude` | `.claude/commands/` + `.claude/skills/` |
| OpenCode | `--opencode` | `.opencode/command/` |
| Codex CLI | `--codex` | `~/.codex/prompts/` (global) |
| Droid CLI | `--droid` | `.factory/commands/` + `.factory/skills/` |
| GitHub Copilot | `--copilot` | `.github/prompts/` |
| Cursor | `--cursor` | `.cursor/commands/` |
| CAD / pi-coding-agent | `--cad` | `.agent/skills/` + `.agents/commands/` |

## Usage

```bash
# Single agent
~/automaton/sync.sh --claude ~/code/my-project

# Multiple agents
~/automaton/sync.sh --claude --droid --opencode ~/code/my-project

# All agents at once
~/automaton/sync.sh --all ~/code/my-project

# Overwrite local modifications
~/automaton/sync.sh --cad --force ~/code/my-project

# Skip git pull (use local version as-is)
~/automaton/sync.sh --cad --no-pull ~/code/my-project

# Only sync commands or skills
~/automaton/sync.sh --cad --commands-only ~/code/my-project
~/automaton/sync.sh --cad --skills-only ~/code/my-project
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

## Customization

Files are copied (not linked), so you can:

- Edit any command/skill to fit your project's needs
- Delete commands/skills you don't need
- Your changes won't be overwritten unless you use `--force`

## Project Structure

```
automaton/
├── .agents/
│   ├── commands/         # Slash commands (markdown)
│   └── skills/           # Complex behaviors (for openskills)
├── sync.sh               # Sync script
└── templates/            # Templates for new commands/skills
```

## Create New

### New Command
```bash
cp templates/slash-command-template.md .agents/commands/my-command.md
# Edit the file, then sync to your projects
```

### New Skill
```bash
mkdir -p .agents/skills/my-skill
cp templates/skill-template.md .agents/skills/my-skill/SKILL.md
# For CAD users: run `openskills sync` in the target project
```

## Tooling

### beads

Issue tracking for AI agents: https://github.com/steveyegge/beads

```bash
bd quickstart  # Interactive guide
```
