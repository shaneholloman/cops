# macOS DevOps Environment Dotfiles

> [!IMPORTANT]
> Works, but not complete yet!
>
> This dotfiles setup implements opinionated configuration choices and represents an initial foundation. For a complete overview of planned enhancements and additional features, please refer to the [blueprint](./dev/dotfiles-blueprint.md).

A modular dotfiles management system for macOS that automates the setup of development environments through a centralized YAML configuration. The system emphasizes safety, reversibility, and maintainability through master switches and comprehensive backup capabilities.

## Core Features

- **Master Switches**
  - Grouped control over system modification sections
  - Safe defaults with preferences disabled by default
  - Two-step confirmation process for sanity check
  - Independent module toggles

- **Tool Management**
  - Automated installation via Homebrew (CLI tools and Cask apps)
  - Manual binary installations (planned feature)
  - Version-specific installations (planned feature)
  - Installation validation and error handling

- **Shell Environment**
  - Modern zsh configuration with Oh My Posh theme
  - Curated aliases for common operations
  - Environment variables for development tools
  - Strict shellcheck compliance

- **Backup & Restore**
  - Time Machine snapshot integration
  - Targeted dotfiles restoration
  - Home directory restore capabilities
  - Comprehensive backup before changes

## Installation

```bash
# Clone repository
git clone https://github.com/shaneholloman/dotfiles-macos.git ~/.dotfiles

# Review and customize configuration
vim ~/.dotfiles/config.yaml

# Run setup
./dotfiles-setup.sh
```

The script provides a two-step confirmation process:

1. **Master Switches Review**
   - Shows enabled/disabled status for each feature
   - Explains impact of enabled features
   - Requires explicit confirmation

2. **Detailed Changes Review**
   - Lists specific changes to be made
   - Shows tools to be installed
   - Final confirmation before proceeding

## Planned Features

> [!NOTE]
> These features are under development. See [blueprint](./dev/dotfiles-blueprint.md) for details.

- Manual binary installations for non-Homebrew tools
- Improved security configurations
- Development environment enhancements
- Application-specific configurations
- Extended backup capabilities

## Documentation

- [Blueprint](./dev/dotfiles-blueprint.md) - Comprehensive future plans
- [Manual Installations](./dev/manual-installations.md) - Binary tool management (planned)
- [Restore Operations](./dev/restore-operations.md) - Backup and restore capabilities
- [Adding Tools](./dev/adding-simple-tools.md) - Guide for tool integration
- [Master Switches](./dev/master-switches.md) - Configuration control
- [Shell Checking](./dev/shellchecking.md) - Code quality standards

## Contributing

1. Fork the repository
2. Create a feature branch
3. Follow shellcheck guidelines in dev/shellchecking.md
4. Implement changes following the modular architecture
5. Submit a pull request

## License

MIT License - See [LICENSE](./LICENSE) file for details
