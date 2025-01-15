#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

# Check for yq installation (needed for YAML parsing)
if ! command -v yq &>/dev/null; then
  echo "yq is required but not installed. Installing..."
  if command -v brew &>/dev/null; then
    brew install yq
  else
    echo "Error: brew not found. Please install Homebrew first."
    exit 1
  fi
fi

# Global configuration
CONFIG_FILE="config.yaml"
readonly CONFIG_FILE

DOTFILES_ROOT=$(yq eval '.paths.dotfiles' "$CONFIG_FILE" | envsubst)
export DOTFILES_ROOT
readonly DOTFILES_ROOT

# Source all library files from lib directory
LIB_DIR="lib"
readonly LIB_DIR
# shellcheck source=lib/output.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/output.sh"
# shellcheck source=lib/config.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/config.sh"
# shellcheck source=lib/checks.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/checks.sh"
# shellcheck source=lib/setup.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/setup.sh"
# shellcheck source=lib/install.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/install.sh"
# shellcheck source=lib/preferences.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/preferences.sh"
# shellcheck source=lib/main.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/main.sh"

# Run the script
main
