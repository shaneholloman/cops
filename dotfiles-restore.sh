#!/bin/bash
# shellcheck shell=bash
set -euo pipefail

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

Restore dotfiles configuration from a Time Machine local snapshot.
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
}

# Restore files
restore_files() {
  local mount_point
  mount_point="/tmp/snap"
  local user_home
  user_home="/Users/shaneholloman"
  local backup_dir
  backup_dir="${user_home}/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

  log_info "Creating backup directory for current files..."
  mkdir -p "$backup_dir"

  # Backup current files
  log_info "Backing up current dotfiles..."
  [[ -f "${user_home}/.zshrc" ]] && cp "${user_home}/.zshrc" "$backup_dir/"
  [[ -f "${user_home}/.bashrc" ]] && cp "${user_home}/.bashrc" "$backup_dir/"
  [[ -f "${user_home}/.gitconfig" ]] && cp "${user_home}/.gitconfig" "$backup_dir/"
  [[ -d "${user_home}/.config" ]] && cp -R "${user_home}/.config" "$backup_dir/"
  [[ -d "${user_home}/.aws" ]] && cp -R "${user_home}/.aws" "$backup_dir/"
  [[ -d "${user_home}/.terraform.d" ]] && cp -R "${user_home}/.terraform.d" "$backup_dir/"
  [[ -d "${user_home}/.kube" ]] && cp -R "${user_home}/.kube" "$backup_dir/"
  [[ -d "${user_home}/.vscode-insiders" ]] && cp -R "${user_home}/.vscode-insiders" "$backup_dir/"

  # Restore from snapshot
  log_info "Restoring files from snapshot..."

  # Core config files
  sudo cp "${mount_point}${user_home}/.zshrc" "${user_home}/" 2>/dev/null || log_warn "No .zshrc found in snapshot"
  sudo cp "${mount_point}${user_home}/.bashrc" "${user_home}/" 2>/dev/null || log_warn "No .bashrc found in snapshot"
  sudo cp "${mount_point}${user_home}/.gitconfig" "${user_home}/" 2>/dev/null || log_warn "No .gitconfig found in snapshot"

  # Config directories
  if [[ -d "${mount_point}${user_home}/.config" ]]; then
    sudo cp -R "${mount_point}${user_home}/.config" "${user_home}/"
  fi

  # Tool-specific configs
  if [[ -d "${mount_point}${user_home}/.aws" ]]; then
    sudo cp -R "${mount_point}${user_home}/.aws" "${user_home}/"
  fi

  if [[ -d "${mount_point}${user_home}/.terraform.d" ]]; then
    sudo cp -R "${mount_point}${user_home}/.terraform.d" "${user_home}/"
  fi

  if [[ -d "${mount_point}${user_home}/.kube" ]]; then
    sudo cp -R "${mount_point}${user_home}/.kube" "${user_home}/"
  fi

  if [[ -d "${mount_point}${user_home}/.vscode-insiders" ]]; then
    sudo cp -R "${mount_point}${user_home}/.vscode-insiders" "${user_home}/"
  fi

  # Fix permissions
  log_info "Fixing permissions..."
  sudo chown -R "$(whoami)" "${user_home}/.config" "${user_home}/.aws" "${user_home}/.terraform.d" "${user_home}/.kube" "${user_home}/.vscode-insiders" 2>/dev/null || true
  sudo chown "$(whoami)" "${user_home}/.zshrc" "${user_home}/.bashrc" "${user_home}/.gitconfig" 2>/dev/null || true

  log_info "Backup of current files saved to: $backup_dir"
}

# Cleanup
cleanup() {
  log_info "Cleaning up..."
  sudo umount /tmp/snap 2>/dev/null || true
  sudo rmdir /tmp/snap 2>/dev/null || true
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
