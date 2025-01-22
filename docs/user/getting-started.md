# Getting Started

COPS manages macOS configuration through a central YAML file.

## Install

```bash
git clone https://github.com/shaneholloman/cops.git ~/.cops
cd ~/.cops
code config.yaml  # Edit configuration
./cops-setup.sh
```

## Configuration

config.yaml controls:

```yaml
# Feature switches
enable_preferences: false  # System preferences
enable_tools: false       # CLI tools
enable_aliases: false     # Shell aliases
enable_vim: false        # Vim editor configuration
enable_file_assoc: false # File associations setup
enable_snapshots: true   # APFS snapshots
enable_brewbundle: false # Process Brewfiles

# Required: User info
user:
  name: "Your Name"
  email: "email@example.com"

# Optional: Tool installation
tools:
  cli:
    - git
    - terraform
  cask:
    - iterm2
    - docker
```

## Commands

```bash
# Apply changes
./cops-setup.sh

# List backups
./cops-setup.sh --list-backups

# Restore file
./cops-setup.sh --restore preferences com.apple.finder

# Preview restore
./cops-setup.sh --dry-run --restore preferences com.apple.finder
```

## Documentation

- [Configuration Guide](configuration.md)
- [System Preferences](preferences.md)
- [Backup/Restore](backup-restore.md)

## Issues

1. Run with --dry-run first
2. Check config.yaml syntax
3. Create GitHub issue with:
   - Command output
   - config.yaml (redact private data)
   - Steps to reproduce
