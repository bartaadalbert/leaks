# Gitleaks Installation and Usage

This guide provides instructions for installing and using Gitleaks, a tool for detecting sensitive information in Git repositories.
Installation

You can install Gitleaks using either curl or wget. Choose the appropriate method based on your preference.

# Installation with curl

To install Gitleaks using curl, run the following command in your terminal:

curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s

This command will download the installation script and execute it, installing Gitleaks on your system. You can use the argument -s - to disable Gitleaks or + or empty to enable it.

# Installation with wget

To install Gitleaks using wget, run the following command in your terminal:

wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s

This command will download the installation script and execute it, installing Gitleaks on your system. You can use the argument -s - to disable Gitleaks or + to enable it.

# Usage

Once Gitleaks is installed, you can use it to scan your Git repositories for sensitive information. The pre-commit hook will automatically run Gitleaks before each commit.

If Gitleaks is enabled, it will check the entire git history for leaks and scan the staged changes for leaks. If any sensitive information is detected, the commit will be rejected.

If Gitleaks is disabled, it will skip the checks and allow the commit to proceed.

# Uninstallation

If you wish to uninstall Gitleaks, you can run the following command:

curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s -
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s -

This command will download the installation script and execute it with the - argument, uninstalling Gitleaks from your system.

# License

This project is licensed under the MIT License.

Feel free to modify and customize the installation and usage instructions based on your specific requirements.