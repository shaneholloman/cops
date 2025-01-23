# Tree-sitter Integration Guide

## Overview

This guide explains how to use tree-sitter's CLI for advanced code analysis in the COPS project. Tree-sitter provides deeper insight into code structure and helps enforce project standards beyond traditional shell script analysis.

## Setup

### Installation (macOS)

```bash
# 1. Ensure Volta is properly configured
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# 2. Install tree-sitter tools
volta install tree-sitter-cli
volta install tree-sitter
volta install tree-sitter-bash

# 3. Verify installation
which tree-sitter    # Should show Volta path
tree-sitter --version
```

## Basic Usage

### Analyzing Files

```bash
# Parse and display syntax tree
tree-sitter parse lib/main.sh

# Show syntax tree with highlighting
tree-sitter parse lib/main.sh --quiet --highlight
```

### Common Commands

```bash
# Generate syntax tree
tree-sitter parse script.sh

# Highlight code structure
tree-sitter highlight script.sh

# Show syntax tree in S-expression format
tree-sitter parse script.sh --quiet --sexp
```

## Integration with analyze-scripts.sh

Add tree-sitter analysis to your existing script:

```bash
#!/bin/bash
# analyze-scripts.sh

analyze_script() {
    local script="$1"

    # Run shellcheck analysis
    shellcheck -x -a --severity=style "$script"

    # Add tree-sitter analysis
    tree-sitter parse "$script" --quiet
}
```

## Understanding Tree-sitter Output

### Syntax Tree Example

```bash
# For a simple function:
function_definition
  name: (word) "my_function"
  body: (command
          name: (word) "echo"
          argument: (string) "Hello")
```

### Common Patterns to Watch

1. Function Definitions
   - Proper naming
   - No 'function' keyword
   - Body structure

2. Command Usage
   - printf vs echo
   - Command structure
   - Argument handling

3. Variable Assignments
   - Export commands
   - Local variables
   - Assignment patterns

## Troubleshooting

### Common Issues

1. Command Not Found

   ```bash
   # Check Volta PATH
   echo $PATH | grep volta

   # Verify installation
   volta list
   ```

2. Parse Errors

   ```bash
   # Check file permissions
   ls -l script.sh

   # Verify file encoding
   file script.sh
   ```

## Best Practices

1. Always run both analyzers:
   - shellcheck for shell script analysis
   - tree-sitter for structural analysis

2. Use tree-sitter parse first:

   ```bash
   tree-sitter parse script.sh
   ```

   Then check specific constructs.

3. Keep analysis focused on:
   - Code structure
   - Pattern matching
   - Style consistency

## Resources

- [Tree-sitter Documentation](https://tree-sitter.github.io)
- [Bash Grammar Reference](https://github.com/tree-sitter/tree-sitter-bash/blob/master/grammar.js)
- [CLI Usage Guide](https://tree-sitter.github.io/tree-sitter/using-parsers#command-line-tool)
