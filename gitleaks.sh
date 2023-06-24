#!/bin/bash

# ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET_COLOR='\033[0m'

# Inform the user about the fix
echo -e "${GREEN}The issue with administrator privileges has been fixed. You were seeing the message because the script was checking for administrator privileges in an incompatible manner. It's now been commented out and the script should work without any issues.${RESET_COLOR}"

# Check if the script is being run by administrator user
# if [ "$(id -u)" != "0" ] && [ "$(uname -o)" != "Msys" ]; then
#     echo -e "${RED}This script must be run as administrator or with elevated privileges.${RESET_COLOR}" 1>&2
#     exit 1
# fi

# Check if the pre-commit hook is already installed
if [ -f .git/hooks/pre-commit ]; then
    echo -e "${YELLOW}Pre-commit hook is already installed.${RESET_COLOR}"
    echo -e "${YELLOW}Do you want to uninstall it? (yes/no)${RESET_COLOR}"
    read -r user_choice
    if [ "$user_choice" = "yes" ] || [ "$user_choice" = "y" ]; then
        rm -f .git/hooks/pre-commit
        echo -e "${RED}Pre-commit hook removed successfully.${RESET_COLOR}"
    else
        echo -e "${GREEN}Uninstallation canceled.${RESET_COLOR}"
    fi
else
    echo -e "${GREEN}Pre-commit hook is not installed. Do you want to install it? (yes/no)${RESET_COLOR}"
    read -r user_choice
    if [ "$user_choice" = "yes" ] || [ "$user_choice" = "y" ]; then
        curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/pre-commit.sh > .git/hooks/pre-commit
        chmod +x .git/hooks/pre-commit
        echo -e "${GREEN}Pre-commit hook installed successfully.${RESET_COLOR}"
    else
        echo -e "${YELLOW}Installation canceled.${RESET_COLOR}"
    fi
fi


