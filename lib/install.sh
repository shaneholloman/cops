#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

get_cask_app_name() {
  local cask="$1"
  brew info --json=v2 --cask "$cask" 2>/dev/null | jq -r '.casks[0].artifacts[]? | select(.app)? | .app[0]?' 2>/dev/null || echo ""
}

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
    # Check if this tool was in the install list (attempted installation)
    local was_installed=false
    if [[ ${#CLI_TOOLS_TO_INSTALL[@]} -gt 0 ]]; then
      for install_tool in "${CLI_TOOLS_TO_INSTALL[@]}"; do
        if [[ "$install_tool" == "$tool" ]]; then
          was_installed=true
          break
        fi
      done
    fi

    if [[ "$was_installed" == "true" ]]; then
      # This tool was attempted to be installed, check if it succeeded via brew
      if brew list 2>/dev/null | grep -q "^${tool}$"; then
        print_validation_result "$tool" "true" "install"
      else
        print_validation_result "$tool" "false" "install"
      fi
    else
      # This tool was already installed, just verify it's still there
      if validate_tool "$tool"; then
        print_validation_result "$tool" "true" "already-installed"
      else
        print_validation_result "$tool" "false" "validate"
      fi
    fi
  done < <(get_config_array '.tools.cli[]')

  # Validate cask applications
  while IFS= read -r app; do
    # Check if this app was in the install list (attempted installation)
    local was_installed=false
    if [[ ${#CASK_APPS_TO_INSTALL[@]} -gt 0 ]]; then
      for install_app in "${CASK_APPS_TO_INSTALL[@]}"; do
        if [[ "$install_app" == "$app" ]]; then
          was_installed=true
          break
        fi
      done
    fi

    if [[ "$was_installed" == "true" ]]; then
      # This app was attempted to be installed, check if it succeeded
      if brew list --cask 2>/dev/null | grep -q "^${app}$"; then
        print_validation_result "$app" "true" "install"
      else
        print_validation_result "$app" "false" "install"
      fi
    else
      # This app was already installed, just verify it's still there
      if brew list --cask 2>/dev/null | grep -q "^${app}$"; then
        print_validation_result "$app" "true" "already-installed"
      else
        # For manually installed apps, check if they exist in Applications
        local app_name
        app_name=$(get_cask_app_name "$app")

        if [[ -n "$app_name" && -d "/Applications/$app_name" ]]; then
          print_validation_result "$app" "true" "already-installed"
        else
          print_validation_result "$app" "false" "validate"
        fi
      fi
    fi
  done < <(get_config_array '.tools.cask[]')
}

backup_existing_files() {
  print_header "Backing up existing files"
  for file in .gitconfig .zshrc .vimrc; do
    if [[ -f "$HOME/$file" ]]; then
      print_warning "Backing up $HOME/$file to $HOME/$file.backup"
      if ! mv "$HOME/$file" "$HOME/$file.backup"; then
        print_error "Failed to backup $HOME/$file - aborting to prevent data loss"
        return 1
      fi
      print_success "Successfully backed up $HOME/$file"
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
