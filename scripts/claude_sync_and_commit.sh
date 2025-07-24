#!/bin/bash
set -e

# Copy files and folders from ~/.claude to project root
cp -f ~/.claude/CLAUDE.md ./CLAUDE.md
rsync -a --delete ~/.claude/commands ./ || cp -r ~/.claude/commands ./ # fallback if rsync not available
rsync -a --delete ~/.claude/agents ./ || cp -r ~/.claude/agents ./    # fallback if rsync not available

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
