#!/bin/bash

# Set commit message to "."
commit_message="."

# Add all changes
git add .

# Commit with the message "."
git commit -m "$commit_message" > /dev/null 2>&1

# Push to the current branch
if git push > /dev/null 2>&1; then
    # Print [PASSED] in bright yellow and "Changes have been pushed successfully."
    echo -e "\033[1;93m[PASSED]\033[0m Changes have been pushed successfully."
else
    # Print [FAILED] in bright red if push fails
    echo -e "\033[1;91m[FAILED]\033[0m Push failed. Check for errors."
fi
