#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

setup_terminal_preferences() {
  print_header "Setting up Terminal preferences"

  # iTerm2 font settings
  if [[ -d "/Applications/iTerm.app" ]]; then
    if ! defaults write com.googlecode.iterm2 "Normal Font" "$(get_config '.preferences.terminal.font')"; then
      print_error "Failed to set iTerm2 font"
      return 1
    fi
    print_success "iTerm2 font configured successfully"
  fi

  # Disable press-and-hold for keys in favor of key repeat
  if ! defaults write -g ApplePressAndHoldEnabled -bool "$(get_config '.preferences.terminal.press_and_hold')"; then
    print_error "Failed to set press and hold setting"
    return 1
  fi

  # System key repeat settings
  if ! defaults write NSGlobalDomain KeyRepeat -int "$(get_config '.preferences.terminal.key_repeat')"; then
    print_error "Failed to set key repeat rate"
    return 1
  fi

  if ! defaults write NSGlobalDomain InitialKeyRepeat -int "$(get_config '.preferences.terminal.initial_key_repeat')"; then
    print_error "Failed to set initial key repeat delay"
    return 1
  fi

  print_success "Terminal preferences configured successfully"
  print_warning "Some settings (key repeat, press-and-hold) require a system restart to take effect"
}

setup_preferences() {
  print_header "Setting up system preferences"

  setup_terminal_preferences
}
