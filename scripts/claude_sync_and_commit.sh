#!/bin/bash
set -e

# Copy files and folders from ~/.claude to project root

# Copy CLAUDE.md if it exists
if [ -f ~/.claude/CLAUDE.md ]; then
  cp -f ~/.claude/CLAUDE.md ./CLAUDE.md
fi

# Copy commands folder if it exists
if [ -d ~/.claude/commands ]; then
  rsync -a --delete ~/.claude/commands ./ 2>/dev/null || cp -r ~/.claude/commands ./ 
fi

# Copy agents folder if it exists
if [ -d ~/.claude/agents ]; then
  rsync -a --delete ~/.claude/agents ./ 2>/dev/null || cp -r ~/.claude/agents ./
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
