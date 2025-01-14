#!/bin/bash
# shellcheck shell=bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Log functions
log_info() {
  printf "${GREEN}INFO: %s${NC}\n" "$1"
}

log_warn() {
  printf "${YELLOW}WARN: %s${NC}\n" "$1"
}

log_error() {
  printf "${RED}ERROR: %s${NC}\n" "$1"
}

# Default paths to exclude during restore
DEFAULT_EXCLUDES=(
  "Applications"
  "Library"
  "Movies"
  "Music"
  "Pictures"
  "Downloads"
  "Public"
  "Desktop"
)

# Usage information
usage() {
  cat <<EOF
Usage: $(basename "$0") <snapshot_date> [options]

Restore home directory from a Time Machine local snapshot.
The snapshot date should be in format: YYYY-MM-DD-HHMMSS

Example: $(basename "$0") 2025-01-15-021331 --include .config --include Documents

Options:
    -h, --help          Show this help message
    -l, --list          List available snapshots
    -i, --include PATH  Include specific path (relative to home dir)
                        Can be used multiple times
    -a, --all           Restore everything (override excludes)
    -d, --dry-run       Show what would be restored without doing it
EOF
}

# List available snapshots
list_snapshots() {
  log_info "Available snapshots:"
  tmutil listlocalsnapshots / | sed 's/com.apple.TimeMachine.\(.*\).local/\1/'
}

# Check if snapshot exists
check_snapshot() {
  local snapshot_date=$1
  if ! tmutil listlocalsnapshots / | grep -q "$snapshot_date"; then
    log_error "Snapshot $snapshot_date not found"
    list_snapshots
    exit 1
  fi
}

# Mount snapshot
mount_snapshot() {
  local snapshot_date=$1
  local mount_point="/tmp/snap"

  log_info "Creating mount point..."
  sudo mkdir -p "$mount_point"

  log_info "Mounting snapshot..."
  sudo mount_apfs -s "com.apple.TimeMachine.${snapshot_date}.local" /dev/disk3s5 "$mount_point"

  if [[ ! -d "/tmp/snap/Users/$(whoami)" ]]; then
    log_error "Home directory not found in snapshot"
    cleanup
    exit 1
  fi
}

# Check if path should be excluded
should_exclude() {
  local path
  path=$1
  shift
  local -a include_paths
  include_paths=("$@")

  # If path is explicitly included, don't exclude it
  for include in "${include_paths[@]}"; do
    if [[ "$path" == "$include" || "$path" == "$include"/* ]]; then
      return 1
    fi
  done

  # Check against default excludes
  for exclude in "${DEFAULT_EXCLUDES[@]}"; do
    if [[ "$path" == "$exclude" || "$path" == "$exclude"/* ]]; then
      return 0
    fi
  done

  return 1
}

# Restore home directory
restore_home() {
  local mount_point
  mount_point="/tmp/snap"
  local user_home
  user_home="/Users/$(whoami)"
  local backup_dir
  backup_dir="${user_home}/.home_backup_$(date +%Y%m%d_%H%M%S)"
  local dry_run=$1
  local restore_all=$2
  shift 2
  local -a include_paths
  include_paths=("$@")

  # Create backup of current home
  log_info "Creating backup directory: $backup_dir"
  if [[ "$dry_run" == "false" ]]; then
    mkdir -p "$backup_dir"
  fi

  # Get list of files to restore
  cd "${mount_point}${user_home}" || exit 1
  local -a files_to_restore
  files_to_restore=()

  while IFS= read -r file; do
    local relative_path
    relative_path="${file#./}"
    if [[ "$restore_all" == "true" ]] || ! should_exclude "$relative_path" "${include_paths[@]}"; then
      files_to_restore+=("$relative_path")
    fi
  done < <(find . -type f -o -type l)

  # Show what will be restored
  log_info "Files to be restored:"
  printf '%s\n' "${files_to_restore[@]}"

  if [[ "$dry_run" == "true" ]]; then
    log_info "Dry run complete. No files were modified."
    return
  fi

  # Perform the restore
  log_info "Starting restore..."
  for file in "${files_to_restore[@]}"; do
    local dir_path
    if ! dir_path=$(dirname "${user_home}/${file}"); then
      log_error "Failed to get directory path for ${file}"
      return 1
    fi

    # Backup existing file if it exists
    if [[ -f "${user_home}/${file}" ]]; then
      mkdir -p "$(dirname "${backup_dir}/${file}")"
      cp -P "${user_home}/${file}" "${backup_dir}/${file}"
    fi

    # Create directory structure and copy file
    mkdir -p "$dir_path"
    sudo cp -P "${mount_point}${user_home}/${file}" "${user_home}/${file}"
  done

  # Fix permissions
  log_info "Fixing permissions..."
  sudo chown -R "$(whoami)" "$user_home"

  log_info "Backup of previous files saved to: $backup_dir"
}

# Cleanup
cleanup() {
  log_info "Cleaning up..."
  sudo umount /tmp/snap 2>/dev/null || true
  sudo rmdir /tmp/snap 2>/dev/null || true
}

# Main script
main() {
  local dry_run
  dry_run=false
  local restore_all
  restore_all=false
  local -a include_paths
  include_paths=()
  local snapshot_date
  snapshot_date=""

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    -l | --list)
      list_snapshots
      exit 0
      ;;
    -d | --dry-run)
      dry_run=true
      shift
      ;;
    -a | --all)
      restore_all=true
      shift
      ;;
    -i | --include)
      if [[ -z "${2:-}" ]]; then
        log_error "Include path required"
        exit 1
      fi
      include_paths+=("$2")
      shift 2
      ;;
    *)
      if [[ -z "$snapshot_date" ]]; then
        snapshot_date=$1
      else
        log_error "Unexpected argument: $1"
        usage
        exit 1
      fi
      shift
      ;;
    esac
  done

  if [[ -z "$snapshot_date" ]]; then
    log_error "Snapshot date required"
    usage
    exit 1
  fi

  # Validate snapshot exists
  check_snapshot "$snapshot_date"

  # Ensure cleanup on script exit
  trap cleanup EXIT

  # Mount and restore
  mount_snapshot "$snapshot_date"
  restore_home "$dry_run" "$restore_all" "${include_paths[@]}"

  log_info "Restoration complete!"
}

main "$@"
