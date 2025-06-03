# Testing Guide

This guide outlines testing practices for COPS development.

## Testing Infrastructure

### 1. analyze.sh

Primary testing tool that performs:

```bash
# 1. ShellCheck Analysis
find . -path './.history' -prune -o -name "*.sh" -type f -exec shellcheck -x -a --severity=style {} \;

# 2. Custom Analysis
# - Shell directives
# - Error handling
# - Variable protection
# - Code standards
```

### 2. Built-in Tests

Each module includes:

- Unit tests
- Integration tests
- Safety tests
- Recovery tests

Example from restore.sh:

```bash
test_restore() {
  local test_dir
  test_dir="${BACKUP_DIR}/test"

  # Setup test environment
  mkdir -p "$test_dir"
  echo "test content" >"${test_dir}/test_file"

  # Run tests
  test_backup_verification
  test_dry_run
  test_actual_restore

  # Cleanup
  rm -rf "$test_dir"
}
```

## Testing Requirements

### 1. Code Standards

Every shell script must have:

```bash
#!/bin/bash                 # Proper shebang
# shellcheck shell=bash    # ShellCheck directive
set -e                     # Error handling
set -u                     # Undefined variable protection
```

### 2. Safety Tests

Test all safety mechanisms:

- Backup creation
- File verification
- Rollback functionality
- Error handling

Example:

```bash
test_safety_features() {
  # Test backup
  test_backup_creation
  test_backup_verification

  # Test rollback
  test_rollback_on_error
  test_manual_rollback

  # Test validation
  test_input_validation
  test_state_validation
}
```

### 3. Error Handling

Test error conditions:

- Invalid input
- Missing files
- Permission issues
- System errors

Example:

```bash
test_error_handling() {
  # Test invalid input
  test_invalid_config
  test_missing_required_fields

  # Test file errors
  test_missing_files
  test_permission_denied

  # Test system errors
  test_disk_full
  test_network_failure
}
```

## Testing Workflow

### 1. Before Changes

```bash
# Run full analysis
./analyze.sh

# Note any existing issues
# Plan changes with testing in mind
```

### 2. During Development

```bash
# Test each change
shellcheck -x -a --severity=style path/to/file.sh

# Run module tests
./cops.sh --test

# Check for regressions
./analyze.sh
```

### 3. Before Commit

```bash
# Full analysis
./analyze.sh

# Run all tests
./cops.sh --test

# Fix any issues
# Document test cases
```

## Test Types

### 1. Unit Tests

Test individual functions:

```bash
test_function_name() {
  # Setup
  local input="test value"

  # Test
  local result
  result=$(function_name "$input")

  # Verify
  [[ "$result" == "expected value" ]]
}
```

### 2. Integration Tests

Test module interaction:

```bash
test_module_integration() {
  # Setup multiple modules
  setup_test_environment

  # Test interaction
  test_module_a_with_b
  test_module_b_with_c

  # Verify system state
  verify_system_state
}
```

### 3. Safety Tests

Test protection mechanisms:

```bash
test_safety_features() {
  # Test backups
  test_backup_creation
  test_backup_verification

  # Test validation
  test_input_validation
  test_state_validation

  # Test recovery
  test_error_recovery
  test_manual_recovery
}
```

## Test Organization

### 1. Test Files

Structure:

```tree
lib/
  ├── module.sh           # Implementation
  └── tests/
      ├── unit.sh        # Unit tests
      ├── integration.sh # Integration tests
      └── safety.sh     # Safety tests
```

### 2. Test Functions

Naming convention:

```bash
# Unit tests
test_function_name_success()
test_function_name_failure()

# Integration tests
test_module_a_with_b()
test_full_workflow()

# Safety tests
test_backup_restore()
test_error_recovery()
```

## Best Practices

### 1. Test Coverage

Ensure tests for:

- Normal operation
- Error conditions
- Edge cases
- Recovery scenarios

### 2. Test Independence

Each test should:

- Set up its environment
- Clean up after itself
- Not depend on other tests
- Be repeatable

### 3. Test Documentation

Document:

- Test purpose
- Input conditions
- Expected results
- Error scenarios

Example:

```bash
# Test backup creation with valid input
# Input: Valid file path
# Expected: Backup created with correct timestamp
# Errors: Permission denied, disk full
test_backup_creation() {
  # Test implementation
}
```

### 4. Continuous Testing

- Run tests frequently
- Fix issues immediately
- Add tests for bugs
- Update tests with changes

## Common Test Scenarios

### 1. Configuration Tests

```bash
test_config_validation() {
  # Test required fields
  test_missing_required_field

  # Test invalid values
  test_invalid_value_type
  test_out_of_range_value

  # Test file handling
  test_missing_config_file
  test_invalid_yaml_syntax
}
```

### 2. Safety Tests

```bash
test_safety_mechanisms() {
  # Test backups
  test_backup_before_change
  test_backup_verification

  # Test validation
  test_pre_execution_checks
  test_post_execution_checks

  # Test recovery
  test_automatic_recovery
  test_manual_recovery
}
```

### 3. Error Recovery

```bash
test_error_handling() {
  # Test input errors
  test_invalid_input_recovery
  test_missing_file_recovery

  # Test system errors
  test_disk_full_recovery
  test_permission_error_recovery

  # Test state recovery
  test_partial_failure_recovery
  test_complete_failure_recovery
}
