# COPS Code Review Process

This document outlines the systematic approach for conducting code reviews within the COPS project. The process ensures thorough analysis while maintaining consistency across reviews.

## Review Methodology

### 1. Initial Assessment

```bash
# List all shell scripts
find . -type f -name "*.sh"

# View shell script structure
tree -P "*.sh" -L 3
```

### 2. Core File Analysis

```bash
# Analyze shell functions
grep -r "^[a-zA-Z_][a-zA-Z0-9_]*()" lib/
```

### 3. Function Usage Verification

```bash
# Check function references
grep -r "function_name" .
```

### 4. Integration Points

```bash
# Find source/include statements
grep -r "^source " .
grep -r "^\. " .
```

### 5. Test Coverage

```bash
# Check shell test files
find . -name "*.test.sh" -o -name "*_test.sh"
```

## Review Checklist

1. **Functionality Verification**
   - [ ] Confirm function usage
   - [ ] Verify integration points
   - [ ] Check test coverage

2. **Code Quality**
   - [ ] Shellcheck compliance
   - [ ] Error handling
   - [ ] Documentation

3. **Architecture Alignment**
   - [ ] Modular design
   - [ ] Safety mechanisms
   - [ ] Configuration flow

4. **Performance Considerations**
   - [ ] Efficient algorithms
   - [ ] Proper resource handling
   - [ ] Scalability

## Documentation Standards

### Review Documentation Template

```markdown
# [Component Name] Review

## Overview
- **Component Type**: [Function/Class/Module]
- **Location**: [File Path]
- **Purpose**: [Brief Description]

## Analysis

### Functionality
- [Description of functionality]
- [Usage examples]

### Integration
- [Dependencies]
- [Integration points]

### Quality Assessment
- [Code quality evaluation]
- [Potential improvements]

### Test Coverage
- [Existing tests]
- [Test gaps]

## Recommendations
- [Suggested improvements]
- [Priority level]
```

## Verification Process

1. **Static Analysis**

    ```bash
    # Safe shellcheck analysis (read-only)
    shellcheck --shell=bash --exclude=SC1090,SC1091 --format=tty lib/*.sh | less
    ```

2. **Dynamic Testing**

    ```bash
    # Verify test files exist (read-only)
    find . -name "*.test.sh" -o -name "*_test.sh" | less
    ```

3. **Documentation Review**

    ```bash
    # Check documentation completeness
    grep -r "TODO" docs/
    grep -r "FIXME" docs/
    ```

## Review Tools

### Essential Commands

```bash
# Safe function usage tracking
grep -r "function_name" lib/ | less

# Safe shell quality analysis
shellcheck --shell=bash --exclude=SC1090,SC1091 --format=tty lib/*.sh | less

# Safe function reference analysis
for func in $(grep -r "^[a-zA-Z_][a-zA-Z0-9_]*()" lib/ | cut -d: -f2 | awk '{print $1}' | sort | uniq); do
  echo "Function: $func" | less
  grep -r "$func" lib/ | less
  echo | less
done
```

### Safety Notes

1. **Read-Only Operations**
   - All review commands should be read-only
   - Use pagers (less) to prevent accidental modifications
   - Never write to files during review process

2. **Command Safety**
   - Always use `| less` for potentially long outputs
   - Avoid redirection operators (> or >>)
   - Never use commands that modify files

3. **Environment Protection**
   - Use `set -euo pipefail` in any temporary scripts
   - Avoid creating temporary files
   - Use read-only variables where possible

## Best Practices

1. **Consistent Documentation**
   - Maintain uniform review templates
   - Use clear, concise language
   - Include code examples

2. **Thorough Analysis**
   - Verify all integration points
   - Check edge cases
   - Review error handling

3. **Collaborative Review**
   - Share findings with team
   - Discuss potential improvements
   - Document decisions

4. **Continuous Improvement**
   - Update review process regularly
   - Incorporate new tools
   - Refine documentation standards
