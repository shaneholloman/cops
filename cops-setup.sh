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

# Parse command line arguments
AUTO_AGREE=false
while [[ $# -gt 0 ]]; do
  case $1 in
  --auto-agree)
    AUTO_AGREE=true
    shift
    ;;
  *)
    echo "Unknown option: $1"
    exit 1
    ;;
  esac
done

# Global configuration
CONFIG_FILE="config.yaml"
readonly CONFIG_FILE
export AUTO_AGREE

COPS_ROOT=$(yq eval '.paths.cops' "$CONFIG_FILE" | envsubst)
export COPS_ROOT
readonly COPS_ROOT

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
# shellcheck source=lib/brewbundle.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/brewbundle.sh"
# shellcheck source=lib/main.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/main.sh"

# Run the script
main
