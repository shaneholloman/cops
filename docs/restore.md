# Restore System

> Safely restore your configuration files from backups

## Overview

The COPS restore system provides a safe and flexible way to recover your configuration files from backups. It supports:

- Listing available backups
- Restoring individual files
- Restoring all files from a specific timestamp
- Previewing changes before applying them
- Automatic safety backups before any restore

## Commands

### List Available Backups

```bash
# List all backups
./cops-setup.sh --list-backups

# List backups for a specific type
./cops-setup.sh --list-backups preferences
./cops-setup.sh --list-backups shell
./cops-setup.sh --list-backups git
./cops-setup.sh --list-backups vim
```

### Restore a Single File

```bash
# Restore a specific file
./cops-setup.sh --restore preferences com.googlecode.iterm2

# Preview restore without making changes
./cops-setup.sh --dry-run --restore preferences com.googlecode.iterm2
```

### Restore All Files from a Timestamp

```bash
# Restore all files from a specific timestamp
./cops-setup.sh --restore-all 20250122_141621

# Preview restore without making changes
./cops-setup.sh --dry-run --restore-all 20250122_141621
```

## Safety Features

1. **Dry Run Mode**
   - Use `--dry-run` to preview changes
   - Shows what would be restored without making changes
   - Helps prevent unintended modifications

2. **Backup Verification**
   - Validates backup files before restore
   - Ensures backups are readable and not corrupted
   - Verifies plist files are valid (for preferences)

3. **Safety Backups**
   - Creates a backup of current files before restore
   - Allows recovery if something goes wrong
   - Timestamped for easy identification

4. **User Confirmation**
   - Prompts for confirmation before changes
   - Shows exactly what will be restored
   - Option to cancel at any time

## Examples

### List Recent Backups

```bash
$ ./cops-setup.sh --list-backups preferences
=== Available Backups ===
• Preferences Backups:
  • 2025-01-22 14:15:04: com.googlecode.iterm2
  • 2025-01-22 14:16:21: com.googlecode.iterm2
```

### Preview a Restore

```bash
$ ./cops-setup.sh --dry-run --restore preferences com.googlecode.iterm2
Restore operation:
  From: /Users/username/.cops/backups/preferences/com.googlecode.iterm2_20250122_141621.plist
  To: /Library/Preferences/com.googlecode.iterm2
Dry run - no changes made
```

### Restore Multiple Files

```bash
$ ./cops-setup.sh --restore-all 20250122_141621
Restoring all files from 20250122_141621
Files to restore:
  • preferences: com.googlecode.iterm2
  • preferences: -g
Proceed with restore? [y/N]
```

## Troubleshooting

### No Backups Found

If you see "No backups found":

1. Check if you're using the correct backup type
2. Verify the backup directory exists: ~/.cops/backups
3. Ensure backups were created for the files you want to restore

### Restore Failed

If a restore operation fails:

1. Check if you have permission to write to the destination
2. Verify the backup file is not corrupted
3. Try using --dry-run to preview the operation
4. Check the backup file exists and is readable

### Invalid Timestamp

If you get an error about an invalid timestamp:

1. Use the exact timestamp shown in --list-backups output
2. Timestamps are in format: YYYYMMDD_HHMMSS
3. Make sure to include all digits of the timestamp

## Tips

1. Always use --dry-run first to preview changes
2. List available backups to find the correct timestamp
3. Restore individual files when possible
4. Check file permissions if restore fails
5. Use safety backups if you need to undo a restore
