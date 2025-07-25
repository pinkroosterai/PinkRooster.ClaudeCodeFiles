#!/bin/bash
set -e

# Simple test runner for claude_sync_and_commit.sh

echo "Running dry run test..."
bash scripts/claude_sync_and_commit.sh --dry-run

echo "Dry run test completed."

echo "Running real sync/commit test (will not push if no changes)..."
bash scripts/claude_sync_and_commit.sh

echo "Real sync/commit test completed."