# Safety Features

COPS implements multiple layers of safety mechanisms to protect against configuration errors and system issues.

## Core Safety Mechanisms

### 1. APFS Snapshots

```yaml
enable_snapshots: true  # Master switch in config.yaml
```

Implementation:

- Creates system snapshot before changes
- Uses macOS Time Machine API
- Allows full system rollback
- Zero performance impact

Location: `lib/main.sh`

```bash
if [[ "$(is_feature_enabled "snapshots")" = "true" ]]; then
  if tmutil localsnapshot / >/dev/null 2>&1; then
    snapshot_name=$(tmutil listlocalsnapshots / | tail -n 1)
    print_success "Created APFS snapshot: $snapshot_name"
  fi
fi
```

### 2. Configuration Validation

Location: `lib/validate.sh`

Validates:

- YAML syntax
- Required fields
- Value types
- Path existence
- Permissions

Example validation:

```bash
validate_config() {
  # Check required fields
  if ! yq eval '.user.name' "$CONFIG_FILE" >/dev/null 2>&1; then
    return 1
  fi

  # Validate paths
  if ! validate_paths; then
    return 1
  fi
}
```

### 3. Backup System

Location: `lib/restore.sh`

Features:

- Timestamped backups
- File integrity verification
- Atomic operations
- Rollback capability

Implementation:

```bash
verify_backup() {
  local backup_file="$1"
  local type="$2"

  case "$type" in
  preferences)
    # Verify plist file
    plutil -lint "$backup_file" >/dev/null 2>&1
    ;;
  *)
    # Check file integrity
    [[ -r "$backup_file" ]] && [[ -s "$backup_file" ]]
    ;;
  esac
}
```

### 4. Master Switches

Purpose:

- Granular feature control
- Safe defaults (all disabled)
- Clear impact visibility
- Independent toggles

Configuration:

```yaml
# Master Switches
enable_preferences: false
enable_tools: false
enable_aliases: false
enable_vim: false
enable_file_assoc: false
enable_snapshots: true
enable_brewbundle: false
```

## Safety Workflow

### 1. Pre-execution Checks

Location: `lib/checks.sh`

Sequence:

1. Validate configuration
2. Check system requirements
3. Verify permissions
4. Test critical commands
5. Validate paths

Example:

```bash
check_system() {
  check_os
  check_homebrew
  check_permissions
  check_disk_space
}
```

### 2. Execution Safety

Location: `lib/main.sh`

Features:

- Step-by-step execution
- Error handling
- Progress tracking
- Rollback points

Implementation:

```bash
main() {
  # Show and confirm changes
  show_master_switches
  show_summary

  # Create snapshot if enabled
  if [[ "$(is_feature_enabled "snapshots")" = "true" ]]; then
    create_snapshot
  fi

  # Execute with safety checks
  setup_with_safety
}
```

### 3. Post-execution Validation

Location: `lib/validate.sh`

Checks:

- Configuration applied correctly
- Services running
- Permissions correct
- No system issues

Example:

```bash
validate_installation() {
  validate_paths
  validate_permissions
  validate_services
  validate_configurations
}
```

## Development Guidelines

### 1. Adding Safety Features

When adding new features:

1. Add master switch
2. Implement validation
3. Add backup support
4. Include rollback
5. Document safety measures

Example:

```bash
# 1. Master switch
enable_new_feature: false

# 2. Validation
validate_new_feature() {
  # Validation logic
}

# 3. Backup
backup_new_feature() {
  # Backup logic
}

# 4. Rollback
rollback_new_feature() {
  # Rollback logic
}
```

### 2. Error Handling

Requirements:

- Clear error messages
- Specific error codes
- Recovery instructions
- Logging support

Example:

```bash
if ! apply_changes; then
  print_error "Failed to apply changes"
  print_info "Recovery steps:"
  print_info "1. Check logs"
  print_info "2. Run with --dry-run"
  print_info "3. Verify permissions"
  return 1
fi
```

### 3. Testing Safety Features

Test requirements:

- Verify all safety mechanisms
- Test failure scenarios
- Check rollback functionality
- Validate error handling

Example test:

```bash
test_safety_features() {
  # Test snapshot creation
  test_snapshots

  # Test backup system
  test_backups

  # Test rollback
  test_rollback

  # Test validation
  test_validation
}
```

## Best Practices

1. **Default to Safe**
   - Features disabled by default
   - Explicit enabling required
   - Clear documentation
   - Safety first approach

2. **Validate Everything**
   - Input validation
   - State validation
   - Permission checks
   - System checks

3. **Provide Recovery**
   - Backup before changes
   - Rollback capability
   - Clear error messages
   - Recovery instructions

4. **Document Safety**
   - Document all safety features
   - Explain failure modes
   - Provide recovery steps
   - Keep documentation current
