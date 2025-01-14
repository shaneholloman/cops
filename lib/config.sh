#!/bin/bash
# shellcheck shell=bash

# Exit on error or undefined variable
set -e
set -u

get_config() {
  local path="$1"
  yq eval "$path" "$CONFIG_FILE" | envsubst
}

get_config_array() {
  local path="$1"
  yq eval "$path" "$CONFIG_FILE" | while read -r line; do
    echo "${line#- }"
  done
}
