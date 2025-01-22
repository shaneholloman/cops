# Configuration Reference

Complete reference for config.yaml settings.

## Master Switches

```yaml
# All features default to false for safety
enable_preferences: false  # System preferences
enable_tools: false       # CLI tools
enable_aliases: false     # Shell aliases
enable_vim: false        # Vim configuration
enable_file_assoc: false # File associations
enable_snapshots: false  # APFS snapshots
enable_brewbundle: false # Brewfile processing
```

## Required Settings

```yaml
# User information (required)
user:
  name: "Your Name"
  email: "email@example.com"

# Paths (required)
paths:
  cops: "$HOME/.cops"
  oh_my_posh_theme: "$HOME/path/to/theme.omp.json"
```

## Optional Settings

### Directory Structure

```yaml
directories:
  - bin
  - config/git
  - config/zsh
  - config/vim
  - config/aws
  - config/terraform
  - config/k8s
  - scripts
  - .local/bin
```

### Shell Configuration

```yaml
shell:
  default: "zsh"
  theme:
    type: "oh-my-posh"
    path: "~/path/to/theme.omp.json"
  env_vars:
    AWS_CONFIG_FILE: "$HOME/.aws/config"
    AWS_SHARED_CREDENTIALS_FILE: "$HOME/.aws/credentials"
    KUBECONFIG: "$HOME/.kube/config"
    TERRAFORM_CONFIG: "$HOME/.terraform.d/config.tfrc"
```

### Git Settings

```yaml
git:
  editor: "vim"
  default_branch: "main"
  pull_rebase: true
  color_ui: true
```

### Vim Settings

```yaml
vim:
  options:
    - "syntax on"
    - "set number"
    - "set ruler"
    - "set expandtab"
    - "set tabstop=2"
    - "set shiftwidth=2"
    - "set autoindent"
    - "set smartindent"
    - "set paste"
    - "set hlsearch"
    - "set incsearch"
    - "set cursorline"
  filetypes:
    yaml: "setlocal ts=2 sts=2 sw=2 expandtab"
    terraform: "setlocal ts=2 sts=2 sw=2 expandtab"
    json: "setlocal ts=2 sts=2 sw=2 expandtab"
```

### Package Management

```yaml
brewbundle:
  install_types:
    formulas: true
    casks: true
    vscode: false
  paths:
    - "$COPS_ROOT/Brewfile"
    - "$HOME/.Brewfile"
    - "$HOME/Brewfile"

tools:
  cli:  # Partial list, see config.yaml for full list
    - awscli
    - terraform
    - kubernetes-cli
    - yq
    - volta
    - uv

  cask:  # Partial list, see config.yaml for full list
    - docker
    - iterm2
    - visual-studio-code
    - visual-studio-code@insiders
```

### System Preferences

```yaml
preferences:
  enable_groups:  # All groups default false
    terminal: false
    security: false
    input: false
    finder: false
    dock: false
    safari: false
    global: false
    activity: false

  terminal:
    iterm2:
      "Normal Font": "Hack Nerd Font Mono 12"
    global:
      KeyRepeat: 1
      InitialKeyRepeat: 10
      ApplePressAndHoldEnabled: false

  finder:
    finder:
      ShowPathbar: true
      ShowStatusBar: true
      AppleShowAllFiles: false
      _FXSortFoldersFirst: true
      FXDefaultSearchScope: "SCcf"

  dock:
    dock:
      autohide: true
      tilesize: 48
      mineffect: "genie"

  input:
    trackpad:
      Clicking: true
      TrackpadThreeFingerDrag: true
    global:
      "com.apple.mouse.scaling": 2.0
      "com.apple.trackpad.scaling": 1.5

  security:
    screensaver:
      askForPassword: 1
      askForPasswordDelay: 0
```

### File Associations

```yaml
file_associations:
  editor:
    bundle_id: "com.microsoft.VSCodeInsiders"
  extensions:
    - "py"    # Python
    - "js"    # JavaScript
    - "ts"    # TypeScript
    - "css"   # CSS
    - "json"  # JSON
    - "md"    # Markdown
    - "xml"   # XML
    - "yaml"  # YAML
    - "yml"   # YAML
    - "sh"    # Shell scripts
```

### Backup/Restore

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

## Command Reference

```bash
# Apply configuration
./cops-setup.sh

# List backups
./cops-setup.sh --list-backups [type]

# Restore file
./cops-setup.sh --restore type file

# Preview restore
./cops-setup.sh --dry-run --restore type file

# Restore all from timestamp
./cops-setup.sh --restore-all timestamp

# Run tests
./cops-setup.sh --test
```
