# ShellCheck Guidelines for Cops Project

## Running Analysis

The project includes `analyze-scripts.sh` which performs two levels of analysis:

1. **ShellCheck Analysis**

   ```bash
   # Runs shellcheck on all shell scripts (excluding .history)
   # -x: follow source files
   # -a: show all information levels
   # --severity=style: minimum severity level
   find . -path './.history' -prune -o -name "*.sh" -type f -exec shellcheck -x -a --severity=style {} \;
   ```

2. **Custom Analysis**
   - Shell-Agnostic Practices:
     - Checks for shellcheck shell directive
     - Verifies error handling (set -e or || exit)
     - Checks for undefined variable protection (set -u)
     - Enforces printf over echo usage
     - Requires [[ ]] for file testing (no [ ])
     - Validates safe process substitution
     - Checks for proper parameter expansion
     - Enforces proper variable quoting
     - Validates safe array usage with @ expansion

   - Structure and Organization:
     - Validates path usage (no hardcoded paths)
     - Enforces consistent function naming (no 'function' keyword)
     - Ensures proper variable scoping (local variables)
     - Verifies required source files
     - Checks file permissions
     - Validates shebang lines
     - Detects trailing whitespace

To run both analyses:

```bash
./analyze-scripts.sh
```

## Common Issues to Watch For

1. **Shell-Agnostic Practices**
   - Use printf instead of echo: `printf "Hello %s\n" "$name"`
   - Use [[ ]] instead of [ ]: `if [[ -f "$file" ]]`
   - Handle process substitution errors: `< <(command || true)`
   - Quote all variable expansions: `"$variable"`
   - Use safe parameter expansion: `"${variable}"` not `$variable`
   - Use array expansion with @: `"${array[@]}"` not `${array[*]}`

2. **Variable Exports**
   - Variables used across sourced files must be exported
   - Example: `COPS_ROOT` is exported in cops-setup.sh because it's used in library files

3. **Directory Changes**
   - Always add error handling to cd commands
   - Use: `cd "$DIR" || exit 1`
   - Never use plain: `cd "$DIR"`

4. **Variable Usage**
   - Declare variables as local when they're only used within a function
   - Remove unused variables
   - Use shellcheck's SC2034 warning to identify unused variables

5. **Path Usage**
   - Avoid hardcoded paths
   - Use variables like $HOME, $COPS_ROOT, $LIB_DIR
   - System commands (brew, yq) are allowed

## Project Structure

When adding new shell scripts:

1. Place library functions in the lib/ directory
2. Name files with .sh extension
3. Make scripts executable: `chmod +x script.sh`
4. Source library files using $LIB_DIR variable

## Required Elements

Every shell script must have:

1. Proper shebang: `#!/bin/bash`
2. ShellCheck directive: `# shellcheck shell=bash`
3. Error handling: `set -e`
4. Undefined variable protection: `set -u`
5. Executable permission

## Ignoring Warnings

If you need to ignore specific shellcheck warnings:

1. Document why the warning is being ignored
2. Use inline directives sparingly and only when necessary
3. Example format:

   ```bash
   # shellcheck disable=SC2034  # Variable used in sourced files
   readonly MY_VAR="value"
   ```

## Development Workflow

1. **File-by-File Validation**
   - ALWAYS run shellcheck on each file immediately after making changes
   - Never move on to editing another file until current file passes all checks
   - Fix any issues before proceeding to next file
   - This prevents issues from compounding and makes debugging easier

2. **Running Checks**
   - For single file: `shellcheck -x -a --severity=style path/to/file.sh`
   - For all files: `./analyze-scripts.sh`
   - Always fix warnings, even style-level ones

## Pre-commit Check

Before committing changes:

1. Run analyze-scripts.sh
2. Fix any reported issues
3. Ensure both shellcheck and custom analysis pass

## Adding New Library Files

When adding new library files:

1. Add to lib/ directory
2. Source in cops-setup.sh using $LIB_DIR
3. Run analyze-scripts.sh to verify
4. Ensure any shared variables are properly exported

## Debugging Tips

If analyze-scripts.sh reports issues:

1. Check the shellcheck output for detailed warnings
2. Review custom analysis messages
3. Refer to <https://www.shellcheck.net/wiki/> for shellcheck explanations
4. Test fixes by running analyze-scripts.sh after each change

## Maintenance

Periodically:

1. Run analyze-scripts.sh on all files
2. Update this document with new common issues
3. Review any ignored warnings to see if they can be fixed
4. Check for new shellcheck versions and features

## Common ShellCheck Messages

- **SC1091**: "Not following: `file` was not specified as input"
  - This warning appears when shellcheck can't follow a sourced file
  - Fix by adding the `# shellcheck source=path/to/file` directive above the source line
  - Example:

    ```bash
    # shellcheck disable=SC1091
    # shellcheck source=lib/output.sh
    source "${LIB_DIR}/output.sh"
