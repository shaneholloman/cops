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

1. Missing Source in cops-setup.sh
   - When adding new lib/*.sh modules
   - Must add source line in cops-setup.sh
   - Follow existing pattern with shellcheck directives:

     ```bash
     # shellcheck source=lib/your_module.sh
     # shellcheck disable=SC1091
     source "${LIB_DIR}/your_module.sh"
     ```

   - Run analyze-scripts.sh to verify source is properly added

2. Command Name Mismatch
   - Always verify actual command name
   - Test with command -v before adding
   - Update mapping if needed

3. Version Detection
   - Some tools use non-standard version flags
   - Test --version and -v
   - Handle missing version info gracefully

4. Installation Validation
   - Check both package and command existence
   - Verify command actually works
   - Test with realistic usage scenarios
# Adding Complex Tools to Cops

## TLDR: Quick Example (iTerm2)

1. Add to config.yaml:

    ```yaml
    tools:
      cask:
        - iterm2  # Add here
    ```

2. Add setup function in lib/setup.sh:

    ```bash
    setup_iterm2() {
      print_header "Setting up iTerm2 configuration"

      if [[ -d "/Applications/iTerm.app" ]]; then
        # Your configuration commands here
        defaults write com.apple.Terminal "Default Window Settings" -string "iTerm2"
        print_success "iTerm2 configuration completed successfully"
      else
        print_warning "iTerm2 not installed - skipping configuration"
      fi
    }
    ```

3. Add function call in main() in lib/main.sh:

    ```bash
    main() {
      # ... other setup functions ...
      setup_iterm2
      # ... rest of setup ...
    }
    ```

## Detailed Guide

### When to Use Complex Setup

1. Tool requires:
   - System preferences changes
   - Default application settings
   - File associations
   - Additional configuration files
   - Integration with other tools
   - Post-installation tasks

2. Examples of complex tools:
   - Terminal emulators (iTerm2)
   - IDEs (VS Code)
   - System utilities (Alfred)
   - Development environments

### File Structure

1. `config.yaml`:
   - Add tool under appropriate section (usually 'cask')
   - May need additional configuration sections

2. `lib/setup.sh`:
   - Contains setup functions for complex tools
   - Each tool gets its own function
   - Function naming: setup_toolname()

3. `lib/main.sh`:
   - Calls setup functions in appropriate order
   - Handles dependencies between setups

### Setup Function Pattern

```bash
setup_toolname() {
  print_header "Setting up ToolName configuration"

  # 1. Check if tool is installed
  if [[ -d "/Applications/Tool.app" ]]; then

    # 2. Backup existing configuration (if needed)
    backup_existing_config

    # 3. Apply configurations
    if ! apply_config_command; then
      print_error "Failed to configure specific setting"
      return 1
    fi

    # 4. Verify changes
    verify_changes

    # 5. Report success
    print_success "ToolName configuration completed successfully"
  else
    print_warning "ToolName not installed - skipping configuration"
  fi
}
```

### Coding Standards

1. Function Structure:
   - Clear header with print_header
   - Installation check
   - Logical grouping of related settings
   - Error handling for each operation
   - Success/warning messages
   - Return codes for error handling

2. Configuration Commands:
   - Use if statements for error checking
   - Group related settings
   - Comment complex operations
   - Use variables for repeated values

3. Error Handling:
   - Check each critical operation
   - Use return 1 for failures
   - Provide clear error messages
   - Handle missing dependencies
   - Notify users when restart is required

4. System Changes:
   - Identify which changes require restart
   - Warn users about pending restart requirements
   - Group restart-requiring changes together when possible
   - Document restart requirements in comments

### Best Practices

1. Configuration Management:
   - Backup existing configurations
   - Use defaults command for macOS settings
   - Document each setting's purpose
   - Group related settings together

2. Testing:
   - Test on fresh installation
   - Test with existing configurations
   - Verify each setting applies correctly
   - Test failure scenarios

3. User Experience:
   - Clear progress messages
   - Meaningful error messages
   - Skip gracefully if tool missing
   - Maintain idempotency

### Common Patterns

1. macOS Settings:

    ```bash
    # System Preferences
    defaults write domain key value

    # App-specific settings
    defaults write com.app.name setting value

    # Restart services
    killall ServiceName
    ```

2. File Operations:

    ```bash
    # Backup
    [[ -f $config ]] && cp "$config" "$config.backup"

    # Create directories
    mkdir -p "$config_dir"

    # Copy configurations
    cp "$source" "$destination"
    ```

3. Permission Changes:

    ```bash
    # Fix ownership
    chown -R "$(whoami)" "$config_dir"

    # Set permissions
    chmod 600 "$config_file"
    ```

### Troubleshooting Guide

1. Common Issues:
   - Permission denied: Check file/directory ownership
   - Configuration not applying: Verify defaults command syntax
   - Tool not detected: Check installation path
   - Settings not persisting: Check write permissions

2. Debugging:
   - Use print_warning for diagnostic messages
   - Check return codes of critical operations
   - Verify file paths exist
   - Test commands manually first

3. Recovery:
   - Implement backup/restore functionality
   - Document manual recovery steps
   - Provide rollback capabilities
