#!/bin/bash
# ─────────────────────────────────────────────────────────
# Cursor Source Setup - Updater (session start / manual)
# Replaces pack content under ~/.cursor/liftoff and ~/.cursor/skills
# NEVER touches ~/.cursor/liftoff/user-extensions/
# ─────────────────────────────────────────────────────────

set -euo pipefail

LIFTOFF_DIR="$HOME/.cursor/liftoff"
CURSOR_SKILLS_DIR="$HOME/.cursor/skills"
PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/pack"
EXTENSIONS_DIR="$LIFTOFF_DIR/extensions"
WORKFLOWS_DIR="$LIFTOFF_DIR/workflows"
SETUP_DIR="$LIFTOFF_DIR/setup"
RULES_DIR="$LIFTOFF_DIR/rules"
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Rules
mkdir -p "$RULES_DIR"
cp -r "$PACK_DIR/rules/"* "$RULES_DIR/" 2>/dev/null || true

# Skills: preserve Machine Environment in liftoff-lifecycle
MACHINE_ENV_FILE=$(mktemp)
LIFECYCLE_FILE="$CURSOR_SKILLS_DIR/liftoff-lifecycle/SKILL.md"
if [ -f "$LIFECYCLE_FILE" ]; then
  sed -n '/^## Machine Environment$/,$p' "$LIFECYCLE_FILE" > "$MACHINE_ENV_FILE"
fi

for skill_dir in "$PACK_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$CURSOR_SKILLS_DIR/$skill_name"
  cp -r "$skill_dir"/* "$CURSOR_SKILLS_DIR/$skill_name/"
done

if [ -s "$MACHINE_ENV_FILE" ]; then
  echo "" >> "$CURSOR_SKILLS_DIR/liftoff-lifecycle/SKILL.md"
  cat "$MACHINE_ENV_FILE" >> "$CURSOR_SKILLS_DIR/liftoff-lifecycle/SKILL.md"
fi
rm -f "$MACHINE_ENV_FILE"

rm -rf "$WORKFLOWS_DIR"
mkdir -p "$WORKFLOWS_DIR"
cp "$PACK_DIR/workflows"/*.md "$WORKFLOWS_DIR/" 2>/dev/null || true

rm -rf "$SETUP_DIR"
mkdir -p "$SETUP_DIR"
for task_dir in "$PACK_DIR/setup"/*/; do
  task_name=$(basename "$task_dir")
  cp -r "$task_dir" "$SETUP_DIR/$task_name"
done

find "$EXTENSIONS_DIR" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} + 2>/dev/null || true

for ext_dir in "$PACK_DIR/extensions"/*/; do
  ext_name=$(basename "$ext_dir")
  cp -r "$ext_dir" "$EXTENSIONS_DIR/$ext_name"
done

if [ -f "$EXTENSIONS_DIR/extensions.json" ]; then
  TEMP_MERGED=$(mktemp)
  python3 -c "
import json
with open('$EXTENSIONS_DIR/extensions.json') as f: existing = json.load(f)
with open('$PACK_DIR/extensions/extensions.json') as f: source = json.load(f)
for k, v in source.items():
    if k not in existing:
        existing[k] = v
with open('$TEMP_MERGED', 'w') as f: json.dump(existing, f, indent=2)
" 2>/dev/null
  cp "$TEMP_MERGED" "$EXTENSIONS_DIR/extensions.json"
  rm -f "$TEMP_MERGED"
else
  cp "$PACK_DIR/extensions/extensions.json" "$EXTENSIONS_DIR/extensions.json"
fi

if command -v git &> /dev/null && [ -d "$SCRIPT_ROOT/.git" ]; then
  if git -C "$SCRIPT_ROOT" rev-parse HEAD &>/dev/null; then
    git -C "$SCRIPT_ROOT" rev-parse HEAD > "$LIFTOFF_DIR/.liftoff-version" 2>/dev/null
  fi
fi
