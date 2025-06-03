#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

# Global configuration
# Export backup configuration for use by other scripts
export BACKUP_FORMAT="%Y%m%d_%H%M%S"
export BACKUP_DIR="${COPS_ROOT}/backups"

# CONFIG_FILE is set by the main script and exported
# This declaration helps shellcheck understand the variable is global
: "${CONFIG_FILE:?CONFIG_FILE must be set}"

# Validate YAML configuration file
validate_config_file() {
  local config_file="$1"
  
  # Check if file exists and is readable
  if [[ ! -f "$config_file" ]]; then
    print_error "Configuration file not found: $config_file"
    return 1
  fi
  
  if [[ ! -r "$config_file" ]]; then
    print_error "Configuration file not readable: $config_file"
    return 1
  fi
  
  # Check if yq can parse the YAML file
  if ! yq eval '.' "$config_file" >/dev/null 2>&1; then
    print_error "Invalid YAML syntax in configuration file: $config_file"
    print_error "Please check your YAML formatting and try again"
    return 1
  fi
  
  # Check for required top-level sections
  local required_sections=("user" "preferences" "tools")
  for section in "${required_sections[@]}"; do
    if ! yq eval "has(\"$section\")" "$config_file" | grep -q "true"; then
      print_error "Missing required section '$section' in configuration file"
      return 1
    fi
  done
  
  print_success "Configuration file validation passed: $config_file"
  return 0
}

# Check if required dependencies are available
check_dependencies() {
  local missing_deps=()
  local required_tools=("yq" "envsubst" "brew" "defaults" "tmutil" "git")
  
  print_header "Checking required dependencies"
  
  for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      missing_deps+=("$tool")
      print_error "Missing required tool: $tool"
    else
      print_success "Found required tool: $tool"
    fi
  done
  
  # Check for yq version compatibility (needs v4+)
  if command -v yq >/dev/null 2>&1; then
    local yq_version
    yq_version=$(yq --version 2>/dev/null | grep -o 'v[0-9]*' | sed 's/v//' || echo "0")
    if [[ "$yq_version" -lt 4 ]]; then
      missing_deps+=("yq (version 4+ required)")
      print_error "yq version $yq_version found, but version 4+ is required"
    fi
  fi
  
  if [[ ${#missing_deps[@]} -gt 0 ]]; then
    print_error "Missing dependencies: ${missing_deps[*]}"
    
    # Check if this looks like a bootstrap situation
    if [[ " ${missing_deps[*]} " =~ " yq " ]] || [[ " ${missing_deps[*]} " =~ " envsubst " ]]; then
      print_warning "TIP: For new machines, run ./bootstrap.sh first to install core dependencies"
    fi
    
    print_error "Please install missing tools and try again"
    return 1
  fi
  
  print_success "All required dependencies are available"
  return 0
}

get_config() {
  local path="$1"
  yq eval "$path" "${CONFIG_FILE}" | envsubst
}

get_config_array() {
  local path="$1"
  yq eval "$path" "${CONFIG_FILE}" | while read -r line; do
    echo "${line#- }"
  done
}

# Get the actual command name for a tool
get_command_name() {
  local tool="$1"
  case "$tool" in
  "awscli") echo "aws" ;;
  "kubernetes-cli") echo "kubectl" ;;
  "rust") echo "rustc" ;;
  "gnu-sed") echo "gsed" ;;
  "findutils") echo "gfind" ;;
  "imagemagick") echo "convert" ;;
  "gnupg") echo "gpg" ;;
  "p7zip") echo "7z" ;;
  "moreutils") echo "parallel" ;;
  "openssh") echo "ssh" ;;
  *) echo "$tool" ;;
  esac
}

# Check if a tool requires file-based validation
needs_file_validation() {
  local tool="$1"
  case "$tool" in
  "bash-completion2" | "gmp") return 0 ;;
  *) return 1 ;;
  esac
}

# Get the validation file path for a tool
get_validation_file() {
  local tool="$1"
  case "$tool" in
  "bash-completion2") echo "/opt/homebrew/etc/profile.d/bash_completion.sh" ;;
  "gmp") echo "/opt/homebrew/opt/gmp/lib/libgmp.dylib" ;;
  *) echo "" ;;
  esac
}

# Check if a feature is enabled in config
is_feature_enabled() {
  local feature="$1"
  get_config ".enable_${feature}" || echo "false"
}
