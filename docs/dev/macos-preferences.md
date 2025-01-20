# macOS System Preferences Guide

This document serves as a comprehensive reference for working with macOS system preferences, both manually and programmatically. It provides the foundation for understanding how COPS manages system preferences.

## Overview

macOS stores user and system preferences in property list (plist) files located in several directories:

- `~/Library/Preferences/` - User-specific preferences
- `/Library/Preferences/` - System-wide preferences
- `/System/Library/Preferences/` - Default system preferences

## Command Line Tools

### defaults

The `defaults` command is the primary tool for reading and writing preferences.

#### Reading Preferences

1. List all domains:

    ```bash
    defaults domains
    ```

2. Read all preferences for a domain:

    ```bash
    defaults read com.apple.dock
    ```

3. Read a specific preference:

    ```bash
    defaults read com.apple.dock wvous-br-corner
    ```

4. Read preference type:

    ```bash
    defaults read-type com.apple.dock wvous-br-corner
    ```

#### Writing Preferences

1. Write a string value:

    ```bash
    defaults write com.apple.dock persistent-apps -string "value"
    ```

2. Write a boolean value:

    ```bash
    defaults write com.apple.dock autohide -bool true
    ```

3. Write an integer value:

    ```bash
    defaults write com.apple.dock tilesize -int 48
    ```

4. Write an array:

    ```bash
    defaults write com.apple.dock persistent-apps -array "app1" "app2"
    ```

5. Write a dictionary:

    ```bash
    defaults write com.apple.dock persistent-apps -dict key1 value1 key2 value2
    ```

#### Deleting Preferences

1. Delete a specific preference:

    ```bash
    defaults delete com.apple.dock tilesize
    ```

2. Delete all preferences for a domain:

    ```bash
    defaults delete com.apple.dock
    ```

#### Importing/Exporting

1. Export preferences to a file:

    ```bash
    defaults export com.apple.dock ~/Desktop/dock.plist
    ```

2. Import preferences from a file:

    ```bash
    defaults import com.apple.dock ~/Desktop/dock.plist
    ```

### PlistBuddy

PlistBuddy provides more advanced plist manipulation capabilities.

1. Read a value:

    ```bash
    /usr/libexec/PlistBuddy -c "Print :tilesize" ~/Library/Preferences/com.apple.dock.plist
    ```

2. Set a value:

    ```bash
    /usr/libexec/PlistBuddy -c "Set :tilesize 48" ~/Library/Preferences/com.apple.dock.plist
    ```

3. Add a new value:

    ```bash
    /usr/libexec/PlistBuddy -c "Add :NewKey string value" ~/Library/Preferences/com.apple.dock.plist
    ```

4. Delete a value:

    ```bash
    /usr/libexec/PlistBuddy -c "Delete :tilesize" ~/Library/Preferences/com.apple.dock.plist
    ```

## Common Domains and Their Settings

### Global Domain (-g or NSGlobalDomain)

System-wide settings that affect all applications:

```bash
# Key repeat rate (lower is faster)
defaults write -g KeyRepeat -int 2

# Initial key repeat delay (lower is shorter)
defaults write -g InitialKeyRepeat -int 15

# Enable/disable press-and-hold for keys
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Dock (com.apple.dock)

Dock appearance and behavior:

```bash
# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Set icon size
defaults write com.apple.dock tilesize -int 48

# Set minimize effect (genie, scale, suck)
defaults write com.apple.dock mineffect -string "genie"
```

### Finder (com.apple.finder)

Finder behavior and appearance:

```bash
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
```

### Screenshots (com.apple.screencapture)

Screenshot behavior and location:

```bash
# Set screenshot location
defaults write com.apple.screencapture location -string "~/Desktop"

# Set screenshot format (png, jpg, pdf, tiff)
defaults write com.apple.screencapture type -string "png"

# Disable screenshot shadow
defaults write com.apple.screencapture disable-shadow -bool true

# Include date in screenshot filename
defaults write com.apple.screencapture include-date -bool true
```

### Security & Privacy

Various security-related preferences:

```bash
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable firewall
defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable FileVault (requires sudo)
sudo fdesetup enable
```

### Input Devices

Mouse and keyboard settings:

```bash
# Set mouse scaling
defaults write -g com.apple.mouse.scaling -float 2.0

