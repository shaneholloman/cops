# COPS Development Guide

This guide explains how to develop and contribute to the COPS framework.

## Development Environment

### Installation Types

1. User Installation (~/.cops)
   - For managing your own configuration
   - Production environment
   - Stable release version

2. Development Installation (~/projects/cops)
   - For framework development
   - Testing environment
   - Working copy for changes

### Development Setup

```bash
# 1. Fork the repository
# Visit: https://github.com/shaneholloman/cops

# 2. Clone your fork (NOT to ~/.cops)
git clone https://github.com/your-username/cops.git ~/projects/cops
cd ~/projects/cops

# 3. Review documentation
code docs/dev/architecture/core-concepts.md
code docs/dev/guides/testing.md

# 4. Make and test changes
./analyze-scripts.sh  # Verify shell standards
./cops-setup.sh      # Test changes (updates ~/.cops)
```

## Project Structure

```sh
.
├── lib/                        # Core modules
│   ├── main.sh                # Core orchestration
│   ├── config.sh              # Configuration handling
│   ├── checks.sh              # System validation
│   ├── preferences.sh         # Preferences management
│   ├── preferences-discovery.sh # Preferences utilities
│   ├── restore.sh            # Backup and restore
│   ├── install.sh           # Package installation
│   ├── validate.sh         # Configuration validation
│   ├── setup.sh           # Environment setup
│   ├── output.sh         # Logging utilities
│   ├── aliases.sh       # Shell aliases
│   └── brewbundle.sh   # Homebrew integration
│
├── config/                    # Default configurations
│   ├── git/                  # Git configuration
│   ├── vim/                  # Vim configuration
│   └── zsh/                  # Shell configuration
│
├── docs/                     # Documentation
│   ├── user/                # User guides
│   ├── dev/                 # Developer docs
│   │   ├── architecture/   # System design
│   │   ├── guides/        # Development guides
│   │   └── briefs/       # Development briefs
│   └── reference/         # Reference docs
│
├── backups/                  # Backup storage
│   ├── preferences/         # System preferences
│   ├── shell/              # Shell configurations
│   └── git/                # Git configurations
│
└── cops-setup.sh            # Main entry point
```

## Development Guidelines

### Code Standards

- Follow [Shell Standards](../reference/shell-standards.md)
- Maximum 300 lines per module
- Comprehensive error handling
- Input validation
- Clear documentation

### Module Requirements

1. Safety Features
   - Master switch in config.yaml
   - Automatic backups
   - Validation checks
   - Error handling
   - Recovery procedures

2. Testing
   - Unit tests
   - Integration tests
   - Safety tests
   - Performance tests
   - Recovery tests

3. Documentation
   - Code comments
   - Function documentation
   - Usage examples
   - Error scenarios

### Adding Features

1. Review Documentation
   - [Core Architecture](architecture/core-concepts.md)
   - [Safety Features](architecture/safety-features.md)
   - [Adding Modules](guides/adding-modules.md)
   - [Testing Guide](guides/testing.md)

2. Implementation Steps
   - Create development brief
   - Add master switch
   - Implement core functionality
   - Add safety features
   - Write tests
   - Update documentation

## Development Workflow

### 1. Planning Phase

```bash
# Review project status
code docs/reference/project-status.md

# Check development briefs
code docs/dev/briefs/

# Create new brief for feature
code docs/dev/briefs/feature-name-brief.md
```

### 2. Development Phase

```bash
# Verify shell standards
./analyze-scripts.sh

# Run tests
./cops-setup.sh --test

# Test specific functionality
./cops-setup.sh --dry-run --restore preferences com.apple.finder
```

### 3. Testing Phase

```bash
# Full system test
./analyze-scripts.sh
./cops-setup.sh --test

# Verify in production
cd ~/.cops
./cops-setup.sh
```

### 4. Documentation Phase

```bash
# Update relevant docs
code docs/dev/briefs/feature-name-brief.md
code docs/reference/project-status.md
```

## Best Practices

### 1. Code Organization

- One feature per module
- Clear function names
- Consistent style
- Proper error handling

### 2. Safety Measures

- Validate all input
- Create backups
- Use dry-run mode
- Handle errors gracefully

### 3. Testing Strategy

- Test before commit
- Cover edge cases
- Verify rollbacks
- Check error handling

### 4. Documentation

- Keep briefs current
- Document changes
- Update examples
- Maintain changelog

## Common Development Tasks

### Adding a New Module

1. Create development brief
2. Add master switch to config.yaml
3. Create module in lib/
4. Implement safety features
5. Add tests
6. Update documentation

### Modifying Existing Module

1. Review current implementation
2. Create backup functionality
3. Make changes incrementally
4. Test thoroughly
5. Update documentation

### Testing Changes

1. Run shell analysis
2. Execute unit tests
3. Perform integration tests
4. Test in production

### Submitting Changes

1. Create feature branch
2. Make focused commits
3. Update documentation
4. Submit pull request

## Getting Help

1. Review Documentation
   - [Core Concepts](architecture/core-concepts.md)
   - [Development Guides](guides/)
   - [Reference Docs](../reference/)

2. Check Development Briefs
   - Recent changes
   - Implementation details
   - Design decisions

3. Create Issues
   - Clear description
   - Steps to reproduce
   - Expected behavior
