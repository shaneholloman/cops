#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

install_tools() {
  print_header "Installing development tools"

  # Install missing CLI tools
  if ((${#CLI_TOOLS_TO_INSTALL[@]} > 0)); then
    print_header "Installing CLI tools"
    for tool in "${CLI_TOOLS_TO_INSTALL[@]}"; do
      print_warning "Installing $tool..."
      if brew install "$tool"; then
        print_success "$tool installed successfully"
      else
        print_error "Failed to install $tool"
      fi
    done
  fi

  # Install missing cask applications
  if ((${#CASK_APPS_TO_INSTALL[@]} > 0)); then
    print_header "Installing applications"
    for app in "${CASK_APPS_TO_INSTALL[@]}"; do
      print_warning "Installing $app..."
      if brew install --cask "$app"; then
        print_success "$app installed successfully"
      else
        print_error "Failed to install $app"
      fi
    done
  fi
}

validate_installation() {
  print_header "Validating installation"

  # Validate CLI tools
  while IFS= read -r tool; do
    local cmd
    cmd=$(get_command_name "$tool")
    if command -v "$cmd" >/dev/null 2>&1; then
      print_success "$tool installed successfully"
    else
      print_error "$tool installation failed"
    fi
  done < <(get_config_array '.tools.cli[]')

  # Validate cask applications
  while IFS= read -r app; do
    if brew list --cask 2>/dev/null | grep -q "^${app}$"; then
      print_success "$app installed successfully"
    else
      print_error "$app installation failed"
    fi
  done < <(get_config_array '.tools.cask[]')
}

backup_existing_files() {
  print_header "Backing up existing files"
  for file in .gitconfig .zshrc .vimrc; do
    if [[ -f "$HOME/$file" ]]; then
      print_warning "Backing up $HOME/$file to $HOME/$file.backup"
      mv "$HOME/$file" "$HOME/$file.backup" 2>/dev/null || true
    fi
  done
}

create_symlinks() {
  print_header "Creating symlinks"
  ln -sf "$COPS_ROOT/config/git/.gitconfig" "$HOME/.gitconfig"
  ln -sf "$COPS_ROOT/config/zsh/.zshrc" "$HOME/.zshrc"
  ln -sf "$COPS_ROOT/config/vim/.vimrc" "$HOME/.vimrc"
}

initialize_git_repo() {
  print_header "Initializing Git repository"
  cd "$COPS_ROOT" || exit 1
  git init
  git add .
  git commit -m "Initial cops setup"
}
