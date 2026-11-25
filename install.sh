#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGETS=(
  "$HOME/.gemini/config/skills"
  "$HOME/.codex/skills"
  "$HOME/.claude/skills"
  "$HOME/.agents/skills"
)

for target in "${TARGETS[@]}"; do
  mkdir -p "$target"
  for skill in diseno-sobrio revision-con-evidencia; do
    ln -sfn "$REPO_DIR/skills/$skill" "$target/$skill"
    echo "Linked $skill -> $target/$skill"
  done
done
