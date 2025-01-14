#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

check_dotfiles() {
  print_header "Checking Existing Dotfiles"

  for file in .zshrc .gitconfig .vimrc; do
    if [[ -f "$HOME/$file" ]]; then
      print_warning "Found existing $HOME/$file (will backup)"
      if [[ -f "$DOTFILES_ROOT/config/${file#.}/$file" ]]; then
        echo "  Key differences:"
        diff -u "$HOME/$file" "$DOTFILES_ROOT/config/${file#.}/$file" 2>/dev/null || true
      fi
    else
      print_success "Will create new $HOME/$file"
    fi
  done
}

check_tools() {
  print_header "Checking Development Tools"

  # Check CLI tools
  while IFS= read -r tool; do
    if command -v "$tool" >/dev/null 2>&1; then
      version="$("$tool" --version 2>/dev/null | head -n1)"
      print_success "$tool is installed ($version)"
    else
      print_warning "$tool will be installed"
    fi
  done < <(get_config_array '.tools.cli[]')

  # Check cask applications
  while IFS= read -r app; do
    if brew list --cask 2>/dev/null | grep -q "^${app}$"; then
      print_success "$app is installed"
    else
      print_warning "$app will be installed"
    fi
  done < <(get_config_array '.tools.cask[]')
}

check_shell() {
  print_header "Checking Shell Configuration"

  local default_shell
  default_shell=$(get_config '.shell.default')
  echo "Current shell: $SHELL"
  if [[ $SHELL != */"$default_shell" ]]; then
    print_warning "Will change default shell to $default_shell"
  fi

  print_header "Checking Aliases"
  current_aliases="$(alias 2>/dev/null)"
  while IFS=': ' read -r alias_name alias_value; do
    if echo "$current_aliases" | grep -q "${alias_name}="; then
      print_warning "Alias '$alias_name' already exists (will update)"
    else
      print_success "Will add alias '$alias_name=$alias_value'"
    fi
  done < <(yq eval '.aliases | to_entries | .[] | .key + ": " + .value' "$CONFIG_FILE")
}

check_directories() {
  print_header "Checking Directory Structure"

  while IFS= read -r dir; do
    local full_path="$DOTFILES_ROOT/$dir"
    if [[ -d "$full_path" ]]; then
      print_warning "$full_path exists (will merge)"
    else
      print_success "Will create $full_path"
    fi
  done < <(get_config_array '.directories[]')
}

check_file_associations() {
  print_header "Checking File Associations"

  if ! command -v duti >/dev/null 2>&1; then
    print_warning "duti will be installed"
    return
  fi

  while IFS= read -r ext; do
    local current_handler
    current_handler=$(duti -x "$ext" 2>/dev/null | head -n1 || echo "none")
    if [[ "$current_handler" != "Visual Studio Code - Insiders" ]]; then
      print_warning ".$ext files will be associated with VS Code Insiders (current: $current_handler)"
    else
      print_success ".$ext files already associated with VS Code Insiders"
    fi
  done < <(get_config_array '.file_associations.extensions[]')
}
