#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

get_config() {
  local path="$1"
  yq eval "$path" "$CONFIG_FILE" | envsubst
}

get_config_array() {
  local path="$1"
  yq eval "$path" "$CONFIG_FILE" | while read -r line; do
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
