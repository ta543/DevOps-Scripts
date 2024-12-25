#!/bin/bash

# Set commit message to "."
commit_message="."

# Add all changes
git add .

# Commit with the message "."
git commit -m "$commit_message"

# Push to the current branch
if git push; then
    # Print [PASSED] in yellow if push succeeds
    echo -e "\033[1;33m[PASSED] Changes have been pushed successfully.\033[0m"
else
    # Print [FAILED] in red if push fails
    echo -e "\033[1;31m[FAILED] Push failed. Check for errors.\033[0m"
fi
