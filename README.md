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

```leaks
curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s install
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s install
```

This command will download and run the gitleaks script, which will install the Gitleaks pre-commit hook in your repository.
Usage

Once the pre-commit hook is installed, it will automatically run Gitleaks before each commit to check for sensitive information. If any issues are found, the commit will be rejected.

You can also manually run Gitleaks at any time by executing the following command in Git Bash:
gitleaks detect -v --redact
This command will perform a Gitleaks scan on the entire Git history.

# Unix-based Systems

To install Gitleaks on Unix-based systems (e.g., Linux, macOS), run the following command in your terminal:

```leaks
curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s install
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s install

curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | sh -s install
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | sh -s install
```

# Uninstallation

To uninstall the Gitleaks pre-commit hook, follow these steps:

    Open Git Bash on your Windows machine.
    Navigate to the root directory of your Git repository.
    Run the following command in Git Bash:

```leaks
curl -sSfL https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | bash -s uninstall
wget -qO- https://raw.githubusercontent.com/bartaadalbert/leaks/master/gitleaks.sh | sh -s uninstall
```

This command will download and run the gitleaks script, which will remove the Gitleaks pre-commit hook from your repository.
Note: Make sure to run the uninstall command from the same repository where you previously installed the pre-commit hook.

That's it! You have successfully uninstalled Gitleaks from your Git repository.


# Usage

Once Gitleaks is installed, you can use it to scan your Git repositories for sensitive information. The pre-commit hook will automatically run Gitleaks before each commit.

If Gitleaks is enabled, it will check the entire git history for leaks and scan the staged changes for leaks. If any sensitive information is detected, the commit will be rejected.

If Gitleaks is disabled, it will skip the checks and allow the commit to proceed.


# For macOS Users

After installing the gitleaks binary, you may encounter a security warning that prevents you from running it because it's from an unidentified developer. To allow the execution of gitleaks, follow these steps:

    Try to run gitleaks once from the terminal. You will likely see a message that says the app cannot be opened because it is from an unidentified developer.

    Open System Preferences. You can do this by clicking on the Apple icon in the top-left corner of your screen and selecting “System Preferences.”

    Go to “Security & Privacy”.

    Switch to the “General” tab.

    At the bottom of the “General” tab, you should see a message like “‘gitleaks’ was blocked from use because it is not from an identified developer.”

    Click the “Open Anyway” button. This will create an exception for gitleaks and you will be able to run it in the future without any issues.

Please note that this procedure should be done with caution and only for software that you trust.

## Enabling or Disabling Gitleaks

You can enable or disable the Gitleaks pre-commit hook by using `git config`:

- **To enable Gitleaks:**
git config hooks.gitleaks true
- **To disable Gitleaks:**
git config hooks.gitleaks false

By default, Gitleaks is enabled. You can use these commands to control whether Gitleaks should be applied before each commit.




# License

This project is licensed under the MIT License.

Feel free to modify and customize the installation and usage instructions based on your specific requirements.