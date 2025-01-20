# Console Messages Implementation Brief

## Overview

Need to implement location-aware completion messages in cops-setup.sh based on where it was run from.

## Requirements

1. Detect Run Location:

    ```bash
    # Check if running from ~/.cops or elsewhere
    if [[ "$PWD" = "$COPS_ROOT" ]]; then
        # Running from ~/.cops
    else
        # Running from development location
    fi
    ```

2. Message Variants:

### When Running from ~/.cops

    ```
    === Installation Complete ===
    Your cops configuration is now set up in ~/.cops

    Next Steps:
    1. Your configuration is now in a fresh git repository
    2. You can track your changes with:
      git add .
      git commit -m "My initial cops configuration"

    3. To backup your configuration:
      git remote add origin <your-repo-url>
      git push -u origin main

    Note: To contribute to the cops framework itself,
    fork https://github.com/shaneholloman/cops and
    clone your fork to a different location.
    ```

### When Running from Development Location

    ```
    === Installation Complete ===
    Your cops configuration is now set up in ~/.cops

    Note: You now have cops in two locations:
    1. Current location (${PWD}):
      - Use this for testing changes before applying
      - Running cops-setup.sh from here will update ~/.cops

    2. Installation location (~/.cops):
      - Your active configuration
      - Running cops-setup.sh from here will update in place
      - This location has a fresh git repo for tracking your changes

    Next Steps:
    1. Your configuration is now in a fresh git repository
    2. You can track your changes with:
      git add .
      git commit -m "My initial cops configuration"

    3. To backup your configuration:
      git remote add origin <your-repo-url>
      git push -u origin main

    Note: To contribute to the cops framework itself,
    fork https://github.com/shaneholloman/cops and
    clone your fork to a different location.
    ```

## Implementation Notes

1. Location in Code:

    - Add to lib/main.sh after validate_installation()
    - Before final "Installation Complete" message

2. Function Structure:

    ```bash
    print_completion_message() {
        local run_location="$1"

        print_header "Installation Complete"

        if [[ "$run_location" = "installation" ]]; then
            # Print ~/.cops message variant
        else
            # Print development location variant
        fi
    }
    ```

3. Key Points:

    - Use existing print_* functions from output.sh
    - Maintain consistent formatting
    - Clear, actionable instructions
    - Explain both locations when relevant

4. Error Handling:

    - Ensure PWD and COPS_ROOT are set
    - Handle spaces in paths
    - Use proper quoting

## Related Changes

1. Git Handling:

    - Remove .git if direct clone
    - Initialize fresh repo
    - Make initial commit

2. Documentation:

    - README.md updated
    - Installation guide reflects messages
    - Development guide explains locations

## Testing

Test scenarios:

1. Fresh clone to ~/.cops
2. Development location run
3. Paths with spaces
4. Multiple runs from both locations
