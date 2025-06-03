#!/bin/bash
# shellcheck shell=bash
# shellcheck source=lib/preferences-discovery.sh
# shellcheck source=lib/output.sh

# Source required files
# shellcheck disable=SC1091
source "${LIB_DIR}/output.sh"

# Exit on error or undefined variable
set -e
set -u

# Preference groups in order of application
readonly PREFERENCE_GROUPS=(
  "terminal"
  "security"
  "input"
  "finder"
  "dock"
  "safari"
  "global"
  "activity"
)

# Determine preference type from value
get_preference_type() {
  local value="$1"

  # Check if boolean
  if [[ "$value" == "true" || "$value" == "false" ]]; then
    echo "bool"
    return
  fi

  # Check if integer
  if [[ "$value" =~ ^[0-9]+$ ]]; then
    echo "int"
    return
  fi

  # Check if float
  if [[ "$value" =~ ^[0-9]+\.[0-9]+$ ]]; then
    echo "float"
    return
  fi

  # Default to string
  echo "string"
}

# Sanitize input for defaults command
sanitize_preference_input() {
  local input="$1"
  # Remove shell metacharacters and command injection attempts
  # shellcheck disable=SC2016
  echo "$input" | sed 's/[;&|`$(){}\[\]\\]//' | tr -d '\n\r'
}

# Validate preference inputs
validate_preference_inputs() {
  local domain="$1"
  local key="$2"
  local value="$3"

  # Check for empty inputs
  if [[ -z "$domain" || -z "$key" || -z "$value" ]]; then
    print_error "Preference inputs cannot be empty"
    return 1
  fi

  # Check for suspicious patterns using case statements
  case "$domain$key$value" in
    *\;*|*\|*|*\&*|*\`*|*\$*|*\(*|*\)*|*\{*|*\}*|*\[*|*\]*)
      print_error "Preference inputs contain suspicious characters"
      return 1
      ;;
  esac

  return 0
}

# Apply a single preference
apply_preference() {
  local domain="$1"
  local key="$2"
  local value="$3"
  local type

  # Validate inputs first
  if ! validate_preference_inputs "$domain" "$key" "$value"; then
    return 1
  fi

  # Sanitize inputs
  domain=$(sanitize_preference_input "$domain")
  key=$(sanitize_preference_input "$key")
  value=$(sanitize_preference_input "$value")

  type=$(get_preference_type "$value")

  # Map domain using get_domain_bundle function
  domain=$(get_domain_bundle "$domain")

  print_info "Setting $domain $key to $value ($type)"

  if ! defaults write "$domain" "$key" "-${type}" "$value"; then
    print_error "Failed to set $domain $key"
    return 1
  fi

  return 0
}

# Apply preferences for a specific group
apply_group_preferences() {
  local group="$1"
  local failed=false

  # Get and process all subgroups (domains) for this group
  while IFS= read -r subgroup; do
    [ -z "$subgroup" ] && continue

    # Get all preferences for this subgroup
    while IFS=': ' read -r key value; do
      [ -z "$key" ] && continue
      if ! apply_preference "$subgroup" "$key" "$value"; then
        failed=true
      fi
    done < <(yq eval ".preferences.${group}.${subgroup} | to_entries | .[] | .key + \": \" + .value" "$CONFIG_FILE")
  done < <(yq eval ".preferences.${group} | keys | .[]" "$CONFIG_FILE")

  if [[ "$failed" == "true" ]]; then
    return 1
  fi

  return 0
}

# Check if preferences are enabled
is_preferences_enabled() {
  [[ "$(is_feature_enabled "preferences")" == "true" ]]
}

# Check if a specific preference group is enabled
is_group_enabled() {
  local group="$1"
  [[ "$(get_config ".preferences.enable_groups.${group}")" == "true" ]]
}

# Main preferences setup function
setup_preferences() {
  if ! is_preferences_enabled; then
    print_info "Preferences disabled, skipping..."
    return 0
  fi

  print_header "Setting up system preferences"

  # Initialize backup directory
  init_backup_dir

  local failed_groups=()

  # Setup each enabled preference group
  for group in "${PREFERENCE_GROUPS[@]}"; do
    if is_group_enabled "$group"; then
      print_info "Setting up $group preferences..."

      # Backup before changes
      backup_group_preferences "$group"

      if ! apply_group_preferences "$group"; then
        print_error "Failed to setup $group preferences"
        failed_groups+=("$group")
      fi
    else
      print_info "Skipping disabled group: $group"
    fi
  done

  # Report results
  if [[ ${#failed_groups[@]} -eq 0 ]]; then
    print_success "All preference groups configured successfully"
    printf "\n"
    print_warning "IMPORTANT: Some system preferences (especially keyboard and input settings)"
    print_warning "may require a restart or logout to take full effect."
  else
    print_error "Failed to configure the following groups: ${failed_groups[*]}"
    return 1
  fi
}
