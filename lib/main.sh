#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

# Source our output functions
# shellcheck source=lib/output.sh
source "lib/output.sh"

# Global arrays to store tools that need installation
declare -a CLI_TOOLS_TO_INSTALL
declare -a CASK_APPS_TO_INSTALL

store_tool_status() {
  local tool="$1"
  local type="$2"
  local cmd
  cmd=$(get_command_name "$tool")
  if ! command -v "$cmd" >/dev/null 2>&1; then
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

show_master_switches() {
  print_header "Master Switches Status"

  # Show status of each master switch with explanation
  local preferences_status
  local tools_status
  local aliases_status
  local vim_status
  local file_assoc_status

  preferences_status=$(is_feature_enabled "preferences")
  tools_status=$(is_feature_enabled "tools")
  aliases_status=$(is_feature_enabled "aliases")
  vim_status=$(is_feature_enabled "vim")
  file_assoc_status=$(is_feature_enabled "file_assoc")

  printf "System Preferences: %s\n" "$([[ "$preferences_status" = "true" ]] && printf "\033[1;32mENABLED\033[0m" || printf "\033[1;31mDISABLED\033[0m")"
  printf "  - Controls system settings including keyboard and terminal preferences\n"
  printf "\n"
  printf "Tool Installation: %s\n" "$([[ "$tools_status" = "true" ]] && printf "\033[1;32mENABLED\033[0m" || printf "\033[1;31mDISABLED\033[0m")"
  printf "  - Controls installation of CLI tools and applications\n"
  printf "\n"
  printf "Shell Aliases: %s\n" "$([[ "$aliases_status" = "true" ]] && printf "\033[1;32mENABLED\033[0m" || printf "\033[1;31mDISABLED\033[0m")"
  printf "  - Controls setup of shell aliases and shortcuts\n"
  printf "\n"
  printf "Vim Configuration: %s\n" "$([[ "$vim_status" = "true" ]] && printf "\033[1;32mENABLED\033[0m" || printf "\033[1;31mDISABLED\033[0m")"
  printf "  - Controls Vim editor settings and configuration\n"
  printf "\n"
  printf "File Associations: %s\n" "$([[ "$file_assoc_status" = "true" ]] && printf "\033[1;32mENABLED\033[0m" || printf "\033[1;31mDISABLED\033[0m")"
  printf "  - Controls default application associations for file types\n"
  printf "\n"

  printf "Please review the enabled features carefully.\n"
  read -r -p "Would you like to proceed with these settings? [y/N] " -n 1
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 1
  fi
}

show_summary() {
  print_header "Installation Summary"
  printf "This script will make the following changes:\n"
  printf "\n"
  printf "1. Directory Changes:\n"
  printf "   - Create %s structure\n" "$DOTFILES_ROOT"
  printf "   - Organize configurations by tool\n"
  printf "\n"

  # Only show tool installation section if there are tools to install
  if ((${#CLI_TOOLS_TO_INSTALL[@]} > 0)) || ((${#CASK_APPS_TO_INSTALL[@]} > 0)); then
    printf "2. Tool Installation:\n"
    if ((${#CLI_TOOLS_TO_INSTALL[@]} > 0)); then
      printf "   - Install CLI tools: %s\n" "${CLI_TOOLS_TO_INSTALL[@]}"
    fi
    if ((${#CASK_APPS_TO_INSTALL[@]} > 0)); then
      printf "   - Install applications: %s\n" "${CASK_APPS_TO_INSTALL[@]}"
    fi
    printf "\n"
  fi

  printf "3. Configuration Changes:\n"
  printf "   - Create or update dotfiles (.zshrc, .gitconfig, .vimrc)\n"
  printf "   - Backup existing configurations\n"
  printf "   - Set up aliases and environment variables\n"
  printf "\n"
  printf "4. Shell Configuration:\n"
  printf "   - Configure %s with DevOps tooling\n" "$(get_config '.shell.default')"
  printf "   - Set up Oh My Posh theme\n"
  printf "   - Configure development environment\n"
  printf "\n"
  printf "5. File Associations:\n"
  printf "   - Set up VS Code Insiders as default editor for development files\n"
  printf "   - Configure associations for common file types (py, js, ts, etc.)\n"
  printf "\n"
  printf "6. Terminal Configuration:\n"
  printf "   - Set up iTerm2 as default terminal\n"
  printf "   - Configure Finder integration\n"
  printf "\n"
  read -r -p "Would you like to proceed with these changes? [y/N] " -n 1
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 1
  fi
}

main() {
  print_header "DevOps Environment Setup Analysis"
  printf "Analyzing your current setup...\n"

  check_dotfiles
  check_tools
  analyze_tools # Store which tools need installation
  check_shell
  check_directories
  check_file_associations

  # Show and confirm master switches first
  show_master_switches

  # Then show detailed summary
  show_summary

  # If user confirms, proceed with installation
  print_header "Starting Installation"

  setup_directories
  setup_git_config
  setup_zsh_config

  # Only run feature setup if enabled
  if [[ "$(is_feature_enabled "vim")" = "true" ]]; then
    setup_vim_config
  fi

  backup_existing_files
  create_symlinks
  setup_homebrew

  if [[ "$(is_feature_enabled "tools")" = "true" ]]; then
    install_tools
  fi

  if [[ "$(is_feature_enabled "file_assoc")" = "true" ]]; then
    setup_file_associations
  fi

  setup_iterm2

  if [[ "$(is_feature_enabled "preferences")" = "true" ]]; then
    setup_preferences
  fi

  validate_installation
  initialize_git_repo

  print_header "Installation Complete"
  printf "Please verify the configuration in %s matches your preferences.\n" "$CONFIG_FILE"
  printf "Your previous configurations have been backed up with .backup extension.\n"
}
