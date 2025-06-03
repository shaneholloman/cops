#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

# Source our output functions
# shellcheck source=lib/output.sh
# shellcheck disable=SC1091
source "lib/output.sh"

analyze_script() {
  local script="$1"
  local issues=0

  print_header "Analyzing: $script"

  # Find shellcheck command
  local shellcheck_cmd
  shellcheck_cmd=$(command -v shellcheck)

  # Run shellcheck with our standard options
  if ! "$shellcheck_cmd" -x -a --severity=style "$script" >/dev/null 2>&1; then
    print_warning "ShellCheck found issues. Run: $shellcheck_cmd -x -a --severity=style $script"
    ((issues++))
  fi

  # Check for shellcheck shell directive
  if ! grep -q "# shellcheck shell=bash" "$script"; then
    print_warning "Missing shellcheck shell directive"
    ((issues++))
  fi

  # Check for error handling
  if ! grep -q "set -e" "$script" && ! grep -q "|| exit" "$script"; then
    print_warning "No error handling detected (set -e or || exit)"
    ((issues++))
  fi

  # Check for undefined variable protection
  if ! grep -q "set -u\|set -[a-z]*u[a-z]*" "$script"; then
    print_warning "Missing set -u (undefined variable protection)"
    ((issues++))
  fi

  # Check for hardcoded paths (excluding comments and allowed patterns)
  local allowed_vars="\\\$HOME\|\\\$COPS_ROOT\|\\\$LIB_DIR\|\\\$CONFIG_FILE\|\\\${[A-Z_]\+}"
  local allowed_cmds="brew\|yq\|command -v\|code"
  local allowed_paths="/dev/null\|/opt/homebrew/bin/brew"
  local var_expansions="\\\${[^}]\+}"

  # First pass: Find lines with potential paths, excluding comments
  local path_lines
  path_lines=$(grep -v '^[[:space:]]*#' "$script" | grep "/" || true)

  if [[ -n "$path_lines" ]]; then
    # Second pass: Filter out allowed patterns
    local suspicious_paths
    suspicious_paths=$(echo "$path_lines" |
      grep -v "$allowed_vars" |
      grep -v "$allowed_cmds" |
      grep -v "$allowed_paths" |
      grep -v "$var_expansions" |
      grep -E "(/[[:alnum:]_-]+)+/?[[:space:]]" || true)

    if [[ -n "$suspicious_paths" ]]; then
      print_warning "Contains hardcoded paths:"
      echo "${suspicious_paths//$'\n'/$'\n  '}"
      ((issues++))
    fi
  fi

  # Check for consistent function naming (no 'function' keyword)
  if grep -q "^[[:space:]]*function.*(" "$script"; then
    print_warning "Uses 'function' keyword (use name() instead)"
    ((issues++))
  fi

  # Check for non-local variable declarations in functions
  if grep -q "^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*=" "$script" | grep -v "local\|readonly\|export"; then
    print_warning "Contains non-local variable declarations in functions"
    ((issues++))
  fi

  # Check for proper lib file sourcing in main script
  if [[ "$script" =~ cops\.sh$ ]]; then
    while IFS= read -r lib_file; do
      lib_name=${lib_file##*/} # Extract filename from path
      if ! grep -q "source.*${lib_name}" "$script"; then
        print_warning "Missing required source: lib/$lib_name"
        ((issues++))
      fi
    done < <(find lib -name "*.sh" -type f)
  fi

  # Check for executable permission
  if [[ ! -x "$script" ]]; then
    print_warning "Script is not executable"
    ((issues++))
  fi

  # Check for proper shebang
  if ! head -n1 "$script" | grep -q "^#!/bin/bash"; then
    print_warning "Missing or incorrect shebang (should be #!/bin/bash)"
    ((issues++))
  fi

  # Check for trailing whitespace
  if grep -q "[[:space:]]$" "$script"; then
    print_warning "Contains trailing whitespace"
    ((issues++))
  fi

  # Check for missing source files
  while IFS= read -r line; do
    # Check source commands (ignoring line continuations)
    if [[ "$line" =~ ^[[:space:]]*source[[:space:]]+[\"\']?([^[:space:]\"\'\\]+) ]]; then
      local source_path="${BASH_REMATCH[1]}"

      # Replace variables with their values
      source_path="${source_path//\$LIB_DIR/lib}"
      source_path="${source_path//\$\{LIB_DIR\}/lib}"
      source_path="${source_path//\"/}"
      source_path="${source_path//\'/}"

      if [[ ! -f "$source_path" ]]; then
        print_warning "Missing source file: $source_path"
        ((issues++))
      fi
    fi

    # Check shellcheck source directives
    if [[ "$line" =~ ^[[:space:]]*#[[:space:]]*shellcheck[[:space:]]+source=([^[:space:]]+) ]]; then
      local source_path="${BASH_REMATCH[1]}"

      if [[ ! -f "$source_path" ]]; then
        print_warning "Missing shellcheck source file: $source_path"
        ((issues++))
      fi
    fi
  done <"$script"

  if ((issues == 0)); then
    print_success "No issues found"
  else
    print_error "Found $issues issue(s)"
  fi
  echo
  return "$issues"
}

main() {
  print_header "Starting Analysis"
  local total_issues=0

  # Find all shell scripts to analyze
  while IFS= read -r script; do
    # Run shellcheck analysis
    if ! shellcheck -x -a --severity=style "$script"; then
      print_error "ShellCheck found issues in $script"
      ((total_issues++))
      continue
    fi

    # Run custom analysis
    local script_issues=0
    analyze_script "$script"
    script_issues=$?
    ((total_issues += script_issues))
  done < <(find lib -name "*.sh" -type f && echo cops.sh && echo analyze.sh)

  print_header "Analysis Summary"
  if ((total_issues == 0)); then
    print_success "All scripts pass analysis"
  else
    print_error "Found $total_issues total issue(s)"
    echo "Review SHELLCHECK.md for guidelines on fixing these issues"
    exit 1
  fi
}

# Run the script
main
