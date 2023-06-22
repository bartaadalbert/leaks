#!/bin/bash

# ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET_COLOR='\033[0m'

# Check if the script is being run by administrator user
if [ "$(id -u)" != "0" ] && [ "$(uname -o)" != "Msys" ]; then
    echo -e "${RED}This script must be run as administrator or with elevated privileges.${RESET_COLOR}" 1>&2
    exit 1
fi


# Install or uninstall pre-commit hook based on the argument
if [ "$1" != "-" ]; then
    curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/pre-commit.sh > .git/hooks/pre-commit
    # wget -O .git/hooks/pre-commit https://raw.githubusercontent.com/bartaadalbert/tf-pro/main/pre-commit.sh
    sudo chmod +x .git/hooks/pre-commit
    echo -e "${GREEN}Pre-commit hook installed successfully.${RESET_COLOR}"
elif [ "$1" == "-" ]; then
    sudo rm -f .git/hooks/pre-commit
    echo -e "${GREEN}Pre-commit hook uninstalled successfully.${RESET_COLOR}"
else
    echo -e "${YELLOW}Please specify '+' to install or '-' to uninstall.${RESET_COLOR}"
    exit 1
fi
