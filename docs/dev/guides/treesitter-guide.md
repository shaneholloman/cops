# Tree-sitter Integration Guide

## Overview

This guide explains how to use tree-sitter for advanced code analysis in the COPS project. Tree-sitter provides deeper insight into code structure and helps enforce project standards beyond traditional shell script analysis.

## Prerequisites

### System Requirements

1. First, ensure Volta is properly configured in your PATH:

    ```bash
    # Add to ~/.zshrc
    export VOLTA_HOME="$HOME/.volta"
    export PATH="$VOLTA_HOME/bin:$PATH"

    # Apply changes
    source ~/.zshrc
    ```

2. Install tree-sitter tools via Volta:

    ```bash
    # Install required packages
    volta install tree-sitter-cli
    volta install tree-sitter
    volta install tree-sitter-bash

    # Verify installation
    which tree-sitter    # Should show Volta path
    tree-sitter --version
    ```

### Project Structure

```sh
.cops/
├── tools/
│   └── tree-sitter-analyzer.js  # Main analysis tool
├── lib/                         # Shell scripts to analyze
└── docs/
    └── dev/
        └── guides/
            └── tree-sitter.md   # This guide
```

## Usage

### Basic Analysis

```javascript
// Analyze a single file
node tools/tree-sitter-analyzer.js lib/main.sh

// Analyze all shell scripts
find lib -name "*.sh" -exec node tools/tree-sitter-analyzer.js {} \;
```

### Analysis Output

```javascript
Analysis Results:
Functions: 12
Variables: 24
Exports: 3
Conditionals: 8

Issues Found:
- style: Avoid using function keyword in declarations at line 45
- safety: Possible hardcoded path detected at line 67
- style: Consider using printf instead of echo at line 89
```

## Integration Points

### 1. With analyze-scripts.sh

Tree-sitter analysis can complement the existing shellcheck analysis:

```bash
#!/bin/bash
# analyze-scripts.sh

# Run shellcheck analysis first
shellcheck -x -a --severity=style "$script"

# Then run tree-sitter analysis
node tools/tree-sitter-analyzer.js "$script"
```

### 2. With CI/CD

Add tree-sitter analysis to GitHub Actions:

```yaml
steps:
  - uses: actions/checkout@v4
  - name: Setup Node.js
    uses: volta-cli/action@v4
  - name: Install dependencies
    run: |
      volta install tree-sitter-cli
      volta install tree-sitter
      volta install tree-sitter-bash
  - name: Run analysis
    run: |
      find lib -name "*.sh" -exec node tools/tree-sitter-analyzer.js {} \;
```

## Validation Rules

Tree-sitter helps enforce COPS coding standards by checking:

1. Function Declarations
   - No 'function' keyword
   - Proper naming convention
   - Local variable usage

2. Path Safety
   - No hardcoded paths
   - Proper variable usage
   - Safe directory handling

3. Command Usage
   - printf over echo
   - Safe command substitution
   - Proper error handling

4. Variable Management
   - Export declarations
   - Local scope usage
   - Undefined variables

## Extending the Analyzer

### Adding New Rules

```javascript
function checkForIssues(node, analysis) {
  // Add your custom rule
  if (node.type === 'your_pattern') {
    analysis.issues.push({
      type: 'custom',
      message: 'Your custom message',
      location: node.startPosition
    });
  }
}
```

### Supporting New Checks

1. Identify the syntax pattern
2. Add appropriate node type checks
3. Implement the validation logic
4. Add to the analysis results

## Best Practices

1. **Run Both Analyzers**
   - Always run shellcheck first
   - Use tree-sitter as additional validation
   - Fix issues from both tools

2. **Version Control**
   - Keep tree-sitter-analyzer.js in version control
   - Document any rule changes
   - Update tests for new rules

3. **Development Workflow**
   - Write/modify code
   - Run shellcheck
   - Run tree-sitter analysis
   - Fix any issues
   - Commit changes

## Troubleshooting

### Common Issues

1. **Parser Initialization Failed**
   - Check tree-sitter installation
   - Verify grammar installation
   - Check file permissions

2. **False Positives**
   - Review rule implementation
   - Add necessary exceptions
   - Document special cases

3. **Performance Issues**
   - Analyze files individually
   - Optimize traversal patterns
   - Cache parse results

## Future Enhancements

1. **Planned Features**
   - Visual parse tree output
   - Interactive fixing suggestions
   - Custom rule configuration
   - Performance optimizations

2. **Integration Ideas**
   - Editor integration
   - Real-time analysis
   - Custom report formats
   - Automated fixes

## Contributing

When adding new tree-sitter features:

1. Follow project standards
2. Add appropriate tests
3. Update documentation
4. Submit pull request

## Resources

- [Tree-sitter Documentation](https://tree-sitter.github.io/tree-sitter/)
- [Bash Grammar Repository](https://github.com/tree-sitter/tree-sitter-bash)
- [Node.js API Documentation](https://tree-sitter.github.io/tree-sitter/using-parsers)
