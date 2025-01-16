#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

# Source our configuration functions
# shellcheck source=lib/config.sh
source "lib/config.sh"

# Path variables with environment overrides
MOUNT_POINT=${COPS_MOUNT_POINT:-$(get_config ".restore.paths.mount_point")}
DISK_DEVICE=${COPS_DISK_DEVICE:-$(get_config ".restore.paths.disk_device")}
USER_HOME=${COPS_USER_HOME:-$(get_config ".restore.paths.user_home" | envsubst)}
ROOT_PATH=${COPS_ROOT_PATH:-$(get_config ".restore.paths.root")}
BACKUP_PREFIX=${COPS_BACKUP_PREFIX:-$(get_config ".restore.paths.backup_dir_prefix")}

# Get config files and directories from config
readarray -t COPS < <(get_config_array ".restore.files.cops[]")
readarray -t CONFIG_DIRS < <(get_config_array ".restore.files.config_dirs[]")

# Find sudo path
SUDO=$(command -v sudo)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log functions
log_info() { printf "${GREEN}INFO: %s${NC}\n" "$1"; }
log_warn() { printf "${YELLOW}WARN: %s${NC}\n" "$1"; }
log_error() { printf "${RED}ERROR: %s${NC}\n" "$1"; }

# Usage information
usage() {
  cat <<EOF
Usage: $(basename "$0") <snapshot_date>

Restore cops configuration from a Time Machine local snapshot.
The snapshot date should be in format: YYYY-MM-DD-HHMMSS

Example: $(basename "$0") 2025-01-15-021331

Options:
    -h, --help      Show this help message
    -l, --list      List available snapshots
EOF
}

# List available snapshots
list_snapshots() {
  log_info "Available snapshots:"
  tmutil listlocalsnapshots "$ROOT_PATH" | sed 's/com.apple.TimeMachine.\(.*\).local/\1/'
}

# Check if snapshot exists
check_snapshot() {
  local snapshot_date=$1
  if ! tmutil listlocalsnapshots "$ROOT_PATH" | grep -q "$snapshot_date"; then
    log_error "Snapshot $snapshot_date not found"
    list_snapshots
    exit 1
  fi
}

# Mount snapshot
mount_snapshot() {
  local snapshot_date=$1

  log_info "Creating mount point..."
  "$SUDO" mkdir -p "$MOUNT_POINT"

  log_info "Mounting snapshot..."
  "$SUDO" mount_apfs -s "com.apple.TimeMachine.${snapshot_date}.local" "$DISK_DEVICE" "$MOUNT_POINT"
}

# Restore files
restore_files() {
  local backup_dir
  backup_dir="${USER_HOME}/${BACKUP_PREFIX}$(date +%Y%m%d_%H%M%S)"

  log_info "Creating backup directory for current files..."
  mkdir -p "$backup_dir"

  # Backup current files
  log_info "Backing up current cops..."
  for file in "${COPS[@]}"; do
    [[ -f "${USER_HOME}/${file}" ]] && cp "${USER_HOME}/${file}" "$backup_dir/"
  done

  for dir in "${CONFIG_DIRS[@]}"; do
    [[ -d "${USER_HOME}/${dir}" ]] && cp -R "${USER_HOME}/${dir}" "$backup_dir/"
  done

  # Restore from snapshot
  log_info "Restoring files from snapshot..."

  # Core config files
  for file in "${COPS[@]}"; do
    "$SUDO" cp "${MOUNT_POINT}${USER_HOME}/${file}" "${USER_HOME}/" 2>/dev/null || log_warn "No ${file} found in snapshot"
  done

  # Config directories
  for dir in "${CONFIG_DIRS[@]}"; do
    if [[ -d "${MOUNT_POINT}${USER_HOME}/${dir}" ]]; then
      "$SUDO" cp -R "${MOUNT_POINT}${USER_HOME}/${dir}" "${USER_HOME}/"
    fi
  done

  # Fix permissions
  log_info "Fixing permissions..."
  for dir in "${CONFIG_DIRS[@]}"; do
    "$SUDO" chown -R "$(whoami)" "${USER_HOME}/${dir}" 2>/dev/null || true
  done

  for file in "${COPS[@]}"; do
    "$SUDO" chown "$(whoami)" "${USER_HOME}/${file}" 2>/dev/null || true
  done

  log_info "Backup of current files saved to: $backup_dir"
}

# Cleanup
cleanup() {
  log_info "Cleaning up..."
  "$SUDO" umount "$MOUNT_POINT" 2>/dev/null || true
  "$SUDO" rmdir "$MOUNT_POINT" 2>/dev/null || true
}

# Main script
main() {
  # Parse arguments
  case "${1:-}" in
  -h | --help)
    usage
    exit 0
    ;;
  -l | --list)
    list_snapshots
    exit 0
    ;;
  *)
    if [[ -z "${1:-}" ]]; then
      log_error "Snapshot date required"
      usage
      exit 1
    fi
    ;;
  esac

  local snapshot_date=$1

  # Validate snapshot exists
  check_snapshot "$snapshot_date"

  # Ensure cleanup on script exit
  trap cleanup EXIT

  # Mount and restore
  mount_snapshot "$snapshot_date"
  restore_files

  log_info "Restoration complete!"
}

main "$@"
