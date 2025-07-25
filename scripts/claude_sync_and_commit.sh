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
  # Create a temporary worktree for dry run
  DRY_RUN_WORKTREE=".claude_dry_run_worktree"
  DRY_RUN_BRANCH="claude-dry-run-tmp"
  # Remove worktree and branch if they exist
  if git worktree list | grep -q "$DRY_RUN_WORKTREE"; then
    echo "[DRY RUN] Removing existing dry run worktree at $DRY_RUN_WORKTREE"
    git worktree remove --force "$DRY_RUN_WORKTREE"
  fi
  if git branch --list | grep -q "$DRY_RUN_BRANCH"; then
    echo "[DRY RUN] Removing existing dry run branch $DRY_RUN_BRANCH"
    git branch -D "$DRY_RUN_BRANCH"
  fi
  echo "[DRY RUN] Creating worktree at $DRY_RUN_WORKTREE on branch $DRY_RUN_BRANCH"
  git worktree add -b "$DRY_RUN_BRANCH" "$DRY_RUN_WORKTREE"
  pushd "$DRY_RUN_WORKTREE" > /dev/null

  # Simulate the copy operations in the worktree
  if [ -f ~/.claude/CLAUDE.md ]; then
    echo "[DRY RUN] Would copy ~/.claude/CLAUDE.md to $DRY_RUN_WORKTREE/CLAUDE.md"
    cp -f ~/.claude/CLAUDE.md ./CLAUDE.md
  fi
  if [ -d ~/.claude/commands ]; then
    echo "[DRY RUN] Would sync/copy ~/.claude/commands to $DRY_RUN_WORKTREE/commands"
    rsync -a --delete ~/.claude/commands ./ 2>/dev/null || cp -r ~/.claude/commands ./
  fi
  if [ -d ~/.claude/agents ]; then
    echo "[DRY RUN] Would sync/copy ~/.claude/agents to $DRY_RUN_WORKTREE/agents"
    rsync -a --delete ~/.claude/agents ./ 2>/dev/null || cp -r ~/.claude/agents ./
  fi

  # Stage the changes that exist in the dry run worktree
  DRY_ADD_PATHS=()
  [ -f CLAUDE.md ] && DRY_ADD_PATHS+=("CLAUDE.md")
  [ -d commands ] && DRY_ADD_PATHS+=("commands")
  [ -d agents ] && DRY_ADD_PATHS+=("agents")
  
  if [ "${#DRY_ADD_PATHS[@]}" -gt 0 ]; then
    git add "${DRY_ADD_PATHS[@]}"
  fi
  echo "[DRY RUN] Would show staged diff:"
  git diff --cached || true
  echo "[DRY RUN] Would generate commit message and push (skipped in dry run)."

  popd > /dev/null
  echo "[DRY RUN] Cleaning up dry run worktree at $DRY_RUN_WORKTREE"
  git worktree remove --force "$DRY_RUN_WORKTREE"
  if git branch --list | grep -q "$DRY_RUN_BRANCH"; then
    git branch -D "$DRY_RUN_BRANCH"
  fi

  exit 0
fi

# Stage the changes if they exist
ADD_PATHS=()
[ -f CLAUDE.md ] && ADD_PATHS+=("CLAUDE.md")
[ -d commands ] && ADD_PATHS+=("commands")
[ -d agents ] && ADD_PATHS+=("agents")

if [ "${#ADD_PATHS[@]}" -eq 0 ]; then
  echo "No files to add or commit."
  exit 0
fi

git add "${ADD_PATHS[@]}"

# Get the git diff for the staged changes
CHANGES=$(git diff --cached)

if [ -z "$CHANGES" ]; then
  echo "No changes to commit."
  exit 0
fi

# Prepare prompt for Claude
PROMPT="Write a concise, clear git commit message for the following changes:\n\n$CHANGES"

# Use Claude API to generate commit message (requires 'claude' CLI tool or similar)
# This version uses the most common Claude CLI syntax (no --system/--user flags)
COMMIT_MSG=$(echo -e "$PROMPT" | claude)

if [ -z "$COMMIT_MSG" ]; then
  echo "Failed to generate commit message."
  exit 1
fi

# Commit and push
git commit -m "$COMMIT_MSG"
git push
