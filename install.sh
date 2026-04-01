#!/bin/bash
# ─────────────────────────────────────────────────────────
# Cursor Source Setup - Installer
# Liftoff pack for Cursor: rules, skills, extensions, workflows
# ─────────────────────────────────────────────────────────

set -euo pipefail
shopt -s nullglob

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

LIFTOFF_DIR="$HOME/.cursor/liftoff"
CURSOR_SKILLS_DIR="$HOME/.cursor/skills"
PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pack"
EXTENSIONS_DIR="$LIFTOFF_DIR/extensions"
WORKFLOWS_DIR="$LIFTOFF_DIR/workflows"
SETUP_DIR="$LIFTOFF_DIR/setup"
RULES_DIR="$LIFTOFF_DIR/rules"
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${PURPLE}"
echo "  ╔═══════════════════════════════════════════╗"
echo "  ║         CURSOR SOURCE SETUP               ║"
echo "  ║   Liftoff pack for Cursor (global install) ║"
echo "  ╚═══════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "$CURSOR_SKILLS_DIR"
mkdir -p "$EXTENSIONS_DIR"
mkdir -p "$WORKFLOWS_DIR"
mkdir -p "$SETUP_DIR"
mkdir -p "$RULES_DIR"
mkdir -p "$LIFTOFF_DIR/user-extensions"

echo -e "${GREEN}Installing Cursor rules (thin always-on layer)...${NC}"
cp -r "$PACK_DIR/rules/"* "$RULES_DIR/" 2>/dev/null || true
echo "  ✓ rules → $RULES_DIR"

if [ -f "$EXTENSIONS_DIR/extensions.json" ]; then
  echo -e "  ${YELLOW}Existing extensions.json found - preserving your settings${NC}"
  TEMP_MERGED=$(mktemp)
  python3 -c "
import json, sys
with open('$EXTENSIONS_DIR/extensions.json') as f: existing = json.load(f)
with open('$PACK_DIR/extensions/extensions.json') as f: source = json.load(f)
for k, v in source.items():
    if k not in existing:
        existing[k] = v
        print(f'  + Added new entry: {k}', file=sys.stderr)
with open('$TEMP_MERGED', 'w') as f: json.dump(existing, f, indent=2)
" 2>&1 | while read -r line; do echo -e "  ${GREEN}$line${NC}"; done
  cp "$TEMP_MERGED" "$EXTENSIONS_DIR/extensions.json"
  rm -f "$TEMP_MERGED"
else
  cp "$PACK_DIR/extensions/extensions.json" "$EXTENSIONS_DIR/extensions.json"
fi

echo -e "${GREEN}Installing core skills into ~/.cursor/skills/...${NC}"
MACHINE_ENV_FILE=$(mktemp)
LIFECYCLE_DEST="$CURSOR_SKILLS_DIR/liftoff-lifecycle/SKILL.md"
if [ -f "$LIFECYCLE_DEST" ]; then
  sed -n '/^## Machine Environment$/,$p' "$LIFECYCLE_DEST" > "$MACHINE_ENV_FILE"
fi

CORE_SKILLS=("forge-methodology" "security-guardian" "error-handling" "git-flow" "brand-identity" "stack-pro-max" "cursor-standard" "liftoff-lifecycle")

for skill in "${CORE_SKILLS[@]}"; do
  mkdir -p "$CURSOR_SKILLS_DIR/$skill"
  cp "$PACK_DIR/skills/$skill/SKILL.md" "$CURSOR_SKILLS_DIR/$skill/SKILL.md"
  echo "  ✓ $skill"
done

if [ -s "$MACHINE_ENV_FILE" ]; then
  echo "" >> "$CURSOR_SKILLS_DIR/liftoff-lifecycle/SKILL.md"
  cat "$MACHINE_ENV_FILE" >> "$CURSOR_SKILLS_DIR/liftoff-lifecycle/SKILL.md"
fi
rm -f "$MACHINE_ENV_FILE"

echo -e "${GREEN}Installing workflows...${NC}"
cp "$PACK_DIR/workflows/init-project.md" "$WORKFLOWS_DIR/init-project.md"
echo "  ✓ init-project"

echo -e "${GREEN}Installing setup tasks...${NC}"
for task_dir in "$PACK_DIR/setup"/*/; do
  task_name=$(basename "$task_dir")
  mkdir -p "$SETUP_DIR/$task_name"
  cp "$task_dir/SKILL.md" "$SETUP_DIR/$task_name/SKILL.md"
  echo "  ✓ $task_name"
done

install_extension() {
  local ext_name="$1"
  local dest_dir="$EXTENSIONS_DIR/$ext_name"
  mkdir -p "$dest_dir"
  cp -r "$PACK_DIR/extensions/$ext_name"/* "$dest_dir"/
  echo "  ✓ $ext_name"
}

echo -e "${GREEN}Installing extensions (all dormant until toggled)...${NC}"
EXT_COUNT=0
for ext_dir in "$PACK_DIR/extensions"/*/; do
  [[ -d "$ext_dir" ]] || continue
  ext_name=$(basename "$ext_dir")
  install_extension "$ext_name"
  EXT_COUNT=$((EXT_COUNT + 1))
done

if command -v git &> /dev/null && [ -d "$SCRIPT_ROOT/.git" ]; then
  if git -C "$SCRIPT_ROOT" rev-parse HEAD &>/dev/null; then
    git -C "$SCRIPT_ROOT" rev-parse HEAD > "$LIFTOFF_DIR/.liftoff-version" 2>/dev/null
    echo "$SCRIPT_ROOT" > "$LIFTOFF_DIR/.liftoff-source"
    echo -e "${GREEN}Version tracking enabled (auto-updates on session start)${NC}"
  fi
fi

echo ""
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo ""
echo -e "  ${BLUE}Rules:${NC}          $RULES_DIR/"
echo -e "  ${BLUE}Skills (global):${NC} $CURSOR_SKILLS_DIR/ (${#CORE_SKILLS[@]} core)"
echo -e "  ${BLUE}Pack root:${NC}      $LIFTOFF_DIR/"
echo -e "  ${BLUE}Extensions:${NC}     $EXTENSIONS_DIR/ ($EXT_COUNT packs)"
echo -e "  ${BLUE}Config:${NC}         $EXTENSIONS_DIR/extensions.json"
echo -e "  ${BLUE}Workflows:${NC}      $WORKFLOWS_DIR/"
echo ""
echo -e "${YELLOW}AGENT:${NC} Read ~/.cursor/liftoff/setup/package-manager/SKILL.md and execute Steps 0-9 if setup is still pending."
echo -e "${YELLOW}AGENT:${NC} Read ~/.cursor/skills/liftoff-lifecycle/SKILL.md \"Session Start\" after install."
echo ""
echo -e "${YELLOW}Keep this cloned repo folder — auto-update uses ~/.cursor/liftoff/.liftoff-source${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════${NC}"
