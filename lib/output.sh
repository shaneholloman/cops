#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

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
