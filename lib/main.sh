#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

# Global arrays to store tools that need installation
declare -a CLI_TOOLS_TO_INSTALL
declare -a CASK_APPS_TO_INSTALL

store_tool_status() {
  local tool="$1"
  local type="$2"
  if ! command -v "$tool" >/dev/null 2>&1; then
    if [[ "$type" == "cli" ]]; then
      CLI_TOOLS_TO_INSTALL+=("$tool")
    fi
  fi
}

store_cask_status() {
  local app="$1"
  if ! brew list --cask 2>/dev/null | grep -q "^${app}$"; then
    CASK_APPS_TO_INSTALL+=("$app")
  fi
}

analyze_tools() {
  # Reset arrays
  CLI_TOOLS_TO_INSTALL=()
  CASK_APPS_TO_INSTALL=()

  # Check CLI tools
  while IFS= read -r tool; do
    store_tool_status "$tool" "cli"
  done < <(get_config_array '.tools.cli[]')

  # Check cask applications
  while IFS= read -r app; do
    store_cask_status "$app"
  done < <(get_config_array '.tools.cask[]')
}

show_summary() {
  print_header "Installation Summary"
  echo "This script will make the following changes:"
  echo
  echo "1. Directory Changes:"
  echo "   - Create $DOTFILES_ROOT structure"
  echo "   - Organize configurations by tool"
  echo

  # Only show tool installation section if there are tools to install
  if ((${#CLI_TOOLS_TO_INSTALL[@]} > 0)) || ((${#CASK_APPS_TO_INSTALL[@]} > 0)); then
    echo "2. Tool Installation:"
    if ((${#CLI_TOOLS_TO_INSTALL[@]} > 0)); then
      echo "   - Install CLI tools: ${CLI_TOOLS_TO_INSTALL[*]}"
    fi
    if ((${#CASK_APPS_TO_INSTALL[@]} > 0)); then
      echo "   - Install applications: ${CASK_APPS_TO_INSTALL[*]}"
    fi
    echo
  fi

  echo "3. Configuration Changes:"
  echo "   - Create or update dotfiles (.zshrc, .gitconfig, .vimrc)"
  echo "   - Backup existing configurations"
  echo "   - Set up aliases and environment variables"
  echo
  echo "4. Shell Configuration:"
  echo "   - Configure $(get_config '.shell.default') with DevOps tooling"
  echo "   - Set up Oh My Posh theme"
  echo "   - Configure development environment"
  echo
  echo "5. File Associations:"
  echo "   - Set up VS Code Insiders as default editor for development files"
  echo "   - Configure associations for common file types (py, js, ts, etc.)"
  echo
  echo "6. Terminal Configuration:"
  echo "   - Set up iTerm2 as default terminal"
  echo "   - Configure Finder integration"

  echo
  read -r -p "Would you like to proceed with these changes? [y/N] " -n 1
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 1
  fi
}

main() {
  print_header "DevOps Environment Setup Analysis"
  echo "Analyzing your current setup..."

  check_dotfiles
  check_tools
  analyze_tools # Store which tools need installation
  check_shell
  check_directories
  check_file_associations

  show_summary # Now uses the stored tool status

  # If user confirms, proceed with installation
  print_header "Starting Installation"

  setup_directories
  setup_git_config
  setup_zsh_config
  setup_vim_config
  backup_existing_files
  create_symlinks
  setup_homebrew
  install_tools
  setup_file_associations
  setup_iterm2
  validate_installation
  initialize_git_repo

  print_header "Installation Complete"
  echo "Please verify the configuration in $CONFIG_FILE matches your preferences."
  echo "Your previous configurations have been backed up with .backup extension."
}
