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
  local phase="${3:-install}" # "check", "install", or "validate"

  if [[ "$success" == "true" ]]; then
    case "$phase" in
      "check")
        print_success "$tool already installed"
        ;;
      "install")
        print_success "$tool installed successfully"
        ;;
      "validate")
        print_success "$tool installed successfully"
        ;;
    esac
  else
    case "$phase" in
      "check")
        print_warning "$tool will be installed"
        ;;
      "install")
        print_error "$tool installation failed"
        ;;
      "validate")
        print_error "$tool installation failed"
        ;;
    esac
  fi
}
