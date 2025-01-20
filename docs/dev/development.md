# Developing Cops

This guide is for contributors who want to help improve the cops framework itself.

## Development vs Installation

Important: There's a key difference between:

- Using cops to manage your configuration (~/.cops)
- Developing the cops framework itself (development location)

### Framework Development

```bash
# 1. Fork cops on GitHub
# 2. Clone your fork to development location (NOT ~/.cops)
git clone https://github.com/your-username/cops.git ~/projects/cops
cd ~/projects/cops

# 3. Make changes and test
vim lib/main.sh  # Make framework changes
./cops-setup.sh  # Test changes (updates ~/.cops)

# 4. Submit changes
git add .
git commit -m "Description of changes"
git push origin main
# Create pull request on GitHub
```

## Project Structure

```
.
├── lib/                    # Core framework modules
│   ├── main.sh            # Main orchestration
│   ├── config.sh          # Configuration handling
│   ├── checks.sh          # Validation functions
│   ├── install.sh         # Tool installation
│   ├── setup.sh           # Environment setup
│   └── output.sh          # Logging utilities
│
├── config/                 # Default configurations
│   ├── git/               # Git configuration
│   ├── vim/               # Vim configuration
│   └── zsh/               # Shell configuration
│
├── dev/                    # Development documentation
│   ├── core-concepts.md   # Architecture and philosophy
│   ├── installation.md    # Installation guide
│   └── development.md     # This file
│
└── cops-setup.sh          # Main entry point
```

## Development Guidelines

### 1. Code Standards

- Follow [Shell Checking Guidelines](../shellchecking.md)
- Keep modules focused and small
- Add comprehensive error handling
- Include validation checks
- Document complex logic

### 2. Testing Changes

```bash
# 1. Make changes in development location
vim lib/main.sh

# 2. Run shellcheck
./analyze-scripts.sh

# 3. Test installation
./cops-setup.sh  # Updates ~/.cops

# 4. Verify changes in ~/.cops
cd ~/.cops
# Check results
```

### 3. Adding Features

- Review [Adding Simple Tools](../adding-simple-tools.md)
- Check [Adding Complex Tools](../adding-complex-tools.md)
- Follow [Master Switches](../master-switches.md) pattern
- Maintain backward compatibility

## Framework Architecture

### 1. Configuration Layer

- config.yaml as single source of truth
- Structured and validated configuration
- Master switches for feature control
- Clear organization

### 2. Implementation Layer

- Modular shell script design
- Clear separation of concerns
- Comprehensive error handling
- Consistent logging

### 3. Safety Mechanisms

- APFS snapshots
- Configuration backups
- Validation checks
- Dry-run capabilities

## Development Workflow

1. **Planning**
   - Review [Project Blueprint](../project-blueprint.md)
   - Understand affected modules
   - Plan safety measures
   - Consider backward compatibility

2. **Implementation**
   - Follow shell script standards
   - Add proper error handling
   - Include validation checks
   - Update documentation

3. **Testing**
   - Run analyze-scripts.sh
   - Test installation process
   - Verify changes in ~/.cops
   - Check error conditions

4. **Documentation**
   - Update relevant docs
   - Add code comments
   - Include examples
   - Explain complex logic

## Best Practices

1. **Code Organization**
   - Keep modules focused
   - Use clear naming
   - Document dependencies
   - Follow standards

2. **Safety First**
   - Add validation
   - Include backups
   - Handle errors
   - Test thoroughly

3. **Documentation**
   - Keep docs current
   - Include examples
   - Explain complex parts
   - Update README.md

4. **Testing**
   - Run shellcheck
   - Test installation
   - Check error cases
   - Verify cleanup
