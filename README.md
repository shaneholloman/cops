# DevOps Environment Dotfiles

> [!IMPORTANT]
> These are now work rather well. Just note there are some opinionated choices in the setup. Also these are jsut the beginning of the setup. There are many more things that can/will be added to this setup. See my [blueprint](./dev/dotfiles-blueprint.md)

A comprehensive dotfiles management system for setting up and maintaining a consistent development environment across machines. This project automates the installation and configuration of development tools, shell preferences, and application settings through a centralized YAML configuration.

## Features

- 🛠 **Automated Tool Installation**
  - CLI tools via Homebrew (e.g., awscli, docker, kubectl, terraform)
  - Applications via Homebrew Cask (e.g., VS Code Insiders, Firefox)
  - Nerd Fonts for development environments

- ⚙️ **Configuration Management**
  - Shell configuration (zsh with Oh My Posh theme)
  - Git preferences and aliases
  - Vim settings with filetype-specific configurations
  - VS Code Insiders file associations

- 🔄 **Smart Installation Process**
  - Pre-installation system analysis
  - Automatic backup of existing configurations
  - Validation of installed components
  - Detailed installation summary and confirmation

- 🎨 **Customization**
  - YAML-based configuration
  - Extensible directory structure
  - Customizable aliases
  - Environment variable management

## Prerequisites

- macOS
- Git
- Basic command line knowledge

## Modern macOS Shell Environment

Since macOS Catalina (10.15), Apple has made zsh the default shell, replacing bash. This change reflects modern development practices, and our dotfiles system is designed to work seamlessly with this setup. Here's what you need to know:

### Shell Choices on Modern macOS

1. **Using zsh (Recommended)**
   - Default on modern macOS
   - More modern features than bash
   - Better completion system
   - More customizable

2. **Using bash**
   - Still available but requires manual installation of newer versions
   - macOS ships with an older version (3.2) due to licensing

Our dotfiles system primarily targets zsh while maintaining bash compatibility, following the broader macOS ecosystem's direction.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```

2. Review and customize `config.yaml`:
   - Update user information
   - Modify tool lists
   - Adjust aliases and paths
   - Configure environment variables

3. Install modern shell tools:

   ```bash
   brew install bash zsh
   ```

4. Run the installation script:

   ```bash
   ./dotfiles-setup.sh
   ```

The script will:

- Analyze your current setup
- Show a summary of planned changes
- Backup existing configurations
- Install and configure all components
- Validate the installation

### Shell Configuration Notes

- The system uses zsh as the default shell while maintaining bash compatibility
- Modern shell features are automatically configured
- Shell-specific configurations are isolated to prevent conflicts

## Configuration Structure

The `config.yaml` file is organized into sections:

```yaml
# User Information
user:
  name: 'Your Name'
  email: 'your.email@example.com'

# Tools to Install
tools:
  cli:
    - awscli
    - docker
    # Add/remove tools as needed
  cask:
    - visual-studio-code@insiders
    - firefox
    # Add/remove applications as needed

# Aliases and Environment Variables
aliases:
  k: 'kubectl'
  tf: 'terraform'
  # Add your preferred aliases

shell:
  env_vars:
    KUBECONFIG: '$HOME/.kube/config'
    # Add your environment variables
```

## Directory Structure

```sh
~/.dotfiles/
├── bin/                  # Custom scripts and binaries
├── config/
│   ├── git/             # Git configuration
│   ├── zsh/             # Shell configuration
│   ├── vim/             # Vim configuration
│   ├── aws/             # AWS CLI configuration
│   ├── terraform/       # Terraform configuration
│   └── k8s/             # Kubernetes configuration
└── scripts/             # Utility scripts
```

## Features in Detail

### Shell Configuration

- Zsh with Oh My Posh theme
- Custom aliases for common commands
- Environment variables for various tools
- PATH extensions for custom binaries

### Git Configuration

- User information
- Default editor settings
- Color UI preferences
- Pull/rebase preferences
- Default branch configuration

### Vim Configuration

- Syntax highlighting
- Line numbers
- Indentation settings
- Search preferences
- Filetype-specific configurations

### File Associations

- VS Code Insiders as default editor
- Automatic file type associations
- Support for common development file types

## Maintenance

### Adding New Tools

1. Add the tool name to `config.yaml` under the appropriate section (`cli` or `cask`)
2. Run `./dotfiles-setup.sh` to install new tools

### Updating Configurations

1. Modify the relevant section in `config.yaml`
2. Run `./dotfiles-setup.sh` to apply changes

### Backup and Recovery

- Original configurations are automatically backed up with `.backup` extension
- Symlinks are created for all managed configuration files

## Troubleshooting

### Common Issues

1. **Shell Compatibility**
   - Our scripts are designed to work with both modern zsh and bash
   - If you encounter shell-specific issues, ensure you have the latest shell versions:

     ```bash
     # Check shell versions
     zsh --version   # Should be 5.8 or higher
     bash --version  # Should be 5.0 or higher

     # Update if needed
     brew install bash zsh
     ```

   - Shell-specific configurations are automatically detected and applied

2. **Homebrew Installation Fails**
   - Ensure you have proper internet connection
   - Check system requirements for Homebrew

3. **File Permission Issues**
   - Run `chmod +x dotfiles-setup.sh`
   - Ensure proper permissions for configuration files

4. **Configuration Conflicts**
   - Check `.backup` files for original configurations
   - Review error messages in the installation output

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
