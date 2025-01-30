#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

check_brewbundle() {
  print_header "Checking Brewfile Status"

  # Check for Brewfiles
  while IFS= read -r brewfile_path; do
    if [[ -f "$brewfile_path" ]]; then
      print_success "Found Brewfile at: $brewfile_path"
      analyze_brewfile "$brewfile_path"
    fi
  done < <(get_config_array '.brewbundle.paths[]')
}

analyze_brewfile() {
  local brewfile="$1"

  # Analyze different sections
  local formula_count
  local cask_count
  local vscode_count

  formula_count=$(grep -c '^brew' "$brewfile" || echo "0")
  cask_count=$(grep -c '^cask' "$brewfile" || echo "0")
  vscode_count=$(grep -c '^vscode' "$brewfile" || echo "0")

  print_warning "Found in $brewfile:"
  printf "  - %d Homebrew formulas\n" "$formula_count"
  printf "  - %d Cask applications\n" "$cask_count"
  printf "  - %d VSCode extensions\n" "$vscode_count"
}

process_brewbundle() {
  print_header "Processing Brewfile Installations"

  # Get configuration
  local install_formulas
  local install_casks
  local install_vscode

  install_formulas=$(get_config '.brewbundle.install_types.formulas')
  install_casks=$(get_config '.brewbundle.install_types.casks')
  install_vscode=$(get_config '.brewbundle.install_types.vscode')

  while IFS= read -r brewfile_path; do
    if [[ -f "$brewfile_path" ]]; then
      process_single_brewfile "$brewfile_path" \
        "$install_formulas" \
        "$install_casks" \
        "$install_vscode"
    fi
  done < <(get_config_array '.brewbundle.paths[]')
}

process_single_brewfile() {
  local brewfile="$1"
  local do_formulas="$2"
  local do_casks="$3"
  local do_vscode="$4"

  print_header "Processing: $brewfile"

  # Process Homebrew formulas
  if [[ "$do_formulas" == "true" ]]; then
    process_formulas "$brewfile"
  fi

  # Process Cask applications
  if [[ "$do_casks" == "true" ]]; then
    process_casks "$brewfile"
  fi

  # Process VSCode extensions
  if [[ "$do_vscode" == "true" ]]; then
    process_vscode_extensions "$brewfile"
  fi
}

process_formulas() {
  local brewfile="$1"
  print_warning "Installing Homebrew formulas..."
  if ! brew bundle --file="$brewfile" --no-lock --only=brew; then
    print_error "Some formula installations failed"
    return 1
  fi
  print_success "Homebrew formulas installed successfully"
}

process_casks() {
  local brewfile="$1"
  print_warning "Installing Cask applications..."
  if ! brew bundle --file="$brewfile" --no-lock --only=cask; then
    print_error "Some cask installations failed"
    return 1
  fi
  print_success "Cask applications installed successfully"
}

process_vscode_extensions() {
  local brewfile="$1"
  local failed_extensions=()

  print_warning "Installing VSCode extensions..."

  # Check for VSCode installation
  if ! command -v code >/dev/null 2>&1; then
    print_warning "VSCode not installed, skipping extensions"
    return 0
  fi

  # Process extensions
  while read -r ext; do
    print_warning "Installing extension: $ext"
    if ! code --install-extension "$ext" >/dev/null 2>&1; then
      failed_extensions+=("$ext")
    fi
  done < <(grep '^vscode' "$brewfile" | cut -d'"' -f2)

  # Report failures
  if ((${#failed_extensions[@]} > 0)); then
    print_error "Failed to install extensions: ${failed_extensions[*]}"
    return 1
  fi

  print_success "VSCode extensions installed successfully"
}
