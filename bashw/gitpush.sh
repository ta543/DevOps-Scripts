#!/bin/bash

# Set commit message to "."
commit_message="."

# Add all changes
git add .

# Commit with the message "."
git commit -m "$commit_message"

# Push to the current branch
if git push; then
    # Use ANSI 256-color mode for bright yellow (approx to #FFD700)
    echo -e "\033[38;5;226m[PASSED]\033[0m Changes have been pushed successfully."
else
    # Bright red for failure
    echo -e "\033[38;5;196m[FAILED]\033[0m Push failed. Check for errors."
fi
