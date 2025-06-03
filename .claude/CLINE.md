# Cline Rules for Cops Project

To prove to the user you have read these rules, please include the following phrase in your initial chat response:

"Hi Shane I have read your Cline rules and I am ready to proceed."

## General Rules

- These rules supersede any other rules in the prompt chain!
- ALWAYS read the project README before starting any work.
- ALWAYS follow: `docs/reference/shell-standards.md`
- ALWAYS ask the user is they are ready to proceed before making any changes to their code or system.
- THIS USER INSISTS to see your plan before you commit to any changes when adding need features or modules.
- Development docs are here: `docs`

## Pre-Change Requirements

1. Read `docs/reference/shell-standards.md` before making any code changes
2. Run analyze-scripts.sh on each file after modification
3. Fix all issues before moving to next file

## File Change Rules

1. All shell scripts must:
    - Have proper shebang (#!/bin/bash)
    - Include shellcheck directive (# shellcheck shell=bash)
    - Use error handling (set -e)
    - Protect against undefined variables (set -u)
    - Have executable permissions

2. Code Style:
    - Use printf instead of echo
    - Use `[[ ]]` for file testing
    - Quote all variable expansions
    - Use local variables in functions
    - Avoid hardcoded paths
    - No trailing whitespace

3. Validation Process:
    - Run analyze-scripts.sh after each file change
    - Fix any reported issues immediately
    - Do not proceed to next file until current file passes all checks

4. Path Handling:
    - Use $HOME, $COPS_ROOT, $LIB_DIR for paths
    - Avoid hardcoded paths
    - Handle directory changes with error checking

5. Function Declarations:
    - Use name() format
    - Avoid 'function' keyword
    - Use local variables

6. Variable Usage:
    - Export shared variables
    - Use local for function-scope variables
    - Quote all variable expansions
    - Use safe parameter expansion

7. Error Handling:
    - Include set -e
    - Handle command failures
    - Check directory changes
    - Validate input parameters

8. Documentation:
    - Document any shellcheck ignores
    - Explain complex logic
    - Keep code self-documenting

## Workflow Requirements

1. Before editing:
    - Read shellchecking.md
    - Understand existing code structure
    - Plan changes carefully

2. During editing:
    - Make changes to one file at a time
    - Run analyze-scripts.sh after each change
    - Fix all issues before proceeding

3. After editing:
    - Verify changes work as intended
    - Run final analyze-scripts.sh check
    - Update documentation if needed

## Development Briefs

When the user signals a development chat session is nearing its end:

User will say something like

> "I think we're done for today. Can you create a development brief for this session?"

1. Create a development brief that includes:
   - Current task status and progress
   - Key decisions made
   - Implementation patterns chosen
   - Next steps identified
   - Reference documents created

2. Document the brief in:
   - A new markdown file in docs/dev/briefs
   - With clear title and date
   - Following this projects' documentation standards

3. Link relevant documents:
   - Reference any new documentation
   - Link to related implementation files
   - Connect to existing patterns/examples

4. Ensure continuity by:
   - Documenting current context
   - Capturing design decisions
   - Preserving implementation patterns
   - Setting clear next steps

This ensures the next session starts with complete context, regardless of API memory limitations.

## GitHub Actions Workflow Operations

1. Making Changes:
   - Read the existing workflow file first
   - Understand the current workflow structure
   - Make targeted changes using replace_in_file for specific updates
   - Ensure proper YAML formatting and indentation

2. Committing Changes:

   ```bash
   git add .github/workflows/<workflow>.yml
   git commit -m "<type>: <description>"  # type: fix/feat/chore
   git push
   ```

3. Running Workflow:

   ```bash
   gh workflow run <workflow>.yml
   ```

4. Monitoring Progress:

   ```bash
   # Get latest run ID
   gh run list --workflow=<workflow>.yml --limit=1

   # View run status
   gh run view <run_id>

   # View detailed job logs
   gh run view --log --job=<job_id>
   ```

5. Observing Results:
   - Check each step's completion status
   - Review any error messages or annotations
   - Verify expected outputs and artifacts
   - Follow up on any generated URLs or resources
