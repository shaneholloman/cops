# Virgin macOS Configs

This directory contains the default configuration files from a fresh macOS system, captured using GitHub Actions runners.

These files serve as reference points to:

- Compare against your current configuration
- See what the original macOS defaults were
- Understand what customizations COPS has added

## Captured Files

### Shell Configuration

- `.bash_profile`: Default bash login configuration
- `.bashrc`: Default bash shell configuration

### Git Configuration

- `.gitconfig`: Global Git configuration

### SSH Configuration

- `.ssh/config`: SSH client configuration (if present)
- `.ssh/known_hosts`: Default known hosts file (if present)

### XDG Configuration

- `.config/`: Essential XDG base directory configurations
  - Limited to configs under 10MB
  - Excludes caches and temporary files

Note: These configurations are captured from a fresh GitHub Actions macOS runner, representing the default state of a new macOS system. Large SDK directories and caches are intentionally excluded to maintain a focused reference set.
