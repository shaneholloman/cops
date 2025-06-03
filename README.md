# COPS (Config OPeratorS)

A no-brainer macOS configuration management system that sets up your Mac and **automatically preserves your settings** so you never lose your tweaks.

## The Problem COPS Solves

**"Where are my last 6 months of tweaks?"**

You know the scenario:
1. Set up a Mac perfectly with all your apps, preferences, and configurations
2. Tweak settings over months to get everything just right
3. Get a new machine 6 months later
4. **Panic**: Where are all your customizations? What apps did you install? What were those terminal settings?

**COPS prevents this nightmare** by automatically saving your configuration every time you run it.

## Quick Start

```bash
# Fresh Mac setup
git clone https://github.com/shaneholloman/cops.git ~/.cops
cd ~/.cops
./bootstrap.sh    # Prep system dependencies  
./cops.sh         # Apply configuration and auto-save your settings
```

**That's it.** Your Mac is configured and your settings are automatically saved to git.

## Key Benefits

### 🔄 **Auto-Save Your Tweaks**
- Every time you run COPS, your configuration changes are automatically committed
- Never lose months of careful customization again
- Your `config.yaml` and system backups are preserved automatically

### 🛡️ **Safe by Design** 
- APFS snapshots before making changes (instant rollback)
- Validates everything before applying changes
- Backs up existing configs before overwriting
- Master switches to control what gets modified

### 🎯 **No-Brainer Operation**
- Single `config.yaml` file controls everything
- Works perfectly for semi-technical users
- Just run `./cops.sh` and everything happens automatically
- No complex setup or configuration required

### 🧩 **Complete Mac Setup**
- Installs CLI tools and applications via Homebrew
- Sets up development environment (shell, aliases, dotfiles)
- Configures system preferences (keyboard, terminal, etc.)
- Manages file associations and default applications

## How It Works

1. **Configure once**: Edit `config.yaml` with your preferred apps and settings
2. **Run COPS**: `./cops.sh` applies your configuration
3. **Auto-save**: Your changes are automatically committed to git
4. **New machine**: Clone your repo and run `./cops.sh` - everything restored perfectly

## Configuration

Everything is controlled by a single `config.yaml` file:

```yaml
# Enable/disable major features
enable_tools: true        # Install CLI tools and apps
enable_preferences: true  # Configure system settings  
enable_aliases: true      # Set up shell aliases
enable_snapshots: true    # Create safety snapshots

# Your applications
tools:
  cli:
    - git
    - jq
    - ripgrep
  cask:
    - claude
    - visual-studio-code
    - docker

# Auto-save your changes (recommended)
git:
  auto_commit: true   # Automatically save configuration changes
  auto_push: false    # Optionally push to remote repo
```

## Advanced Usage

### Different Configurations
```bash
# Use different configs for different machines
./cops.sh --config-file configs/desktop.yaml
./cops.sh --config-file configs/work.yaml
```

### Auto-Push to Remote
```yaml
git:
  auto_commit: true
  auto_push: true    # Also push to your remote repository
```

Set up a private repo and never lose your settings across machines.

## Safety Features

- **APFS Snapshots**: Instant system rollback if needed
- **Config Validation**: Checks YAML syntax and required tools
- **Backup Everything**: Existing dotfiles backed up with timestamps  
- **Master Switches**: Granular control over what gets modified
- **Dry Run Mode**: See what would happen before applying changes

## Documentation

- [Configuration Guide](./docs/user/configuration.md) - Complete config.yaml reference
- [System Preferences](./docs/user/preferences.md) - Available system settings
- [Development Guide](./docs/dev/development.md) - Contributing to COPS

## Requirements

- macOS (tested on recent versions)
- Git (for configuration management)
- Basic command line familiarity

Dependencies are automatically installed by `bootstrap.sh`.

## License

MIT License - See [LICENSE](./LICENSE) file for details