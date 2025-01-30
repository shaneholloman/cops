#!/bin/bash
# shellcheck shell=bash
# shellcheck source=lib/output.sh
# shellcheck source=lib/config.sh

# Source required files
# shellcheck disable=SC1091
source "${LIB_DIR}/output.sh"
# shellcheck disable=SC1091
source "${LIB_DIR}/config.sh"
# shellcheck disable=SC1091
source "${LIB_DIR}/preferences-discovery.sh"

# Exit on error or undefined variable
set -e
set -u

# Test mode flag
TEST_MODE=false

# Constants
BACKUP_TYPES=(
  "preferences"
  "shell"
  "git"
  "vim"
)

# List available backups
list_backups() {
  local type="$1"

  if [[ ! -d "${BACKUP_DIR}" ]]; then
    print_error "No backups found"
    return 1
  fi

  print_header "Available Backups"

  if [[ -n "$type" ]]; then
    if [[ ! " ${BACKUP_TYPES[*]} " =~ ${type} ]]; then
      print_error "Invalid backup type: $type"
      print_info "Valid types: ${BACKUP_TYPES[*]}"
      return 1
    fi
    list_type_backups "$type"
  else
    for backup_type in "${BACKUP_TYPES[@]}"; do
      list_type_backups "$backup_type"
    done
  fi
}

# List backups for a specific type
list_type_backups() {
  local type="$1"
  local type_dir="${BACKUP_DIR}/${type}"

  if [[ ! -d "$type_dir" ]]; then
    return 0
  fi

  print_info "$(tr '[:lower:]' '[:upper:]' <<<"${type:0:1}")${type:1} Backups:"

  # Process backup files
  local -a output_lines
  local found_backups=false

  while IFS= read -r -d '' file; do
    found_backups=true
    local timestamp
    timestamp=$(get_timestamp_from_file "$file")
    local filename
    filename=$(basename "$file")
    output_lines+=("  • $(format_timestamp "$timestamp"): ${filename%_*}")
  done < <(find "$type_dir" -type f -name "*_[0-9]*" -print0)

  if [[ "$found_backups" == "false" ]]; then
    print_info "No backups found"
    return 0
  fi

  # Sort and display output
  if [[ ${#output_lines[@]} -gt 0 ]]; then
    printf '%s\n' "${output_lines[@]}" | sort -u
  fi

  return 0
}

# Get timestamp from filename
get_timestamp_from_file() {
  local file="$1"
  basename "$file" | grep -o '[0-9]\{8\}_[0-9]\{6\}'
}

# Format timestamp for display
format_timestamp() {
  local timestamp="$1"
  date -j -f "%Y%m%d_%H%M%S" "$timestamp" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "$timestamp"
}

# Find backup file by type and name
find_backup_file() {
  local type="$1"
  local file="$2"
  local timestamp="${3:-}"
  local type_dir="${BACKUP_DIR}/${type}"

  local extension=""
  if [[ "$type" == "preferences" ]]; then
    extension=".plist"
  fi

  if [[ -n "$timestamp" ]]; then
    echo "${type_dir}/${file}_${timestamp}${extension}"
  else
    find "$type_dir" -name "${file}_*${extension}" -type f -print0 | xargs -0 ls -t 2>/dev/null | head -n1
  fi
}

# Get current file path based on type
get_current_file_path() {
  local type="$1"
  local file="$2"

  case "$type" in
  preferences)
    echo "/Library/Preferences/${file}"
    ;;
  *)
    echo "${HOME}/.${file}"
    ;;
  esac
}

# Verify backup file integrity
verify_backup() {
  local backup_file="$1"
  local type="$2"

  if [[ ! -f "$backup_file" ]]; then
    return 1
  fi

  case "$type" in
  preferences)
    # Verify plist file is valid
    if ! plutil -lint "$backup_file" >/dev/null 2>&1; then
      return 1
    fi
    ;;
  *)
    # For other files, check if readable and not empty
    if [[ ! -r "$backup_file" ]] || [[ ! -s "$backup_file" ]]; then
      return 1
    fi
    ;;
  esac

  return 0
}

# Restore a specific file
restore_file() {
  local type="$1"
  local file="$2"
  local timestamp="${3:-}" # Optional timestamp
  local dry_run="${4:-false}"

  # Validate backup type
  if [[ ! " ${BACKUP_TYPES[*]} " =~ ${type} ]]; then
    print_error "Invalid backup type: $type"
    print_info "Valid types: ${BACKUP_TYPES[*]}"
    return 1
  fi

  # Check backup directory
  local type_dir="${BACKUP_DIR}/${type}"
  if [[ ! -d "$type_dir" ]]; then
    print_error "No backups found for type: $type"
    return 1
  fi

  # Find backup file
  local backup_file
  backup_file=$(find_backup_file "$type" "$file" "$timestamp")
  if [[ ! -f "$backup_file" ]]; then
    print_error "No backups found for: $file"
    return 1
  fi

  # Verify backup integrity
  if ! verify_backup "$backup_file" "$type"; then
    print_error "Backup file verification failed: $backup_file"
    return 1
  fi

  # Get current file path
  local current_file
  current_file=$(get_current_file_path "$type" "$file")

  # Show what will be done
  print_info "Restore operation:"
  print_info "  From: $backup_file"
  print_info "  To: $current_file"

  if [[ "$dry_run" == "true" ]]; then
    print_info "Dry run - no changes made"
    return 0
  fi

  # Ask for confirmation unless auto-agree is set
  if [[ "${AUTO_AGREE:-false}" != "true" ]]; then
    read -r -p "Proceed with restore? [y/N] " -n 1
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      print_info "Restore cancelled"
      return 0
    fi
  fi

  # Create backup before restore if file exists
  if [[ -f "$current_file" ]]; then
    if ! backup_file_before_restore "$type" "$file" "$current_file"; then
      print_error "Failed to create safety backup"
      return 1
    fi
  fi

  # Perform restore
  local restore_success=true
  case "$type" in
  preferences)
    if ! defaults import "$file" "$backup_file" 2>/dev/null; then
      restore_success=false
    fi
    ;;
  *)
    if ! cp "$backup_file" "$current_file" 2>/dev/null; then
      restore_success=false
    fi
    ;;
  esac

  if [[ "$restore_success" != "true" ]]; then
    print_error "Failed to restore $file"
    return 1
  fi

  print_success "Restored $file from backup"
  return 0
}

