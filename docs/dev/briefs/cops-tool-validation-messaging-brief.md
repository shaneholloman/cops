# Tool Validation Messaging Improvements

## Context

Date: January 30, 2025
Issue: Incorrect messaging when tools installation is disabled

### Current Behavior

The COPS setup script currently shows misleading messages in two scenarios when tool installation is disabled via the master switch (`enable_tools: false`):

1. During the Installation Summary, it shows:

    ```sh
    3. Tool Installation:
      - Install CLI tools: ack
      - Install CLI tools: awscli
      ...
    ```

    Even though tools won't actually be installed due to the master switch.

2. During validation, it shows:

    ```sh
    === Validating installation ===
    ✗ ack installation failed
    ✗ awscli installation failed
    ...
    ```

When in fact these tools were intentionally skipped, not failed.

### Root Cause

1. The `show_summary()` function in `lib/main.sh` doesn't check the tools master switch before listing tools to be installed.

2. The validation logic in `lib/install.sh` and `lib/validate.sh` treats all missing tools as failures, without considering whether tool installation was intentionally disabled.

## Proposed Solution

### 1. Installation Summary Fix

Modify `show_summary()` in `lib/main.sh` to check the tools master switch:

```bash
# Only show tool installation section if tools feature is enabled AND there are tools to install
if [[ "$(is_feature_enabled "tools")" = "true" ]] && { ((${#CLI_TOOLS_TO_INSTALL[@]} > 0)) || ((${#CASK_APPS_TO_INSTALL[@]} > 0)); }; then
  printf "3. Tool Installation:\n"
  if ((${#CLI_TOOLS_TO_INSTALL[@]} > 0)); then
    printf "   - Install CLI tools: %s\n" "${CLI_TOOLS_TO_INSTALL[@]}"
  fi
  if ((${#CASK_APPS_TO_INSTALL[@]} > 0)); then
    printf "   - Install applications: %s\n" "${CASK_APPS_TO_INSTALL[@]}"
  fi
  printf "\n"
fi
```

### 2. Validation Messaging Fix

1. Modify `print_validation_result()` in `lib/validate.sh`:

    ```bash
    print_validation_result() {
      local tool="$1"
      local success="$2"
      local is_check="${3:-false}"

      # First check if tools are enabled
      if [[ "$(is_feature_enabled "tools")" != "true" ]]; then
        print_info "$tool skipped (tools disabled)"
        return
      fi

      if [[ "$success" == "true" ]]; then
        if [[ "$is_check" == "true" ]]; then
          print_success "$tool already installed"
        else
          print_success "$tool installed successfully"
        fi
      else
        if [[ "$is_check" == "true" ]]; then
          print_warning "$tool will be installed"
        else
          print_error "$tool installation failed"
        fi
      fi
    }
    ```

2. Modify `validate_installation()` in `lib/install.sh`:

    ```bash
    validate_installation() {
      print_header "Validating installation"

      # Early return with message if tools are disabled
      if [[ "$(is_feature_enabled "tools")" != "true" ]]; then
        print_info "Tool installation is disabled - skipping validation"
        return
      fi

      # Rest of the existing validation logic...
    }
    ```

### Expected Behavior After Fix

1. When tools are disabled (`enable_tools: false`):
   - Installation Summary won't show tool installation section
   - Validation will show "Tool installation is disabled - skipping validation"

2. When tools are enabled (`enable_tools: true`):
   - Current behavior remains unchanged
   - Failed installations will still show as failures
   - Successful installations will still show as successes

## Testing Plan

1. Test with tools disabled:

    ```bash
    # Edit config.yaml to set
    enable_tools: false

    # Run setup
    ./cops.sh

    # Verify:
    - No tool installation section in summary
    - Validation shows "disabled" message
    ```

2. Test with tools enabled:

    ```bash
    # Edit config.yaml to set
    enable_tools: true

    # Run setup
    ./cops.sh

    # Verify:
    - Tool installation section appears in summary
    - Validation shows proper success/failure messages
    ```

## Related Files

- `lib/main.sh` - Contains `show_summary()` function
- `lib/install.sh` - Contains `validate_installation()` function
- `lib/validate.sh` - Contains `print_validation_result()` function
- `config.yaml` - Contains master switches including `enable_tools`

## Implementation Notes

- Changes are purely cosmetic - no functional changes to the actual installation process
- All changes respect the existing error handling and output styling
- Maintains backward compatibility with existing configuration files
- Follows project's shell scripting standards

## Future Considerations

1. Consider adding a "dry run" mode that shows what would be installed/changed
2. Consider adding more granular control over tool installation (e.g., by category)
3. Consider adding a "verbose" mode that shows skipped items even when disabled

## References

- [Shell Standards](../../reference/shell-standards.md)
- [Master Switches Documentation](../master-switches.md)
