# System Preferences Module Redesign

January 21, 2024

## Development Status

Current Phase: Design and Planning

- Completed initial design phase
- Established implementation patterns
- Identified critical first steps
- Documented safety requirements

## Overview

Redesign of the system preferences module to align with COPS' philosophy of configuration as code, while providing safe and systematic management of macOS system preferences.

## Reference Implementation

The aliases module serves as a conceptual template for this redesign:

1. **Configuration Pattern**
   - Uses config.yaml as single source of truth
   - Structured organization (categories/groups)
   - Clear separation between configuration and implementation
   - Validation before application

2. **Implementation Pattern**
   - Dedicated module (lib/aliases.sh)
   - Master switch control
   - Backup functionality
   - Clear validation steps

3. **Key Differences**
   - Preferences require state capture before changes
   - More complex domain mapping (defaults commands)
   - Higher risk of system impact
   - Need for more granular control

## Core Principles

1. **Safety First**
   - All preference groups disabled by default
   - Master switch off by default
   - Capture current state before changes
   - Support for preference verification

2. **Configuration as Code**
   - Move all preferences to config.yaml
   - Structured, hierarchical organization
   - Clear grouping of related preferences
   - Version-controlled preference management

3. **Granular Control**
   - Master switch for all preferences
   - Individual group switches
   - Fine-grained preference settings
   - Selective application of changes

## Configuration Structure

```yaml
# Master switch (default: false)
enable_preferences: false

preferences:
  # Group switches (all default: false)
  enable_groups:
    terminal: false
    security: false
    input: false
    finder: false
    dock: false
    safari: false
    global: false
    activity: false

  # Preference Groups
  terminal:
    font: "Hack Nerd Font Mono 12"
    key_repeat: 2
    # ... more terminal preferences

  security:
    screensaver:
      ask_for_password: true
    # ... more security preferences

  # ... other preference groups
```

## Implementation Plan

### Phase 1: Preference Capture

1. Create preference capture tool
   - Capture current system state
   - Output in YAML format
   - Support selective group capture
   - Enable diff against config.yaml

2. Implement capture commands:

   ```bash
   cops-prefs-capture              # Full capture
   cops-prefs-capture --group xyz  # Group capture
   cops-prefs-capture --diff      # Compare with config
   ```

### Phase 2: Preference Management

1. Update lib/preferences.sh
   - Implement group-based structure
   - Add validation and safety checks
   - Support selective application
   - Include proper error handling

2. Create preference domains mapping
   - Map YAML config to defaults commands
   - Support different value types
   - Include domain documentation
   - Handle complex preferences

## Safety Features

1. **State Capture**
   - Record initial state
   - Support for rollback
   - Diff-based verification
   - Change logging

2. **Validation**
   - Type checking
   - Value range validation
   - Domain existence verification
   - Permission checking

3. **Application Control**
   - Master switch protection
   - Group-level control
   - Selective application
   - Dry-run support

## Reference Documents

1. Primary Documentation:
   - Aliases Implementation is here `lib/aliases.sh` (reference pattern)
   - Current Preferences is here `lib/preferences.sh` (to be updated)

2. Related Files:
   - `.ideas/macos.sh` (preference examples)
   - `config.yaml` (configuration structure)

## Next Development Session

1. Start with Capture Tool:
   - Implement preference state capture
   - Support YAML output format
   - Enable selective group capture
   - Add diff capabilities

2. Implementation Steps:
   - Create capture command structure
   - Add domain mapping logic
   - Implement YAML formatting
   - Add validation and safety checks

3. Testing Requirements:
   - Verify accurate state capture
   - Test group selection
   - Validate YAML output
   - Check diff functionality

## Notes

- All preference groups off by default for safety
- Capture tool is critical first step
- Follow aliases module patterns where applicable
- Focus on safety and verification
