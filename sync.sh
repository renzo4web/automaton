#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${SCRIPT_DIR}/.agents/skills"
COMMANDS_SRC="${SCRIPT_DIR}/.agents/commands"

usage() {
  cat <<'EOF'
Usage: sync.sh [OPTIONS] /path/to/project

Sync automaton commands/skills to a project for your preferred AI coding agent.

Agent Flags (at least one required):
  --claude          .claude/commands/ + .claude/skills/
  --opencode        .opencode/command/
  --codex           ~/.codex/prompts/ (global, ignores project path for commands)
  --droid           .factory/commands/ + .factory/skills/
  --copilot         .github/prompts/
  --cad             .agent/skills + .agents/commands (Claude Agent Desktop / pi-coding-agent)
  --all             All of the above

Options:
  --mode MODE       symlink (default) or mirror
  --skills-only     Only sync skills (where applicable)
  --commands-only   Only sync commands
  -h, --help        Show this message

Examples:
  sync.sh --claude ~/code/my-app
  sync.sh --droid --opencode ~/code/my-app
  sync.sh --all --mode mirror ~/code/my-app
EOF
}

MODE="symlink"
TARGET=""
SKILLS_ONLY=false
COMMANDS_ONLY=false

# Agent flags
DO_CLAUDE=false
DO_OPENCODE=false
DO_CODEX=false
DO_DROID=false
DO_COPILOT=false
DO_CAD=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude)    DO_CLAUDE=true; shift ;;
    --opencode)  DO_OPENCODE=true; shift ;;
    --codex)     DO_CODEX=true; shift ;;
    --droid)     DO_DROID=true; shift ;;
    --copilot)   DO_COPILOT=true; shift ;;
    --cad)       DO_CAD=true; shift ;;
    --all)
      DO_CLAUDE=true
      DO_OPENCODE=true
      DO_CODEX=true
      DO_DROID=true
      DO_COPILOT=true
      DO_CAD=true
      shift
      ;;
    --mode)
      MODE="${2:-symlink}"
      shift 2
      ;;
    --skills-only)
      SKILLS_ONLY=true
      shift
      ;;
    --commands-only)
      COMMANDS_ONLY=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

# Validate
if [[ -z "${TARGET}" ]]; then
  echo "Error: target project path is required." >&2
  usage
  exit 1
fi

if ! $DO_CLAUDE && ! $DO_OPENCODE && ! $DO_CODEX && ! $DO_DROID && ! $DO_COPILOT && ! $DO_CAD; then
  echo "Error: at least one agent flag is required (--claude, --droid, etc.)" >&2
  usage
  exit 1
fi

if [[ "${MODE}" != "symlink" && "${MODE}" != "mirror" ]]; then
  echo "Error: --mode must be 'symlink' or 'mirror'." >&2
  exit 1
fi

TARGET_DIR="$(cd "${TARGET}" && pwd)"

# Sync functions
sync_link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "${dest}")"
  ln -sfn "${src}" "${dest}"
  echo "  ✓ ${dest} -> ${src}"
}

sync_mirror() {
  local src="$1" dest="$2"
  mkdir -p "${dest}"
  rsync -a --delete "${src}/" "${dest}/"
  echo "  ✓ ${dest} (mirrored)"
}

do_sync() {
  local src="$1" dest="$2"
  if [[ "${MODE}" == "symlink" ]]; then
    sync_link "${src}" "${dest}"
  else
    sync_mirror "${src}" "${dest}"
  fi
}

# Sync commands to a destination (symlinks/copies the folder)
sync_commands() {
  local dest="$1"
  $SKILLS_ONLY && return
  do_sync "${COMMANDS_SRC}" "${dest}"
}

# Sync command files individually to a destination (for agents that want flat files)
# Optional second arg: suffix to add before .md (e.g., ".prompt" -> file.prompt.md)
sync_commands_flat() {
  local dest="$1"
  local suffix="${2:-}"
  $SKILLS_ONLY && return
  mkdir -p "${dest}"
  for file in "${COMMANDS_SRC}"/*.md; do
    [[ -e "${file}" ]] || continue
    local basename="$(basename "${file}" .md)"
    local filename="${basename}${suffix}.md"
    if [[ "${MODE}" == "symlink" ]]; then
      ln -sfn "${file}" "${dest}/${filename}"
      echo "  ✓ ${dest}/${filename} -> ${file}"
    else
      cp "${file}" "${dest}/${filename}"
      echo "  ✓ ${dest}/${filename} (copied)"
    fi
  done
}

# Sync skills to a destination  
sync_skills() {
  local dest="$1"
  $COMMANDS_ONLY && return
  do_sync "${SKILLS_SRC}" "${dest}"
}

echo "Syncing automaton to: ${TARGET_DIR}"
echo "Mode: ${MODE}"
echo ""

# Claude Code: .claude/commands/ + .claude/skills/
if $DO_CLAUDE; then
  echo "Claude Code:"
  sync_commands "${TARGET_DIR}/.claude/commands"
  sync_skills "${TARGET_DIR}/.claude/skills"
fi

# OpenCode: .opencode/command/
if $DO_OPENCODE; then
  if $SKILLS_ONLY; then
    echo "OpenCode: skipped (no skills support)"
  else
    echo "OpenCode:"
    sync_commands "${TARGET_DIR}/.opencode/command"
  fi
fi

# Codex CLI: ~/.codex/prompts/ (global)
if $DO_CODEX; then
  if $SKILLS_ONLY; then
    echo "Codex CLI: skipped (no skills support)"
  else
    echo "Codex CLI (global):"
    sync_commands "${HOME}/.codex/prompts"
  fi
fi

# Droid CLI: .factory/commands/ + .factory/skills/
if $DO_DROID; then
  echo "Droid CLI:"
  sync_commands "${TARGET_DIR}/.factory/commands"
  sync_skills "${TARGET_DIR}/.factory/skills"
fi

# Copilot: .github/prompts/ (flat files with .prompt.md suffix)
if $DO_COPILOT; then
  if $SKILLS_ONLY; then
    echo "GitHub Copilot: skipped (no skills support)"
  else
    echo "GitHub Copilot:"
    sync_commands_flat "${TARGET_DIR}/.github/prompts" ".prompt"
  fi
fi

# CAD / pi-coding-agent: .agent/skills + .agents/commands
if $DO_CAD; then
  echo "CAD (Claude Agent Desktop):"
  sync_commands "${TARGET_DIR}/.agents/commands"
  sync_skills "${TARGET_DIR}/.agent/skills"
fi

echo ""
echo "Done! 🚀"
