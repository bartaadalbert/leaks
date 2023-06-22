# Gitleaks Installation and Usage

This guide provides instructions for installing and using Gitleaks, a tool for detecting sensitive information in Git repositories.

# Requirements

    Git Bash (for Windows users)
    Root access or sudo privileges (for installation and uninstallation)

# Installation
To install Gitleaks and set up the pre-commit hook, follow these steps:

    Open Git Bash on your Windows machine.
    Navigate to the root directory of your Git repository.
    Run the following command in Git Bash:

curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/install.sh | bash -s
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s

This command will download and run the install script, which will install the Gitleaks pre-commit hook in your repository.
Usage

Once the pre-commit hook is installed, it will automatically run Gitleaks before each commit to check for sensitive information. If any issues are found, the commit will be rejected.

You can also manually run Gitleaks at any time by executing the following command in Git Bash:
gitleaks detect -v --redact
This command will perform a Gitleaks scan on the entire Git history.

# Unix-based Systems

To install Gitleaks on Unix-based systems (e.g., Linux, macOS), run the following command in your terminal:

curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/install.sh | bash -s
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s

curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/install.sh | sh
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | sh


# Uninstallation

To uninstall the Gitleaks pre-commit hook, follow these steps:

    Open Git Bash on your Windows machine.
    Navigate to the root directory of your Git repository.
    Run the following command in Git Bash:

curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/install.sh | bash -s +

This command will download and run the install script, which will remove the Gitleaks pre-commit hook from your repository.
Note: Make sure to run the uninstall command from the same repository where you previously installed the pre-commit hook.

That's it! You have successfully uninstalled Gitleaks from your Git repository.


# Usage

Once Gitleaks is installed, you can use it to scan your Git repositories for sensitive information. The pre-commit hook will automatically run Gitleaks before each commit.

If Gitleaks is enabled, it will check the entire git history for leaks and scan the staged changes for leaks. If any sensitive information is detected, the commit will be rejected.

If Gitleaks is disabled, it will skip the checks and allow the commit to proceed.



# License

This project is licensed under the MIT License.

Feel free to modify and customize the installation and usage instructions based on your specific requirements.