# Set trackpad speed
defaults write -g com.apple.trackpad.scaling -float 1.5

# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Enable three finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
```

### Accessibility (com.apple.universalaccess)

Accessibility and universal access settings:

```bash
# Enable VoiceOver
defaults write com.apple.universalaccess voiceOverOnOffKey -bool true

# Enable Zoom
defaults write com.apple.universalaccess closeViewHotkeysEnabled -bool true

# Set zoom factor
defaults write com.apple.universalaccess closeViewZoomFactor -float 1.5

# Enable keyboard accessibility
defaults write com.apple.universalaccess enableKeyboard -bool true

# Enable sticky keys
defaults write com.apple.universalaccess stickyKey -bool true
```

## Preference History and Logging

Many preference domains maintain history logs of changes:

1. View Change History:

   ```bash
   # Read history for a specific domain
   defaults read com.apple.universalaccess History

   # Monitor preference changes in real-time
   log stream --predicate 'subsystem contains "com.apple.defaults"'
   ```

2. Common History Locations:
   - Individual preference files (.plist)
   - System logs
   - Security & privacy logs

3. Debugging Preferences:

   ```bash
   # Watch preference changes live
   defaults watch com.apple.dock

   # Monitor specific preference changes
   log show --predicate 'subsystem contains "com.apple.defaults"' --last 1h
   ```

## System Integrity Protection (SIP)

Some preferences are protected by System Integrity Protection (SIP):

1. Check SIP Status:

    ```bash
    csrutil status
    ```

2. Protected Preferences:
   - System security settings
   - Network configurations
   - Some Apple application settings

3. Working with Protected Preferences:
   - Some require sudo access
   - Others require SIP to be disabled (not recommended)
   - Many need additional authentication
   - Some require MDM/configuration profiles

## Configuration Profiles

Some preferences can only be managed through configuration profiles:

1. Profile Types:
   - User profiles (~/Library/Configuration Profiles/)
   - System profiles (/Library/Configuration Profiles/)
   - MDM-managed profiles

2. Working with Profiles:

   ```bash
   # List all profiles
   profiles list

   # Show profile details
   profiles show -type configuration

   # Install a profile
   profiles install /path/to/profile.mobileconfig

   # Remove a profile
   profiles remove -identifier com.example.profile
   ```

3. Common Profile-Managed Settings:
   - Security & privacy policies
   - Network configurations
   - Restrictions and controls
   - Application settings
   - Certificate management

4. Creating Profiles:
   - Use Apple Configurator
   - Use Profile Manager
   - Create manually (plist format)
   - Use third-party MDM solutions

## Best Practices

1. **Backup Before Changes**

   ```bash
   # Backup specific domain
   defaults export com.apple.dock ~/Desktop/dock.backup.plist

   # Backup all user preferences
   cp -R ~/Library/Preferences/ ~/Desktop/Preferences_Backup/
   ```

2. **Verify Changes**

   ```bash
   # Read back the value after writing
   defaults read com.apple.dock tilesize
   ```

3. **Restart Affected Applications**

   ```bash
   # For Dock changes
   killall Dock

   # For Finder changes
   killall Finder
   ```

4. **Handle Errors**
   - Check if domain exists before writing
   - Verify value types match expected types
   - Test changes take effect

## Common Issues and Solutions

1. **Changes Not Taking Effect**
   - Ensure correct domain name
   - Restart affected application
   - Log out and back in
   - Restart system for some changes

2. **Permission Issues**
   - Check file permissions
   - Use sudo for system-wide preferences
   - Verify SIP status for protected preferences

3. **Type Mismatches**
   - Use `defaults read-type` to verify current type
   - Ensure new value matches expected type
   - Use appropriate -type flag when writing

## COPS Implementation

This section will be updated as we implement the COPS preferences module, documenting:

- How COPS maps configuration to system preferences
- Safety measures and validation
- Backup and restore capabilities
- Group-based management
- Master switches and controls

## References

- [Apple Developer Documentation](https://developer.apple.com/documentation/foundation/preferences_and_settings)
- [NSUserDefaults Reference](https://developer.apple.com/documentation/foundation/nsuserdefaults)
- [Property List Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/PropertyLists/Introduction/Introduction.html)
