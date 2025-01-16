# Adding Master Switches to Cops

## Overview

Add top-level master switches to control entire feature sets in the cops configuration. This makes the system more approachable for new users while maintaining full power for advanced users.

## Current Status

Config.yaml currently has sections for different features:

- Preferences (system settings, terminal)
- Tools (CLI tools, cask apps)
- Aliases (shell aliases)
- Vim Configuration
- File Associations
- etc.

## Proposed Changes

### 1. Config Structure

Add master switches section at the top of config.yaml:

```yaml
# Master Switches
enable_preferences: false  # Disabled by default for safety
enable_tools: true        # Most users want tools
enable_aliases: true      # Shell aliases are safe
enable_vim: true         # Editor config is safe
enable_file_assoc: true  # File associations are safe

# Rest of configuration remains unchanged
preferences:
  terminal:
    font: 'Hack Nerd Font Mono 12'
  system:
    key_repeat: 1
    # ...

tools:
  cli:
    - awscli
    # ...
```

### 2. Implementation Steps

1. Update config.yaml:
   - Add master switches section
   - Document each switch's purpose
   - Set safe defaults

2. Modify lib/config.sh:

   ```bash
   # Add helper function
   is_feature_enabled() {
     local feature="$1"
     get_config ".enable_${feature}" || echo "false"
   }
   ```

3. Update setup functions:

   ```bash
   setup_preferences() {
     if ! is_feature_enabled "preferences"; then
       print_info "Preferences disabled, skipping..."
       return 0
     fi
     # Existing preference setup code
   }
   ```

4. Update main.sh flow:
   - Show master switches status before main confirmation
   - Add separate confirmation for enabled features
   - Skip disabled sections
   - Report skipped sections in summary

Example confirmation flow:

```sh
=== Master Switches Status ===
! System Preferences: ENABLED
  - This will modify system settings including:
  - Keyboard repeat rate
  - Press-and-hold behavior
  - Other system preferences
✓ Tool Installation: ENABLED
✓ Shell Aliases: ENABLED
✓ Vim Configuration: ENABLED
✓ File Associations: ENABLED

Please review the enabled features carefully.
Would you like to proceed with these settings? [y/N]
```

Only after this confirmation would we show the detailed installation summary and final confirmation.

### 3. Documentation Updates

1. Update README.md:
   - Document master switches
   - Explain default settings
   - Provide examples

2. Update installation summary:

    ```sh
    === Installation Summary ===
    Enabled Features:
    ✓ Tool Installation
    ✓ Shell Aliases
    ✓ Vim Configuration
    ✓ File Associations
    ⨯ System Preferences (disabled)
    ```

### 4. Safe Defaults

Default values chosen for safety:

- enable_preferences: false (system changes need opt-in)
- enable_tools: true (core functionality)
- enable_aliases: true (non-destructive)
- enable_vim: true (editor config is safe)
- enable_file_assoc: true (easily reversible)

### 5. Testing Plan

1. Fresh Installation:
   - Test with all features disabled
   - Test with default settings
   - Test with all features enabled

2. Existing Installation:
   - Test upgrading existing config
   - Verify no breaking changes
   - Check backward compatibility

3. Specific Tests:
   - Verify disabled features are truly skipped
   - Check error handling
   - Test config validation

### 6. Migration Guide

For existing users:

1. Add master switches section to config
2. Set according to preferences
3. No changes needed to existing sections
4. Features disabled by default won't run

### 7. Future Considerations

1. Possible Enhancements:
   - CLI flags to override config
   - Interactive setup mode
   - Feature dependencies
   - Granular control if needed

2. Additional Switches:
   - Backup features
   - Network settings
   - Security preferences
   - Development tools

## Benefits

1. User Experience:
   - Clear control over functionality
   - Safe defaults for new users
   - Simple opt-in for features
   - Better understanding of impact

2. Development:
   - Clean separation of concerns
   - Easy to maintain
   - Simple to extend
   - Clear documentation

3. Safety:
   - System changes disabled by default
   - Explicit opt-in required
   - Clear visibility of enabled features
   - Easy to troubleshoot

## Implementation Timeline

1. Phase 1:
   - Add master switches
   - Update core functions
   - Basic documentation

2. Phase 2:
   - Enhance error handling
   - Improve reporting
   - Expand documentation

3. Phase 3:
   - Add CLI overrides
   - Interactive setup
   - Migration tools

## Two-Step Confirmation Process

The implementation uses a two-step confirmation process for safety:

1. Master Switches Confirmation:
   - Shows enabled/disabled status for each major feature
   - Provides details about impact of enabled features
   - Requires explicit confirmation before proceeding
   - Gives users clear opportunity to review their choices
   - Can abort before any changes are made

2. Detailed Installation Confirmation:
   - Only shown after master switches are confirmed
   - Lists specific changes to be made
   - Shows detailed summary of what will be installed/configured
   - Final chance to review before changes begin

This dual confirmation approach ensures users:

- Understand the high-level impact first
- Can abort early if master switches aren't set as desired
- See detailed changes before final commitment
- Have multiple opportunities to review and confirm

## Conclusion

This change makes the cops system more approachable while maintaining all existing functionality. The two-step confirmation process ensures users fully understand and agree to the changes being made, building trust and improving usability.
