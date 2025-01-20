#!/bin/bash
# shellcheck shell=bash
# shellcheck disable=SC1091  # Don't warn about not following sourced files

# Exit on error or undefined variable
set -e
set -u

# Categories in order of appearance
ALIAS_CATEGORIES=(
  "navigation"
  "common_utils"
  "git"
  "docker"
  "development"
)

# Backup existing aliases file
backup_aliases() {
  local aliases_file="$COPS_ROOT/config/zsh/.aliases"
  if [[ -f "$aliases_file" ]]; then
    cp "$aliases_file" "${aliases_file}.backup"
  fi
}

# Generate aliases file
generate_aliases_file() {
  local aliases_file="$COPS_ROOT/config/zsh/.aliases"

  # Add header
  cat >"$aliases_file" <<EOF
# .aliases - doesn't use a shebang
# This file should be sourced by .zshrc

EOF

  # Add aliases by category
  for category in "${ALIAS_CATEGORIES[@]}"; do
    # Convert category name for display (common_utils -> Common Utils)
    local display_category
    display_category=$(echo "$category" | tr '_' ' ' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

    echo "## $display_category" >>"$aliases_file"

    # Get aliases for this category
    yq eval ".aliases.$category" "$CONFIG_FILE" | while read -r line; do
      if [[ "$line" =~ ^([^:]+):\ *\"(.*)\"$ ]]; then
        local alias_name="${BASH_REMATCH[1]}"
        local alias_value="${BASH_REMATCH[2]}"
        # Trim whitespace
        alias_name=$(echo "$alias_name" | xargs)
        echo "alias $alias_name='$alias_value'" >>"$aliases_file"
      fi
    done
    echo "" >>"$aliases_file"
  done
}

# Validate alias definitions
validate_aliases() {
  local category
  for category in "${ALIAS_CATEGORIES[@]}"; do
    yq eval ".aliases.$category" "$CONFIG_FILE" | while read -r line; do
      if [[ "$line" =~ ^([^:]+):\ *\"(.*)\"$ ]]; then
        local alias_name="${BASH_REMATCH[1]}"
        local alias_value="${BASH_REMATCH[2]}"
        # Trim whitespace
        alias_name=$(echo "$alias_name" | xargs)

        # Check for empty values
        if [[ -z "$alias_value" ]]; then
          print_error "Empty value for alias: $alias_name in category $category"
          return 1
        fi

        # For navigation aliases, check if directories exist
        if [[ "$category" == "navigation" ]] && [[ "$alias_value" == "cd"* ]]; then
          local dir
          dir=$(echo "$alias_value" | cut -d' ' -f2- | sed "s|~|$HOME|")
          if [[ ! -d "$dir" ]] && [[ "$dir" != ".." ]] && [[ "$dir" != "../.." ]] && [[ "$dir" != "../../.." ]]; then
            print_warning "Directory does not exist for alias $alias_name: $dir"
          fi
        fi

        # For command aliases, check if base command exists
        if [[ "$category" != "navigation" ]]; then
          local cmd
          cmd=$(echo "$alias_value" | cut -d' ' -f1)
          if ! command -v "$cmd" >/dev/null 2>&1; then
            print_warning "Command not found for alias $alias_name: $cmd"
          fi
        fi
      fi
    done
  done
}

# Setup aliases
setup_aliases() {
  if [[ "$(is_feature_enabled "aliases")" != "true" ]]; then
    print_info "Aliases disabled, skipping..."
    return 0
  fi

  print_header "Setting up aliases"

  # Validate first
  if ! validate_aliases; then
    print_error "Alias validation failed"
    return 1
  fi

  # Backup existing
  backup_aliases

  # Generate new aliases file
  generate_aliases_file

  print_success "Aliases setup complete"
}
