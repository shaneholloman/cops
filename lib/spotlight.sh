#!/bin/bash
# shellcheck shell=bash
# shellcheck source=lib/output.sh
# shellcheck source=lib/config.sh

# IMPORTANT: This module requires human interaction to enter sudo password!
# The mdutil commands require sudo access and cannot be automated without
# compromising security. A human must be present to type the password when
# this module runs.

# Source required files
# shellcheck disable=SC1091
source "${LIB_DIR}/output.sh"
# shellcheck disable=SC1091
source "${LIB_DIR}/config.sh"

# Exit on error or undefined variable
set -e
set -u

# Check if spotlight module is enabled
is_spotlight_enabled() {
  local enabled
  enabled=$(is_feature_enabled "spotlight")
  print_info "Spotlight module enabled status: ${enabled}"
  [[ "$enabled" == "true" ]]
}

# Apply spotlight indexing settings
apply_spotlight_indexing() {
  local external_volumes_enabled
  local external_volumes_path

  external_volumes_enabled=$(get_config ".spotlight.indexing.external_volumes")
  external_volumes_path="/System/Volumes/Data/Volumes" # Use real system path

  if [[ "$external_volumes_enabled" == "false" ]]; then
    print_info "Disabling Spotlight indexing for external volumes..."
    if ! sudo mdutil -i off "${external_volumes_path}"; then
      print_error "Failed to disable Spotlight indexing for external volumes"
      return 1
    fi
  else
    print_info "Enabling Spotlight indexing for external volumes..."
    if ! sudo mdutil -i on "${external_volumes_path}"; then
      print_error "Failed to enable Spotlight indexing for external volumes"
      return 1
    fi
  fi

  return 0
}

# Main spotlight setup function
setup_spotlight() {
  print_info "Starting Spotlight setup..."
  if ! is_spotlight_enabled; then
    print_info "Spotlight module disabled, skipping..."
    return 0
  fi

  print_header "Setting up Spotlight configuration"

  if ! apply_spotlight_indexing; then
    print_error "Failed to configure Spotlight"
    return 1
  fi

  print_success "Spotlight configuration complete"
  return 0
}
