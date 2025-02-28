#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

check_cops() {
  print_header "Checking Existing Cops"

  for file in .zshrc .gitconfig .vimrc; do
    if [[ -f "$HOME/$file" ]]; then
      print_warning "Found existing $HOME/$file (will backup)"
      if [[ -f "$COPS_ROOT/config/${file#.}/$file" ]]; then
        echo "  Key differences:"
        diff -u "$HOME/$file" "$COPS_ROOT/config/${file#.}/$file" 2>/dev/null || true
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
    if validate_tool "$tool"; then
      print_validation_result "$tool" "true" "true"
    else
      print_validation_result "$tool" "false" "true"
    fi
  done < <(get_config_array '.tools.cli[]')

  # Check cask applications
  while IFS= read -r app; do
    if brew list --cask 2>/dev/null | grep -q "^${app}$"; then
      print_validation_result "$app" "true" "true"
    else
      print_validation_result "$app" "false" "true"
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

  # Check aliases by category
  for category in navigation common_utils git docker development; do
    yq eval ".aliases.$category" "$CONFIG_FILE" | while read -r line; do
      if [[ "$line" =~ ^([^:]+):\ *\"(.*)\"$ ]]; then
        local alias_name="${BASH_REMATCH[1]}"
        local alias_value="${BASH_REMATCH[2]}"
        # Trim whitespace
        alias_name=$(echo "$alias_name" | xargs)
        if echo "$current_aliases" | grep -q "^${alias_name}="; then
          print_warning "Alias '$alias_name' already exists (will update)"
        else
          print_success "Will add alias '$alias_name=$alias_value'"
        fi
      fi
    done
  done
}

check_directories() {
  print_header "Checking Directory Structure"

  while IFS= read -r dir; do
    local full_path
    if [[ "$dir" == ".local/bin" ]]; then
      full_path="$HOME/$dir"
    else
      full_path="$COPS_ROOT/$dir"
    fi

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

  # Check editor associations
  print_header "Checking editor file associations"
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
