#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="${SCRIPT_DIR}/.agents/skills"
COMMANDS_SRC="${SCRIPT_DIR}/.agents/commands"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

usage() {
  cat <<'EOF'
Usage: sync.sh [OPTIONS] /path/to/project

Sync automaton commands/skills to a project for your preferred AI coding agent.
Files are COPIED (not symlinked) so you can customize them locally.

Agent Flags (at least one required):
  --claude          .claude/commands/ + .claude/skills/
  --opencode        .opencode/command/
  --codex           ~/.codex/prompts/ (global, ignores project path for commands)
  --droid           .factory/commands/ + .factory/skills/
  --copilot         .github/prompts/
  --cursor          .cursor/commands/
  --cad             .agent/skills + .agents/commands (Claude Agent Desktop / pi-coding-agent)
  --all             All of the above

Options:
  --force           Overwrite files even if they have local modifications
  --no-pull         Skip git pull (don't update automaton before syncing)
  --skills-only     Only sync skills (where applicable)
  --commands-only   Only sync commands
  -h, --help        Show this message

Examples:
  sync.sh --claude ~/code/my-app
  sync.sh --droid --opencode ~/code/my-app
  sync.sh --all ~/code/my-app
  sync.sh --cad --force ~/code/my-app    # Overwrite local modifications
EOF
}

TARGET=""
FORCE=false
NO_PULL=false
SKILLS_ONLY=false
COMMANDS_ONLY=false
SKIPPED_FILES=()

# Agent flags
DO_CLAUDE=false
DO_OPENCODE=false
DO_CODEX=false
DO_DROID=false
DO_COPILOT=false
DO_CURSOR=false
DO_CAD=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --claude)    DO_CLAUDE=true; shift ;;
    --opencode)  DO_OPENCODE=true; shift ;;
    --codex)     DO_CODEX=true; shift ;;
    --droid)     DO_DROID=true; shift ;;
    --copilot)   DO_COPILOT=true; shift ;;
    --cursor)    DO_CURSOR=true; shift ;;
    --cad)       DO_CAD=true; shift ;;
    --all)
      DO_CLAUDE=true
      DO_OPENCODE=true
      DO_CODEX=true
      DO_DROID=true
      DO_COPILOT=true
      DO_CURSOR=true
      DO_CAD=true
      shift
      ;;
    --force)
      FORCE=true
      shift
      ;;
    --no-pull)
      NO_PULL=true
      shift
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

if ! $DO_CLAUDE && ! $DO_OPENCODE && ! $DO_CODEX && ! $DO_DROID && ! $DO_COPILOT && ! $DO_CURSOR && ! $DO_CAD; then
  echo "Error: at least one agent flag is required (--claude, --droid, etc.)" >&2
  usage
  exit 1
fi

# Resolve target path
if [[ ! -d "${TARGET}" ]]; then
  echo "Error: target directory does not exist: ${TARGET}" >&2
  exit 1
fi
TARGET_DIR="$(cd "${TARGET}" && pwd)"

# Update automaton repo
if ! $NO_PULL; then
  echo "Updating automaton..."
  if git -C "${SCRIPT_DIR}" pull --quiet 2>/dev/null; then
    echo -e "${GREEN}✓${NC} automaton updated"
  else
    echo -e "${YELLOW}⚠${NC} Could not update automaton (offline or not a git repo)"
  fi
  echo ""
fi

# Copy a single file with conflict detection
copy_file() {
  local src="$1"
  local dest="$2"
  local dest_dir="$(dirname "${dest}")"
  
  mkdir -p "${dest_dir}"
  
  if [[ ! -e "${dest}" ]]; then
    # File doesn't exist - copy it
    cp "${src}" "${dest}"
    echo -e "  ${GREEN}✓${NC} ${dest} (copied)"
  elif cmp -s "${src}" "${dest}"; then
    # File exists and is identical - skip
    echo -e "  ${GREEN}✓${NC} ${dest} (up to date)"
  elif $FORCE; then
    # File exists and is different, but --force is set
    cp "${src}" "${dest}"
    echo -e "  ${YELLOW}✓${NC} ${dest} (overwritten)"
  else
    # File exists and is different - skip and warn
    echo -e "  ${RED}✗${NC} ${dest} (local modifications, skipped)"
    SKIPPED_FILES+=("${dest}")
  fi
}

# Copy all files from a source directory to destination
copy_dir() {
  local src_dir="$1"
  local dest_dir="$2"
  
  if [[ ! -d "${src_dir}" ]]; then
    return
  fi
  
  # Find all files recursively
  while IFS= read -r -d '' file; do
    local rel_path="${file#${src_dir}/}"
    local dest_file="${dest_dir}/${rel_path}"
    copy_file "${file}" "${dest_file}"
  done < <(find "${src_dir}" -type f -print0)
}

# Sync commands to a destination
sync_commands() {
  local dest="$1"
  $SKILLS_ONLY && return
  copy_dir "${COMMANDS_SRC}" "${dest}"
}

# Sync command files with custom suffix (for agents like Copilot)
sync_commands_flat() {
  local dest="$1"
  local suffix="${2:-}"
  $SKILLS_ONLY && return
  
  for file in "${COMMANDS_SRC}"/*.md; do
    [[ -e "${file}" ]] || continue
    local basename="$(basename "${file}" .md)"
    local filename="${basename}${suffix}.md"
    copy_file "${file}" "${dest}/${filename}"
  done
}

# Sync skills to a destination
sync_skills() {
  local dest="$1"
  $COMMANDS_ONLY && return
  copy_dir "${SKILLS_SRC}" "${dest}"
}

echo "Syncing automaton to: ${TARGET_DIR}"
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

# Cursor: .cursor/commands/
if $DO_CURSOR; then
  if $SKILLS_ONLY; then
    echo "Cursor: skipped (no skills support)"
  else
    echo "Cursor:"
    sync_commands "${TARGET_DIR}/.cursor/commands"
  fi
fi

# CAD / pi-coding-agent: .agent/skills + .agents/commands
if $DO_CAD; then
  echo "CAD (Claude Agent Desktop):"
  sync_commands "${TARGET_DIR}/.agents/commands"
  sync_skills "${TARGET_DIR}/.agent/skills"
fi

echo ""

# Show summary
if [[ ${#SKIPPED_FILES[@]} -gt 0 ]]; then
  echo -e "${YELLOW}Warning:${NC} ${#SKIPPED_FILES[@]} file(s) were skipped due to local modifications."
  echo "Run with --force to overwrite them."
  exit 1
else
  echo -e "${GREEN}Done!${NC} 🚀"
fi
