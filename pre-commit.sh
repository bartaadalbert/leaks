#!/bin/bash

# ANSI escape codes for colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET_COLOR='\033[0m'

# Define the gitleaks version this i see now in actual you need to change it!!! OR IT WILL BE THE LATEST BY DEFAULT
# GITLEAKS_VERSION="8.17.0"
# GITLEAKS_LATEST_RELEASE_JSON=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest)
# GITLEAKS_VERSION=$(echo "$GITLEAKS_LATEST_RELEASE_JSON" | grep -Po '"tag_name": "\K.*?(?=")')
# GITLEAKS_VERSION=${GITLEAKS_VERSION:1} # Remove the 'v' at start
GITLEAKS_LATEST_RELEASE_JSON=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest)
GITLEAKS_VERSION=$(echo "$GITLEAKS_LATEST_RELEASE_JSON" | grep -Eo '"tag_name": "[^"]+"' | cut -d'"' -f4)

# Remove the 'v' at the start of the version if present
if [[ $GITLEAKS_VERSION == v* ]]; then
  GITLEAKS_VERSION=${GITLEAKS_VERSION:1}
fi

#DEBUG VERSION
# echo $GITLEAKS_VERSION
# exit 0

# Define an array of supported OS types
SUPPORTED_OS=("linux" "darwin" "windows")

# Debugging mode on
# set -x

# Detect the operating system
UNAME_OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [[ "$UNAME_OS" == "mingw"* ]]; then
    OS="windows"
else
    OS=$UNAME_OS
fi


# Detect arch
ARCH=$(uname -m)

# declare -A SUPPORTED_ARCHITECTURES_linux=(
#     ["x86_64"]="x64" 
#     ["aarch64"]="arm64" 
#     ["armv6"]="armv6" 
#     ["armv7"]="armv7"
# )
# declare -A SUPPORTED_ARCHITECTURES_darwin=(
#     ["x86_64"]="x64" 
#     ["arm64"]="arm64"
# )
# declare -A SUPPORTED_ARCHITECTURES_windows=(
#     ["x86_64"]="amd64" 
#     ["arm64"]="arm64"
# )
SUPPORTED_ARCHITECTURES_linux=("x86_64:x64" "aarch64:arm64" "armv6:armv6" "armv7:armv7")
SUPPORTED_ARCHITECTURES_darwin=("x86_64:x64" "arm64:arm64")
SUPPORTED_ARCHITECTURES_windows=("x86_64:amd64" "arm64:arm64")

#GET the archname from supported arch indexed arrays (key:value)
get_arch_name() {
    local -n arr=$1
    local arch=$2
    for item in "${arr[@]}"; do
        IFS=":" read -r key value <<< "$item"
        if [[ "$key" == "$arch" ]]; then
            echo "$value"
            return
        fi
    done
}

