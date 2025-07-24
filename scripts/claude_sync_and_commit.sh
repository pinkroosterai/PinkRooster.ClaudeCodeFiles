#!/bin/bash
set -e

DRY_RUN=0

# Parse arguments
for arg in "$@"; do
  case $arg in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
  esac
done

# Copy files and folders from ~/.claude to project root

# Copy CLAUDE.md if it exists
if [ -f ~/.claude/CLAUDE.md ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY RUN] Would copy ~/.claude/CLAUDE.md to ./CLAUDE.md"
  else
    cp -f ~/.claude/CLAUDE.md ./CLAUDE.md
  fi
fi

# Copy commands folder if it exists
if [ -d ~/.claude/commands ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY RUN] Would sync/copy ~/.claude/commands to ./commands"
  else
    rsync -a --delete ~/.claude/commands ./ 2>/dev/null || cp -r ~/.claude/commands ./
  fi
fi

# Copy agents folder if it exists
if [ -d ~/.claude/agents ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[DRY RUN] Would sync/copy ~/.claude/agents to ./agents"
  else
    rsync -a --delete ~/.claude/agents ./ 2>/dev/null || cp -r ~/.claude/agents ./
  fi
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "[DRY RUN] Would stage changes: git add CLAUDE.md commands agents"
  echo "[DRY RUN] Would show staged diff:"
  git diff --cached
  echo "[DRY RUN] Would generate commit message and push (skipped in dry run)."
  exit 0
fi

# Stage the changes
git add CLAUDE.md commands agents

# Get the git diff for the staged changes
CHANGES=$(git diff --cached)

if [ -z "$CHANGES" ]; then
  echo "No changes to commit."
  exit 0
fi

# Prepare prompt for Claude
PROMPT="Write a concise, clear git commit message for the following changes:\n\n$CHANGES"

# Use Claude API to generate commit message (requires 'claude' CLI tool or similar)
# Replace the following line with your actual Claude API/CLI call if different
COMMIT_MSG=$(claude chat --system "You are a helpful commit message generator." --user "$PROMPT" --output text)

if [ -z "$COMMIT_MSG" ]; then
  echo "Failed to generate commit message."
  exit 1
fi

# Commit and push
git commit -m "$COMMIT_MSG"
git push
