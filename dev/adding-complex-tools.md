# Adding Complex Tools to Dotfiles

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