# Check if gitleaks is installed
if ! command -v gitleaks &> /dev/null; then
    echo -e "${YELLOW}Gitleaks not found, will be install...${RESET_COLOR}"
    ARCH_NAME=""

    if [[ " ${SUPPORTED_OS[@]} " =~ " ${OS} " ]]; then
        # archs_var="SUPPORTED_ARCHITECTURES_${OS}[$ARCH]"
        # ARCH_NAME=${!archs_var}
        arch_name_var="SUPPORTED_ARCHITECTURES_${OS}"
        ARCH_NAME=$(get_arch_name "$arch_name_var" "$ARCH")
        if [ -n "$ARCH_NAME" ]; then
            EXTENSION="tar.gz"
            if [[ "$OS" == "windows" ]]; then
                EXTENSION="zip"
            fi
            GITLEAKS_URL="https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_${OS}_${ARCH_NAME}.${EXTENSION}"
        else
            echo -e "${RED}Not supported arch: $ARCH${RESET_COLOR}"
            exit 1
        fi
    else
        echo -e "${RED}Not supported OS: $OS${RESET_COLOR}"
        exit 1
    fi

    #DEBUG, get the download bin url for os type and arch
    #echo $GITLEAKS_URL

    # Download and extract gitleaks
    # curl -LO "$GITLEAKS_URL"

    # Create a temporary directory
    TMP_DIR="./temp_dir"
    mkdir -p "$TMP_DIR"

    echo -e "${GREEN}Temporary directory created at: $TMP_DIR ${RESET_COLOR}"
    curl -L "$GITLEAKS_URL" -o "${TMP_DIR}/gitleaks.tar.gz"

    #ERROR URL
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error downloading Gitleaks${RESET_COLOR}"
        exit 1
    fi

    # if [[ "$OS" == "windows"* ]]; then
    #     unzip "gitleaks_${GITLEAKS_VERSION}_${OS}_${ARCH_NAME}.zip"
    # else
    #     tar -zxf "gitleaks_${GITLEAKS_VERSION}_${OS}_${ARCH_NAME}.tar.gz"
    # fi

    # Change to the temporary directory
    cd $TMP_DIR

    # Extract gitleaks
    tar -zxf gitleaks.tar.gz

    #ERROR UNTAR UNZIP
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error extracting Gitleaks${RESET_COLOR}"
        exit 1
    fi

    # WE need to clean our temp dir from archive
    rm -f *.tar.gz
    rm -f *.zip
    # rm -rf gitleaks_${GITLEAKS_VERSION}_${OS}_${ARCH_NAME}*

    # Move the gitleaks binary to the appropriate location
    if [[ "$OS" == "darwin" || "$OS" == "linux" ]]; then
        DEST_DIR="/usr/local/bin/"
    elif [[ "$OS" == "windows"* ]]; then
        # Get the current user's username
        USERNAME=$(echo $USERNAME)

        # Set the destination directory based on the username
        if [ "$USERNAME" == "Administrator" ]; then
            DEST_DIR='/c/Program Files/gitleaks'
        else
            DEST_DIR="/c/Users/$USERNAME/AppData/Local/Programs/gitleaks"
        fi
    fi

    #move binary to sest directory
    # sudo mv gitleaks* $DEST_DIR
    mv gitleaks* $DEST_DIR

    # Check if the move was successful
    if [ $? -ne 0 ]; then
        # If the move was not successful, try using sudo
        echo -e "${YELLOW}Attempting to move gitleaks binary with sudo...${RESET_COLOR}"
        sudo mv gitleaks* $DEST_DIR
        
        # Check if the sudo move was successful
        if [ $? -ne 0 ]; then
            echo -e "${RED}Error moving Gitleaks to destination directory${RESET_COLOR}"
            exit 1
        fi
    fi

    # Clean up by removing the temporary directory
    rm -rf $TMP_DIR

    #BY DEFULT pre-commit enabled with true text
    git config hooks.gitleaks true

    #ERROR INSTALL TO DIRECTORY
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error moving Gitleaks to destination directory${RESET_COLOR}"
        exit 1
    fi

fi


# Check if gitleaks is enabled
gitleaks_hook=$(git config --bool hooks.gitleaks)

if [[ "$gitleaks_hook" == "true" ]]; then
    echo -e "${GREEN}Gitleaks is enabled. Running gitleaks...${RESET_COLOR}"
    
    # Run gitleaks
    echo -e "${YELLOW}Run gitleaks......${RESET_COLOR}"


    # Check entire git history for leaks
    echo -e "${YELLOW}Checking git history for leaks...${RESET_COLOR}"
    
    gitleaks detect -v --redact --log-opts "origin..HEAD"

    if [ $? -eq 1 ]
    then
        echo -e "${RED}Gitleaks has detected sensitive information in your git history, please clean up your history before committing!${RESET_COLOR}"
        exit 1
    fi

    # Check staged changes for leaks
    echo -e "${YELLOW}Checking staged changes for leaks...${RESET_COLOR}"
    gitleaks protect -v --staged --redact

    # Check gitleaks exit code
    if [ $? -eq 1 ]
    then
        echo -e "${RED}Gitleaks has detected sensitive information in your changes, commit rejected!${RESET_COLOR}"
        exit 1
    else
        echo -e "${GREEN}Gitleaks found no issues, proceeding with commit...${RESET_COLOR}"
        exit 0
    fi
else
    echo -e "${YELLOW}Gitleaks is disabled. Skipping gitleaks checks...${RESET_COLOR}"
fi


check_gitignore() {
    local gitignore_file="../../.gitignore"
    local patterns=("terraform.tfstate" ".terraform" "*.tfvars")
    local all_patterns_present=true

    if [ ! -f "$gitignore_file" ]; then
        echo -e "${RED}.gitignore file not found${RESET_COLOR}"
        return 1
    fi

    for pattern in "${patterns[@]}"; do
        if ! grep -q "^${pattern}$" "$gitignore_file"; then
            all_patterns_present=false
            echo -e "${RED}Pattern '$pattern' is not in .gitignore file${RESET_COLOR}"
        fi
    done

    if ! $all_patterns_present; then
        echo -e "${RED}Please add the missing patterns  '$pattern' to .gitignore before committing.${RESET_COLOR}"
        return 1
    fi

    echo -e "${GREEN}All required patterns are present in .gitignore. Proceeding with commit.${RESET_COLOR}"
    return 0
}

# Check if .terraform directory exists and required patterns in .gitignore
if [ -d ".terraform" ] || [ -n "$(find . -name '*.tfstate' -o -name '*.tfvars')" ]; then
    # Call the function to check .gitignore
    check_gitignore
else
    echo -e "${GREEN}.terraform directory not found. Skipping .gitignore check.${RESET_COLOR}"
fi
