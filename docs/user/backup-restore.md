# Backup and Restore

COPS provides two methods of backup and restoration: APFS snapshots for full system recovery, and granular file-based backups for specific configurations.

## APFS Snapshot Restoration

For critical system recovery using APFS snapshots:

1. Restart your Mac and immediately press and hold Command (⌘) + R
2. Keep holding until you see the Apple logo or spinning globe
3. Once in Recovery Mode:
   - Click Utilities in the top menu
   - Select "Restore from Time Machine Backup"
   - Choose your APFS snapshot

Key points about APFS restoration:

- Process is quick and highly effective
- Maintains system integrity
- Preserves all data up to snapshot point
- Requires restart to access snapshots
- Can only access snapshots through Recovery Mode

Note: APFS snapshots are different from Time Machine backups. They provide a point-in-time system state that can be restored much faster than traditional backups.

## Configuration

```yaml
restore:
  paths:
    mount_point: "/tmp/snap"
    disk_device: "/dev/disk3s5"
    user_home: "$HOME"
    root: "/"
    backup_dir_prefix: ".cops_backup_"
  files:
    cops:
      - ".zshrc"
      - ".bashrc"
      - ".gitconfig"
    config_dirs:
      - ".config"
      - ".aws"
      - ".terraform.d"
      - ".kube"
      - ".vscode-insiders"
```

## Backup Types

```sh
~/.cops/backups/
├── preferences/  # macOS preferences
├── shell/        # Shell configs
├── git/          # Git configs
└── vim/          # Vim configs
```

## Commands

### List Backups

```bash
# All backups
./cops-setup.sh --list-backups

# Specific type
./cops-setup.sh --list-backups preferences
```

### Restore Files

```bash
# Preview restore
./cops-setup.sh --dry-run --restore preferences com.apple.finder

# Restore file
./cops-setup.sh --restore preferences com.apple.finder

# Restore all from timestamp
./cops-setup.sh --restore-all 20250122_141621
```

## Troubleshooting

1. Check backup exists:

    ```bash
    ./cops-setup.sh --list-backups
    ```

2. Verify file permissions:

    ```bash
    ls -l ~/.cops/backups
    ```

3. Try dry-run first:

    ```bash
    ./cops-setup.sh --dry-run --restore preferences com.apple.finder
    ```

4. Check error messages:
    - Verify timestamp format (YYYYMMDD_HHMMSS)
    - Ensure backup directory exists
    - Run with sudo if needed
