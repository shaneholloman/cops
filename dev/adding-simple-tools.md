# Adding New Tools to Cops

## TLDR: Quick Example

To add a new tool (e.g., terraform-docs):

1. Add to config.yaml:

    ```yaml
    tools:
      cli:
        - terraform-docs  # Add here
    ```

2. If command name differs from package name, add mapping in lib/config.sh:

    > [!IMPORTANT]
    > This is a gotcha! Watch out for this!

    ```bash
    get_command_name() {
      local tool="$1"
      case "$tool" in
      "awscli") echo "aws" ;;
      "kubernetes-cli") echo "kubectl" ;;
      "terraform-docs") echo "terraform-docs" ;; # Add here if needed
      *) echo "$tool" ;;
      esac
    }
    ```

That's it! The script will automatically:

- Detect if the tool is installed
- Install it if missing
- Validate the installation

## Detailed Guide

### Files Overview

1. `config.yaml`: Main configuration file
   - Lists all tools to install
   - Grouped by type (cli, cask)

2. `lib/config.sh`: Command name mapping
   - Maps package names to executable names
   - Only needed if they differ (e.g., awscli → aws)

3. `lib/checks.sh`: Tool detection
   - Checks if tools are installed
   - Uses get_command_name() for consistent naming

4. `lib/main.sh`: Installation planning
   - Determines which tools need installation
   - Uses get_command_name() for detection

5. `lib/install.sh`: Installation and validation
   - Handles tool installation via Homebrew
   - Validates successful installation

### Key Concepts

1. Package vs Command Names
   - Package name: Name used by package manager (e.g., awscli)
   - Command name: Actual executable name (e.g., aws)
   - Must be mapped if they differ

2. Tool Detection
   - Uses `command -v` to check if tool exists
   - Checks command name, not package name
   - Version info displayed when available

3. Installation Process
   - Tools listed in config.yaml
   - Missing tools added to CLI_TOOLS_TO_INSTALL
   - Installed via Homebrew
   - Validated post-installation

### Coding Standards

1. Command Name Mapping
   - Add to get_command_name() only if names differ
   - Keep case statement alphabetically ordered
   - Use double quotes for string literals

2. Tool Configuration
   - Add tools under appropriate section in config.yaml
   - Keep lists alphabetically ordered
   - Use consistent indentation (2 spaces)

3. Error Handling
   - All commands use set -e for immediate error detection
   - Failed installations are reported clearly
   - Version detection failures handled gracefully

### Best Practices

1. Testing New Tools
   - Test both installation and removal scenarios
   - Verify version detection works
   - Check all validation steps pass

2. Documentation
   - Update this guide if adding new concepts
   - Document any special handling requirements
   - Keep examples current

3. Maintainability
   - Follow existing patterns for consistency
   - Keep command mappings centralized
   - Use meaningful variable names

### Common Pitfalls

1. Command Name Mismatch
   - Always verify actual command name
   - Test with command -v before adding
   - Update mapping if needed

2. Version Detection
   - Some tools use non-standard version flags
   - Test --version and -v
   - Handle missing version info gracefully

3. Installation Validation
   - Check both package and command existence
   - Verify command actually works
   - Test with realistic usage scenarios
