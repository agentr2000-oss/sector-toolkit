#!/bin/bash
# sync.sh — sync sector-toolkit files between repo and Code/.claude/
CLAUDE_DIR="$HOME/Claude/Code/.claude"
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
ACTION="${1:-push}"

if [ "$ACTION" = "push" ]; then
    echo "Pushing: Code/.claude/ → repo"
    cp "$CLAUDE_DIR"/agents/{sector-*,company-*}.md "$REPO_DIR/agents/"
    cp "$CLAUDE_DIR"/commands/sector-*.md "$REPO_DIR/commands/"
    cp "$CLAUDE_DIR"/skills/{epistemic-tags,research-standards,sector-checkpoint,sector-data-model}.md "$REPO_DIR/skills/"
    echo "Done. Review with: cd $REPO_DIR && git diff --stat"
elif [ "$ACTION" = "pull" ]; then
    echo "Pulling: repo → Code/.claude/"
    cp "$REPO_DIR"/agents/*.md "$CLAUDE_DIR/agents/"
    cp "$REPO_DIR"/commands/*.md "$CLAUDE_DIR/commands/"
    cp "$REPO_DIR"/skills/*.md "$CLAUDE_DIR/skills/"
    echo "Done. Files installed to $CLAUDE_DIR"
else
    echo "Usage: ./sync.sh [push|pull]"
fi
