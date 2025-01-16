# Project Analysis Sequence for COPS Refactoring

## 1. Core Understanding

First, understand the project's vision and direction:

```bash
read dev/core-concepts.md     # New vision and approach
read dev/shellchecking.md     # Code quality standards
read dev/project-blueprint.md # Future plans, also see README.md which still need to reflect the new vision of cops instead of dotfiles
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
read dev/adding-simple-tools.md    # Tool integration
read dev/adding-complex-tools.md   # Advanced features
read dev/master-switches.md        # Control system
read dev/manual-installations.md   # Binary management
read dev/restore-operations.md     # Backup capabilities
```

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

## File System Migration

### Current to New Naming

```bash
# Core Files
dotfiles-setup.sh          → cops-setup.sh
dotfiles-blueprint.md      → cops-blueprint.md      # Keep familiar blueprint term
.dotfiles_backup_         → .cops-backup_          # Standard backup terminology

# Directories
~/.dotfiles               → ~/.config/cops
config/                   → config/                 # Keep standard config dir
dev/                      → docs/                   # Standard docs location

# Documentation
adding-simple-tools.md    → tools.md               # Simple, clear naming
adding-complex-tools.md   → advanced-tools.md      # Developer-friendly
manual-installations.md   → manual-setup.md        # Clear purpose
restore-operations.md     → backup-restore.md      # Standard terminology
```

The naming maintains clarity for developers while establishing COPS identity:

- Uses standard directory names (config/, docs/)
- Keeps familiar terms (blueprint, backup, tools)
- Clear purpose in filenames
- COPS prefix where it matters

### Legacy System Handling

1. Check Existing Setup:
   - Look for common dotfiles
   - Note any package managers
   - Check for frameworks
   - List custom configs

2. Simple Backup:
   - Copy all dotfiles
   - Save package lists
   - Document setup
   - Keep restore info

3. Clean Start:
   - Remove old configs
   - Clear old managers
   - Fresh COPS install
   - Import settings

### Legacy Migration

1. Simple Backup:

   ```bash
   # Backup existing dotfiles
   cp -r ~/.* ~/.cops-backup/ # TODO: actually is we are detecting a legacy dotfiles setup then we should call it .dotfiles-backup
   ```

2. Basic Detection:

   ```bash
   # Check common files
   [[ -f ~/.zshrc ]] && echo "Found zsh config"
   [[ -f ~/.bashrc ]] && echo "Found bash config"
   [[ -d ~/.oh-my-zsh ]] && echo "Found oh-my-zsh" # NOTE: cops installs oh-my-posh
   ```

3. Clean Install:

   ```bash
   # Fresh start
   rm -f ~/.zshrc ~/.bashrc  # Remove old configs
   ./cops-setup.sh           # Install COPS
   ```

### Migration Steps

1. Backup:
   - Save old configs
   - Document setup
   - Keep restore path

2. Install:
   - Remove old setup
   - Run COPS install
   - Import settings

3. Test:
   - Check tools work
   - Verify configs
   - Test commands

### Repository Update

1. GitHub:

   ```bash
   # Update repo
   git remote set-url origin https://github.com/user/cops-macos.git
   ```

2. Documentation:
   - Update README
   - Fix links
   - New examples

### Implementation

1. Core Setup:
   - YAML config
   - Safety checks
   - Clean install

2. Standards:
   - Shell rules
   - Clear docs
   - Good tests
