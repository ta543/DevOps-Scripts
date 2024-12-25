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
    echo -e "\e[33m[PASSED] Changes have been pushed successfully.\e[0m"
else
    # Print [FAILED] in red if push fails
    echo -e "\e[31m[FAILED] Push failed. Check for errors.\e[0m"
fi
