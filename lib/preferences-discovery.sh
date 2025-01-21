#!/bin/bash
# shellcheck shell=bash
# shellcheck source=lib/output.sh

# Source required files
# shellcheck disable=SC1091
source "${LIB_DIR}/output.sh"

# Exit on error or undefined variable
set -e
set -u

# Constants
readonly BACKUP_DIR="$HOME/.cops/backups"
readonly BACKUP_FORMAT="%Y%m%d_%H%M%S"

# Initialize backup directory
init_backup_dir() {
  if [[ ! -d "$BACKUP_DIR" ]]; then
    mkdir -p "$BACKUP_DIR"
  fi
}

# Generate timestamp for backup files
get_timestamp() {
  date +"$BACKUP_FORMAT"
}

# Create backup of a preference domain
backup_domain() {
  local domain="$1"
  local timestamp
  timestamp=$(get_timestamp)
  local backup_file="$BACKUP_DIR/${domain}_${timestamp}.plist"

  if ! defaults export "$domain" "$backup_file"; then
    print_error "Failed to backup domain: $domain"
    return 1
  fi

  print_success "Created backup: $backup_file"
  echo "$backup_file"
}

# Get latest backup for a domain
get_latest_backup() {
  local domain="$1"
  find "$BACKUP_DIR" -name "${domain}_*.plist" -type f -print0 |
    xargs -0 ls -t 2>/dev/null | head -n1
}

# Restore preferences from backup
restore_domain() {
  local domain="$1"
  local backup_file="$2"

  if [[ ! -f "$backup_file" ]]; then
    print_error "Backup file not found: $backup_file"
    return 1
  fi

  if ! defaults import "$domain" "$backup_file"; then
    print_error "Failed to restore domain: $domain"
    return 1
  fi

  print_success "Restored $domain from: $backup_file"
}

# Capture current state of a preference domain
capture_domain_state() {
  local domain="$1"
  local output_file="$2"

  if ! defaults read "$domain" >"$output_file" 2>/dev/null; then
    print_error "Failed to capture state for domain: $domain"
    return 1
  fi

  print_success "Captured state for: $domain"
}

# Compare current state with backup
diff_domain_state() {
  local domain="$1"
  local backup_file="$2"
  local temp_current
  temp_current=$(mktemp)

  # Capture current state
  if ! defaults read "$domain" >"$temp_current" 2>/dev/null; then
    rm "$temp_current"
    return 1
  fi

  # Compare with backup
  if ! diff -u "$backup_file" "$temp_current"; then
    print_warning "Changes detected in domain: $domain"
  else
    print_success "No changes detected in domain: $domain"
  fi

  rm "$temp_current"
}

# Main discovery function
discover_preferences() {
  local domain="$1"

  # Initialize backup directory
  init_backup_dir

  # Create backup
  local backup_file
  backup_file=$(backup_domain "$domain")

  # Capture current state
  local state_file
  state_file=$(mktemp)
  capture_domain_state "$domain" "$state_file"

  # Show differences if backup exists
  if [[ -f "$backup_file" ]]; then
    diff_domain_state "$domain" "$backup_file"
  fi

  rm "$state_file"
}
