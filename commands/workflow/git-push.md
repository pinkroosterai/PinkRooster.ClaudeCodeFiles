# Git Push Command

Automatically adds, commits, and pushes changes to GitHub with proper safety checks and interactive commit message handling.

---
tools: [Bash, Read, Grep, LS]
agent_suggestions: []
template_type: workflow
namespace: workflow
---

## Context Gathering

First, let's check the current git status and gather context:

```bash
!git status --porcelain
!git branch --show-current
!git remote -v
!git log --oneline -5
```

## Safety Checks

Before proceeding with any git operations, verify:

1. **Repository Status**: Ensure we're in a valid git repository
2. **Remote Configuration**: Verify GitHub remote is properly configured
3. **Branch Protection**: Check if we're on a protected branch
4. **Uncommitted Changes**: Identify what files will be added and committed

```bash
# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    exit 1
fi

# Check for remote origin
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "❌ Error: No 'origin' remote configured"
    exit 1
fi

# Show current status
echo "📊 Current Git Status:"
git status --short

# Check for untracked/modified files
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "✅ No changes to commit"
    exit 0
fi
```

## Interactive Commit Message

Generate an intelligent commit message based on the changes:

```bash
echo "🔍 Analyzing changes for commit message..."

# Get list of changed files
CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null || echo "")
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || echo "")
UNTRACKED_FILES=$(git ls-files --others --exclude-standard)

# Combine all changes
ALL_CHANGES="$CHANGED_FILES $STAGED_FILES $UNTRACKED_FILES"

if [ -n "$ALL_CHANGES" ]; then
    echo "📝 Files to be committed:"
    echo "$ALL_CHANGES" | tr ' ' '\n' | sort -u | sed 's/^/  - /'
    echo ""
fi

# Generate suggested commit message based on file patterns
SUGGESTED_MSG=""
if echo "$ALL_CHANGES" | grep -q "\.md$"; then
    SUGGESTED_MSG="Update documentation"
elif echo "$ALL_CHANGES" | grep -q "test"; then
    SUGGESTED_MSG="Add/update tests"
elif echo "$ALL_CHANGES" | grep -q "config\|settings"; then
    SUGGESTED_MSG="Update configuration"
elif echo "$ALL_CHANGES" | grep -q "\.cs$\|\.js$\|\.py$\|\.java$"; then
    SUGGESTED_MSG="Update source code"
else
    SUGGESTED_MSG="Update project files"
fi

echo "💡 Suggested commit message: $SUGGESTED_MSG"
echo ""
```

## Git Operations Workflow

Execute the complete git workflow with error handling:

```bash
echo "🚀 Starting Git Push Workflow..."

# Step 1: Add all changes
echo "📦 Adding changes..."
if git add .; then
    echo "✅ Successfully added all changes"
else
    echo "❌ Failed to add changes"
    exit 1
fi

# Step 2: Get commit message
if [ -n "$ARGUMENTS" ]; then
    COMMIT_MSG="$ARGUMENTS"
    echo "📝 Using provided commit message: $COMMIT_MSG"
else
    echo "📝 Please enter commit message (or press Enter to use suggested): $SUGGESTED_MSG"
    read USER_INPUT
    if [ -n "$USER_INPUT" ]; then
        COMMIT_MSG="$USER_INPUT"
    else
        COMMIT_MSG="$SUGGESTED_MSG"
    fi
fi

# Step 3: Commit changes
echo "💾 Committing changes..."
if git commit -m "$COMMIT_MSG"; then
    echo "✅ Successfully committed changes"
else
    echo "❌ Failed to commit changes"
    exit 1
fi

# Step 4: Push to remote
CURRENT_BRANCH=$(git branch --show-current)
echo "🌐 Pushing to origin/$CURRENT_BRANCH..."

if git push origin "$CURRENT_BRANCH"; then
    echo "✅ Successfully pushed to GitHub!"
    echo "🔗 Changes are now available on GitHub"
else
    echo "❌ Failed to push to GitHub"
    echo "🔄 You may need to pull first if there are remote changes"
    echo "💡 Try running: git pull origin $CURRENT_BRANCH"
    exit 1
fi
```

## Post-Push Verification

Verify the push was successful:

```bash
echo "🔍 Verifying push..."

# Check if local and remote are in sync
LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/$(git branch --show-current) 2>/dev/null || echo "")

if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    echo "✅ Local and remote branches are in sync"
    echo "📊 Latest commit: $LOCAL_COMMIT"
else
    echo "⚠️  Local and remote may not be in sync"
    echo "🔄 Consider running: git fetch origin"
fi

# Show final status
echo ""
echo "📈 Final Status:"
git status --short
git log --oneline -1
```

## Error Recovery

Handle common error scenarios:

```bash
# If push fails due to non-fast-forward
if [ $? -eq 1 ]; then
    echo ""
    echo "🛠️  Common Solutions:"
    echo "  1. Pull latest changes: git pull origin $(git branch --show-current)"
    echo "  2. Force push (use with caution): git push --force-with-lease"
    echo "  3. Rebase your changes: git pull --rebase origin $(git branch --show-current)"
fi
```

## Usage Examples

```bash
# Basic usage - will prompt for commit message
/git-push

# With custom commit message
/git-push "Add new feature for user authentication"

# Quick commit with auto-generated message
/git-push
# (then press Enter to accept suggested message)
```

## Safety Features

- ✅ Validates git repository exists
- ✅ Checks for proper remote configuration
- ✅ Shows what files will be committed
- ✅ Provides intelligent commit message suggestions
- ✅ Handles interactive commit message input
- ✅ Comprehensive error handling and recovery suggestions
- ✅ Post-push verification
- ✅ Clear success/failure feedback

## Integration Notes

This command works best when:
- You're in a properly configured git repository
- You have push access to the GitHub repository
- Your local branch is properly set up to track the remote branch
- You want a streamlined workflow for common git operations

For complex scenarios (merge conflicts, rebasing, etc.), use individual git commands or specialized tools.