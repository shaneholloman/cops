#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

# Core validation function used by both checks and installation
validate_tool() {
  local tool="$1"
  if needs_file_validation "$tool"; then
    local file
    file=$(get_validation_file "$tool")
    [[ -f "$file" ]]
    return
  else
    local cmd
    cmd=$(get_command_name "$tool")
    command -v "$cmd" >/dev/null 2>&1
    return
  fi
}

# Format validation result for display
print_validation_result() {
  local tool="$1"
  local success="$2"
  local is_check="${3:-false}" # true for check phase, false for install phase

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
