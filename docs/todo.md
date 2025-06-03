# Project Tasks

## Core System

### Misc

```sh
brew install zsh-autosuggestions
brew install zsh-autocomplete
```

```sh
source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "/opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
```

### High Priority

- [ ] Add git pre-commit hooks for linting/analyze.sh
- [ ] Rename main entry script to `cops.sh`
- [ ] Consider GitHub template repository setup
- [ ] Add update module (softwareupdate + brew)
- [ ] Add function to pull latest COPS version (preserve user config)
- [ ] Add volta setup function (global packages)
- [ ] sudo module see [brief](./dev/briefs/cops-sudo-brief.md)

### Code Improvements

- [ ] Add namespace support for k8s functions
- [ ] Add machine name function
- [ ] Add custom profile functions import
- [ ] Consider gnu stow integration

## New Modules

### MCP Integration

- [ ] Add MCP server/client module
- [ ] Add Claude desktop MCP function (volta integration)
- [ ] Add LLM setup module (Simon Willison's system)

### Development Tools

- [x] brew tweaks `HOMEBREW_NO_ENV_HINTS` etc
- [ ] terminal add `.hushlogin` (stops the last opened message)
- [ ] iterm2 add Ai plugin <https://iterm2.com/downloads/ai-plugin/iTermAI-1.1.zip>
- [ ] VSCode module
  - [ ] Extensions management
  - [ ] Settings configuration
  - [ ] Keybindings setup
  - [ ] Snippets management
  - [ ] Theme installation

- [ ] Python environment (uv)
  - [ ] Global tools installation
  - [ ] Version management
  - [ ] Example: `uv tool install mlx-whisper --python 3.12`

- [ ] Node.js environment
  - [ ] Volta integration
  - [ ] Global package management

### System Configuration

- [ ] Hostname set
  - [ ] See [brief](./dev/briefs/cops-hostname-brief.md)

Spotlight automation

  - [x] Research secure methods for sudo password handling
  - [x] Consider keychain integration for password management - wont use
  - [ ] Add sudo module for secure automation

Default applications

  - [ ] Firefox as default browser
  - [ ] VSCode as default editor
  - [ ] iTerm2 as default terminal

Security setup

  - SSH key generation (ed25519)
  - SSL certificate handling
  - OpenSSL vs LibreSSL configuration

### Network Configuration

- [ ] VPN setup
- [ ] Proxy configuration
- [ ] DNS management
- [ ] Firewall rules

### Enterprise Integration

- [ ] Domain join/leave functionality
- [ ] Intune script integration
- [ ] XCode license automation

## Completed

- [x] Single config.yaml implementation
- [x] Configurable choice of config file
- [x] Function modularization
- [x] Aliases module
- [x] Backup/restore system
- [x] Preferences management

## Notes

### PHP Setup

```sh
# Apache configuration
LoadModule php_module /opt/homebrew/opt/php/lib/httpd/modules/libphp.so
<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>
DirectoryIndex index.php index.html

# Configuration files
# /opt/homebrew/etc/php/8.4/

# Service management
brew services start php
# or
/opt/homebrew/opt/php/sbin/php-fpm --nodaemonize
```
