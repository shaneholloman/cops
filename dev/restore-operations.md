# macOS Snapshot Restore Operations Guide

## Overview

This guide covers two restoration scripts:

1. `dotfiles-restore.sh` - Targeted restoration of dotfiles and configuration - NOT USING currently!
2. `home-restore.sh` - Broader restoration of home directory contents - NOT USING currently!

Both scripts work with macOS Time Machine local snapshots, providing different levels of granularity for system restoration.

## Prerequisites

- macOS system with APFS filesystem
- Administrative (sudo) privileges
- Existing Time Machine local snapshots

## Creating Snapshots

Before any major system changes, create a snapshot:

```bash
# Create new snapshot
tmutil localsnapshot

# Verify snapshot creation
tmutil listlocalsnapshots /
```

Note: Snapshots are named in format: `com.apple.TimeMachine.YYYY-MM-DD-HHMMSS.local`

## Dotfiles Restore Script

### Dotfiles Restore Script Purpose

Targeted restoration of configuration files and directories commonly modified by dotfiles installation.

### Dotfiles Restore Script Usage

```bash
# List available snapshots
./dotfiles-restore.sh --list

# Show help
./dotfiles-restore.sh --help

# Restore from specific snapshot
./dotfiles-restore.sh 2025-01-15-021331
```

### What Gets Restored

The script restores:

- Shell configurations (~/.zshrc, ~/.bashrc)
- Git configuration (~/.gitconfig)
- Config directory (~/.config)
- Tool-specific configs:
  - AWS (~/.aws)
  - Terraform (~/.terraform.d)
  - Kubernetes (~/.kube)
  - VSCode Insiders (~/.vscode-insiders)

### Dotfiles Restore Script Backup Process

- Creates timestamped backup directory: `~/.dotfiles_backup_YYYYMMDD_HHMMSS`
- Existing files are backed up before restoration
- Original permissions are preserved

## Home Directory Restore Script

### Home Directory Restore Script Purpose

Broader restoration of home directory contents with selective inclusion/exclusion capabilities.

### Home Directory Restore Script Usage

```bash
# List available snapshots
./home-restore.sh --list

# Show help
./home-restore.sh --help

# Dry run to preview changes
./home-restore.sh 2025-01-15-021331 --dry-run

# Restore specific paths
./home-restore.sh 2025-01-15-021331 --include .config --include Documents

# Restore everything (including normally excluded paths)
./home-restore.sh 2025-01-15-021331 --all
```

### Default Exclusions

The following directories are excluded by default:

- Applications
- Library
- Movies
- Music
- Pictures
- Downloads
- Public
- Desktop

### Options

- `--dry-run`: Preview what would be restored without making changes
- `--include PATH`: Specify paths to include (can be used multiple times)
- `--all`: Override default exclusions and restore everything
- `--help`: Show usage information
- `--list`: Show available snapshots

### Home Directory Restore Script Backup Process

- Creates timestamped backup directory: `~/.home_backup_YYYYMMDD_HHMMSS`
- Only backs up files that will be overwritten
- Maintains directory structure in backup
- Preserves symlinks
- Fixes permissions after restore

## Common Operations

### Check Available Space

Before restoring, verify available disk space:

```bash
df -h ~
```

### Verify Snapshot Contents

```bash
# Mount snapshot manually
sudo mkdir -p /tmp/snap
sudo mount_apfs -s "com.apple.TimeMachine.YYYY-MM-DD-HHMMSS.local" /dev/disk3s5 /tmp/snap

# Browse contents
ls -la /tmp/snap/Users/your_username/

# Unmount when done
sudo umount /tmp/snap
```

### Clean Up Old Snapshots

```bash
# List snapshots
tmutil listlocalsnapshots /

# Delete specific snapshot
tmutil deletelocalsnapshots YYYY-MM-DD-HHMMSS

# Delete all snapshots from specific date
tmutil deletelocalsnapshots YYYY-MM-DD
```

## Troubleshooting

### Mount Failures

If snapshot mounting fails:

1. Verify snapshot exists: `tmutil listlocalsnapshots /`
2. Check disk identifier: `diskutil list`
3. Ensure no existing mount at `/tmp/snap`
4. Check system logs: `log show --predicate 'subsystem == "com.apple.TimeMachine"' --last 5m`

### Permission Issues

If you encounter permission errors:

1. Verify sudo access
2. Check file ownership: `ls -la ~/.home_backup_*`
3. Run permission fix manually: `sudo chown -R $(whoami) ~/.config/`

### Restoration Verification

After restoration:

1. Check file permissions
2. Verify critical configurations
3. Test application functionality
4. Review backup directory for any missed files

## Best Practices

1. Always create a snapshot before major system changes
2. Use --dry-run first to preview changes
3. Start with specific includes rather than --all
4. Keep track of snapshot dates and their purpose
5. Clean up old snapshots periodically
6. Verify restored files before deleting backups

## Limitations

- Snapshots are automatically purged by macOS when space is needed
- No direct access to snapshot contents without mounting
- Cannot restore system files outside home directory
- Restoration requires administrative privileges
