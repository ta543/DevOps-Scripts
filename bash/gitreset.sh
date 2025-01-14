#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the current branch name
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Ensure we are in a Git repository
if [ -z "$CURRENT_BRANCH" ]; then
    echo "Error: Not in a Git repository."
    exit 1
fi

echo "Current branch: $CURRENT_BRANCH"

# Fetch the latest changes from the remote
echo "Fetching latest changes from origin..."
git fetch origin

# Check if 'main' or 'master' exists in the remote
if git show-ref --verify --quiet refs/remotes/origin/main; then
    DEFAULT_BRANCH="main"
elif git show-ref --verify --quiet refs/remotes/origin/master; then
    DEFAULT_BRANCH="master"
else
    echo "Error: Neither 'main' nor 'master' exists in the remote repository."
    exit 1
fi

echo "Default branch detected: 'origin/$DEFAULT_BRANCH'"

# Reset the current branch to match the default branch
echo "Resetting branch '$CURRENT_BRANCH' to match 'origin/$DEFAULT_BRANCH'..."
git reset --hard "origin/$DEFAULT_BRANCH"

# Force push the current branch
echo "Force pushing branch '$CURRENT_BRANCH' to remote..."
git push origin "$CURRENT_BRANCH" --force

echo "Branch '$CURRENT_BRANCH' has been successfully reset and force pushed."