# Backup file before restore
backup_file_before_restore() {
  local type="$1"
  local file="$2"
  local current_file="$3"
  local timestamp
  timestamp=$(date +"${BACKUP_FORMAT}")
  local backup_path="${BACKUP_DIR}/${type}/${file}_${timestamp}"

  case "$type" in
  preferences)
    defaults export "$file" "$backup_path"
    ;;
  *)
    cp "$current_file" "$backup_path"
    ;;
  esac

  print_success "Created safety backup: $backup_path"
}

# Restore all files from a timestamp
restore_all() {
  local timestamp="$1"
  local dry_run="${2:-false}"
  local return_code=0

  print_header "Restoring all files from $timestamp"

  # Find all backup files for this timestamp
  local -a backup_files
  for type in "${BACKUP_TYPES[@]}"; do
    local type_dir="${BACKUP_DIR}/${type}"
    if [[ ! -d "$type_dir" ]]; then
      continue
    fi

    # Store backup files in array
    while IFS= read -r -d '' backup_file; do
      if verify_backup "$backup_file" "$type"; then
        backup_files+=("$type:$backup_file")
      else
        print_warning "Skipping invalid backup: $backup_file"
      fi
    done < <(find "$type_dir" -name "*_${timestamp}.*" -type f -print0)
  done

  # Check if any backups were found
  if [[ ${#backup_files[@]} -eq 0 ]]; then
    print_error "No valid backups found for timestamp: $timestamp"
    return 1
  fi

  # Show what will be restored
  print_info "Files to restore:"
  for backup_entry in "${backup_files[@]}"; do
    local type file
    type=${backup_entry%%:*}
    file=$(basename "${backup_entry#*:}" | sed "s/_${timestamp}\.plist$//")
    print_info "  • $type: $file"
  done

  if [[ "$dry_run" == "true" ]]; then
    print_info "Dry run - no changes made"
    return 0
  fi

  # Ask for confirmation unless auto-agree is set
  if [[ "${AUTO_AGREE:-false}" != "true" ]]; then
    read -r -p "Proceed with restore? [y/N] " -n 1
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      print_info "Restore cancelled"
      return 0
    fi
  fi

  # Process each backup file
  for backup_entry in "${backup_files[@]}"; do
    local type file
    type=${backup_entry%%:*}
    file=$(basename "${backup_entry#*:}" | sed "s/_${timestamp}\.plist$//")

    if ! restore_file "$type" "$file" "$timestamp" "false"; then
      return_code=1
      if [[ "${AUTO_AGREE:-false}" != "true" ]]; then
        read -r -p "Continue with remaining files? [y/N] " -n 1
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
          print_info "Restore operation cancelled"
          return 1
        fi
      fi
    fi
  done

  if [[ $return_code -eq 0 ]]; then
    print_success "All files restored successfully"
  else
    print_error "Some files failed to restore"
  fi

  return "$return_code"
}

# Test functions
test_restore() {
  local test_dir
  test_dir="${BACKUP_DIR}/test"
  mkdir -p "$test_dir"

  # Setup test files
  echo "test content" >"${test_dir}/test_file"
  local timestamp
  timestamp=$(date +"${BACKUP_FORMAT}")
  cp "${test_dir}/test_file" "${test_dir}/test_file_${timestamp}"

  # Test backup verification
  print_header "Testing backup verification"
  if verify_backup "${test_dir}/test_file_${timestamp}" "shell"; then
    print_success "Backup verification passed"
  else
    print_error "Backup verification failed"
    return 1
  fi

  # Test dry run
  print_header "Testing dry run"
  TEST_MODE=true
  if restore_file "shell" "test_file" "$timestamp" "true"; then
    print_success "Dry run test passed"
  else
    print_error "Dry run test failed"
    return 1
  fi

  # Test actual restore
  print_header "Testing actual restore"
  if restore_file "shell" "test_file" "$timestamp" "false"; then
    print_success "Restore test passed"
  else
    print_error "Restore test failed"
    return 1
  fi

  # Cleanup
  rm -rf "$test_dir"
  return 0
}

# Run tests if in test mode
if [[ "${TEST_MODE:-false}" == "true" ]]; then
  test_restore
fi
