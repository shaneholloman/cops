#!/bin/bash
# shellcheck shell=bash
# shellcheck disable=SC1091

# Exit on error or undefined variable
set -e
set -u

# Output functions matching project style
print_header() {
  printf "\n\033[1;34m=== %s ===\033[0m\n" "$1"
}

print_success() {
  printf "\033[1;32m✓ %s\033[0m\n" "$1"
}

print_warning() {
  printf "\033[1;33m! %s\033[0m\n" "$1"
}

print_error() {
  printf "\033[1;31m✗ %s\033[0m\n" "$1"
}

print_info() {
  printf "\033[1;36m• %s\033[0m\n" "$1"
}

# Check and install Homebrew
setup_homebrew() {
  print_header "Checking Homebrew Installation"

  if ! command -v brew &>/dev/null; then
    print_warning "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ "$(uname -m)" == 'arm64' ]]; then
      print_warning "Setting up Homebrew for Apple Silicon..."
      printf "eval \"\$(%s)\"" "/opt/homebrew/bin/brew shellenv" >>"$HOME/.zprofile"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed successfully"
  else
    print_success "Homebrew is already installed"
  fi
}

# Install minimum required dependencies
install_core_deps() {
  print_header "Installing Core Dependencies"

  # Install gettext (for envsubst)
  if ! command -v envsubst &>/dev/null; then
    print_warning "Installing gettext package..."
    brew install gettext
    brew link gettext --force
    print_success "Installed gettext (provides envsubst command)"
  else
    print_success "gettext is already installed"
  fi

  # Install yq (for YAML parsing)
  if ! command -v yq &>/dev/null; then
    print_warning "Installing yq package..."
    brew install yq
    print_success "Installed yq (YAML parser)"
  else
    print_success "yq is already installed"
  fi
}

# Explain what was installed
print_summary() {
  print_header "Installation Summary"
  print_info "The following core dependencies have been installed:"
  printf "\n"
  print_info "1. Homebrew - Package manager for macOS"
  print_info "   Used to install other required tools"
  printf "\n"
  print_info "2. gettext - GNU internationalization utilities"
  print_info "   Provides the envsubst command for variable substitution"
  printf "\n"
  print_info "3. yq - YAML processor"
  print_info "   Used to parse and process YAML configuration files"
  printf "\n"
  print_success "Your system is now ready to run the COPS setup script"
  print_warning "Next step: Run ./cops.sh to begin the main installation"
}

main() {
  print_header "COPS Bootstrap"

  # Ensure script is run from the correct directory
  if [[ ! -f "cops.sh" ]]; then
    print_error "Please run this script from the COPS root directory"
    exit 1
  fi

  # Make cops.sh executable if it isn't already
  if [[ ! -x "cops.sh" ]]; then
    chmod +x cops.sh
  fi

  setup_homebrew
  install_core_deps
  print_summary
}

main
