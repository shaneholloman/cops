# System Preferences

Manages macOS preferences through config.yaml.

## Groups

All groups default to disabled:

```yaml
preferences:
  enable_groups:
    terminal: false  # Terminal settings
    security: false  # Security settings
    input: false    # Mouse/trackpad
    finder: false   # Finder settings
    dock: false     # Dock settings
    safari: false   # Safari settings
    global: false   # System-wide
    activity: false # Activity Monitor
```

## Available Settings

### Terminal

```yaml
terminal:
  iterm2:
    "Normal Font": "Hack Nerd Font Mono 12"
  global:
    KeyRepeat: 1
    InitialKeyRepeat: 10
    ApplePressAndHoldEnabled: false
```

### Security

```yaml
security:
  screensaver:
    askForPassword: 1
    askForPasswordDelay: 0
```

### Input Devices

```yaml
input:
  trackpad:
    Clicking: true
    TrackpadThreeFingerDrag: true
  global:
    "com.apple.mouse.scaling": 2.0
    "com.apple.trackpad.scaling": 1.5
```

### Finder

```yaml
finder:
  finder:
    ShowPathbar: true
    ShowStatusBar: true
    AppleShowAllFiles: false
    _FXSortFoldersFirst: true
    FXDefaultSearchScope: "SCcf"
```

### Dock

```yaml
dock:
  dock:
    autohide: true
    tilesize: 48
    mineffect: "genie"
```

## Commands

```bash
# List backups
./cops.sh --list-backups preferences

# Restore preference
./cops.sh --restore preferences com.apple.finder

# Preview restore
./cops.sh --dry-run --restore preferences com.apple.finder

# Check current values
defaults read com.apple.finder

# Monitor changes
defaults read > before.txt
# Make changes
defaults read > after.txt
diff before.txt after.txt
```

## Troubleshooting

1. Verify group is enabled in config.yaml
2. Check domain name exists
3. Validate value types (bool, int, string)
4. Run with sudo if needed
5. Check backup directory exists
