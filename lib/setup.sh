#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

setup_directories() {
  print_header "Setting up directories"
  while IFS= read -r dir; do
    mkdir -p "$COPS_ROOT/$dir"
  done < <(get_config_array '.directories[]')
}

setup_git_config() {
  print_header "Setting up Git configuration"
  local git_config="$COPS_ROOT/config/git/.gitconfig"

  cat >"$git_config" <<EOF
[user]
    name = $(get_config '.user.name')
    email = $(get_config '.user.email')
[core]
    editor = $(get_config '.git.editor')
    excludesfile = $HOME/.gitignore_global
[color]
    ui = $(get_config '.git.color_ui')
[pull]
    rebase = $(get_config '.git.pull_rebase')
[init]
    defaultBranch = $(get_config '.git.default_branch')
EOF
}

setup_zsh_config() {
  print_header "Setting up Zsh configuration"
  local zsh_config="$COPS_ROOT/config/zsh/.zshrc"
  local theme_path
  theme_path=$(get_config '.shell.theme.path')

  # Start with path extensions
  cat >"$zsh_config" <<EOF
# Path extensions
export PATH="$COPS_ROOT/bin:$PATH"

# Oh My Posh configuration
eval "\$(oh-my-posh init zsh --config $theme_path)"

# Environment variables
EOF

  # Add environment variables
  yq eval '.shell.env_vars | to_entries | .[]' "$CONFIG_FILE" | while read -r entry; do
    local key
    key=$(echo "$entry" | yq eval '.key' -)
    local value
    value=$(echo "$entry" | yq eval '.value' -)
    echo "export $key=\"$value\"" >>"$zsh_config"
  done

  # Add aliases
  echo -e "\n# Aliases" >>"$zsh_config"
  yq eval '.aliases | to_entries | .[]' "$CONFIG_FILE" | while read -r entry; do
    local alias_name
    alias_name=$(echo "$entry" | yq eval '.key' -)
    local alias_value
    alias_value=$(echo "$entry" | yq eval '.value' -)
    echo "alias $alias_name='$alias_value'" >>"$zsh_config"
  done
}

setup_vim_config() {
  print_header "Setting up Vim configuration"
  local vim_config="$COPS_ROOT/config/vim/.vimrc"

  # Add vim options
  while IFS= read -r option; do
    echo "$option" >>"$vim_config"
  done < <(get_config_array '.vim.options[]')

  echo -e "\n\" File type specific settings" >>"$vim_config"
  yq eval '.vim.filetypes | to_entries | .[]' "$CONFIG_FILE" | while read -r entry; do
    local filetype
    filetype=$(echo "$entry" | yq eval '.key' -)
    local settings
    settings=$(echo "$entry" | yq eval '.value' -)
    echo "autocmd FileType $filetype $settings" >>"$vim_config"
  done
}

setup_file_associations() {
  print_header "Setting up file associations"

  # Ensure duti is installed
  if ! command -v duti >/dev/null 2>&1; then
    print_warning "Installing duti..."
    brew install duti
  fi

  # Get editor bundle ID
  local editor_bundle_id
  editor_bundle_id=$(get_config '.file_associations.editor.bundle_id')

  # Set up editor associations
  print_header "Setting up editor file associations"
  while IFS= read -r ext; do
    print_warning "Setting up editor association for .$ext files..."
    if ! duti -s "$editor_bundle_id" ".$ext" all; then
      print_error "Failed to set editor association for .$ext"
    else
      print_success "Successfully associated .$ext with VS Code Insiders"
    fi
  done < <(get_config_array '.file_associations.extensions[]')
}

setup_iterm2() {
  print_header "Setting up iTerm2 configuration"

  if [[ -d "/Applications/iTerm.app" ]]; then
    # Set iTerm2 as default terminal
    if ! defaults write com.apple.Terminal "Default Window Settings" -string "iTerm2" ||
      ! defaults write com.apple.Terminal "Startup Window Settings" -string "iTerm2"; then
      print_error "Failed to set iTerm2 as default terminal"
      return 1
    fi

    # Enable Finder quit menu item
    if ! defaults write com.apple.finder QuitMenuItem -bool true; then
      print_error "Failed to enable Finder quit menu item"
      return 1
    fi

    # Restart Finder to apply changes
    if ! killall Finder; then
      print_warning "Failed to restart Finder - changes may require manual restart"
    fi

    print_success "iTerm2 configuration completed successfully"
  else
    print_warning "iTerm2 not installed - skipping configuration"
  fi
}

setup_homebrew() {
  print_header "Setting up Homebrew"
  if ! command -v brew >/dev/null 2>&1; then
    print_warning "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if [[ "$(uname -m)" == 'arm64' ]]; then
    print_warning "Setting up Homebrew for Apple Silicon..."
    echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" >>"$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}
