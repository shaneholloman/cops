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
  *) echo "$tool" ;;
  esac
}

# Check if a feature is enabled in config
is_feature_enabled() {
  local feature="$1"
  get_config ".enable_${feature}" || echo "false"
}
