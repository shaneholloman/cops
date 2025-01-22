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
COMMAND=""
TYPE=""
FILE=""
TIMESTAMP=""
DRY_RUN=false
TEST_MODE=false

print_usage() {
  printf "Usage: %s [OPTIONS]\n" "$0"
  printf "\nOptions:\n"
  printf "  --auto-agree            Skip confirmation prompts\n"
  printf "  --dry-run              Show what would be done without making changes\n"
  printf "  --test                 Run tests for restore functionality\n"
  printf "  --list-backups [type]   List available backups (optional: specify type)\n"
  printf "  --restore type file     Restore a specific file\n"
  printf "  --restore-all timestamp Restore all files from a timestamp\n"
  printf "\nBackup types: preferences, shell, git, vim\n"
}

while [[ $# -gt 0 ]]; do
  case $1 in
  --auto-agree)
    AUTO_AGREE=true
    shift
    ;;
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  --test)
    COMMAND="test"
    TEST_MODE=true
    shift
    ;;
  --list-backups)
    COMMAND="list"
    if [[ $# -gt 1 && ! $2 =~ ^-- ]]; then
      TYPE="$2"
      shift
    fi
    shift
    ;;
  --restore)
    if [[ $# -lt 3 ]]; then
      print_error "Missing arguments for --restore"
      print_usage
      exit 1
    fi
    COMMAND="restore"
    TYPE="$2"
    FILE="$3"
    shift 3
    ;;
  --restore-all)
    if [[ $# -lt 2 ]]; then
      print_error "Missing timestamp for --restore-all"
      print_usage
      exit 1
    fi
    COMMAND="restore-all"
    TIMESTAMP="$2"
    shift 2
    ;;
  -h | --help)
    print_usage
    exit 0
    ;;
  *)
    print_error "Unknown option: $1"
    print_usage
    exit 1
    ;;
  esac
done

# Global configuration
CONFIG_FILE="config.yaml"
export AUTO_AGREE

COPS_ROOT=$(yq eval '.paths.cops' "$CONFIG_FILE" | envsubst)
export COPS_ROOT

# Source all library files from lib directory
LIB_DIR="lib"
# shellcheck source=lib/output.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/output.sh"
# shellcheck source=lib/validate.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/validate.sh"
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
# shellcheck source=lib/preferences-discovery.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/preferences-discovery.sh"
# shellcheck source=lib/preferences.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/preferences.sh"
# shellcheck source=lib/restore.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/restore.sh"
# shellcheck source=lib/brewbundle.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/brewbundle.sh"
# shellcheck source=lib/aliases.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/aliases.sh"
# shellcheck source=lib/main.sh
# shellcheck disable=SC1091
source "${LIB_DIR}/main.sh"

# Export test mode for library files
export TEST_MODE

# Handle restore commands if present
if [[ -n "$COMMAND" ]]; then
  case "$COMMAND" in
  list)
    list_backups "$TYPE"
    ;;
  restore)
    restore_file "$TYPE" "$FILE" "" "$DRY_RUN"
    ;;
  restore-all)
    restore_all "$TIMESTAMP" "$DRY_RUN"
    ;;
  test)
    print_header "Running restore tests"
    test_restore
    ;;
  esac
  exit 0
fi

# Run the main installation if no restore command
main
