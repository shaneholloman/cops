# Project Analysis Sequence for `Cops` Refactoring

## 1. Core Understanding

First, understand the project's vision and direction:

```bash
read docs/core-concepts.md     # New vision and approach
read docs/dev/shellchecking.md     # Code quality standards
read docs/project-blueprint.md # Future plans, also see README.md which still need to reflect the new vision of cops instead of dotfiles
```

## 2. Current Implementation

Then, examine the current implementation flow:

```bash
read dotfiles-setup.sh        # Entry point
read config.yaml              # Configuration structure
read lib/main.sh              # Core orchestration
read lib/config.sh            # Configuration handling
read lib/checks.sh            # Validation system
read lib/setup.sh             # Environment setup
read lib/install.sh           # Tool installation
read lib/output.sh            # Logging utilities
read lib/brewbundle.sh        # Homebrew bundle support
```

## 3. Configuration Examples

Review some actual configurations:

```bash
read config/zsh/.zshrc       # Shell configuration
read config/zsh/.aliases     # Command aliases
read config/git/.gitconfig   # Git settings
```

## 4. Development Documentation

Understand development guidelines:

```bash
read docs/dev/adding-simple-tools.md    # Tool integration
read docs/dev/adding-complex-tools.md   # Advanced features
read docs/dev/master-switches.md        # Control system
read docs/dev/manual-installations.md   # Binary management
read docs/dev/restore-operations.md     # Backup capabilities
```

## 5. Past Work

Located here: `docs/archive/`

## Key Points

1. Core System:
   - YAML config
   - Shell scripts
   - No dependencies
   - Simple commands

2. Safety First:
   - Master switches
   - Backups
   - Snapshots
   - Easy rollback

3. Clean Setup:
   - Standard paths
   - Clear structure
   - Good docs
   - Easy testing

## Main Goals

1. Keep It Simple:
   - One config file
   - Clear commands
   - Safe defaults
   - Easy to check

2. Stay Safe:
   - Always backup
   - Check before change
   - Easy restore
   - Clear feedback

3. Work Smart:
   - YAML driven
   - Version control
   - Good tests
   - Clean docs
