# `.cops`

(Config OPeratorS)

A modern, safe, and structured approach to macOS configuration management.

> [!IMPORTANT]
> Works, but not complete yet!
>"Cops" implements opinionated configuration choices and represents an initial foundation.
>
>Its' a modern replacement for the somewhat long-in-the-tooth dotfiles framework. For a complete overview of planned enhancements and additional features, please refer to the blueprint. Please share your opinions and suggestions.

## Quick Start

```bash
# Install your configuration
git clone https://github.com/shaneholloman/cops.git ~/.cops
cd ~/.cops
code config.yaml  # Review and customize settings
./cops-setup.sh
```

Your configuration is now:

- Set up in ~/.cops
- In a fresh git repository
- Ready for customization
- Safe to experiment with

## Overview

This repository provides multiple safeguards for risk-free testing and deployment:

  - Develop from any directory while targeting ~/.cops
  - Run risk free testing in directly in GitHub workflows
  - Verify idempotency through repeated test runs
  - Use Time Machine snapshots for instant rollbacks
  - Test changes in isolation from your active configuration

A modular "cops" management system for macOS that automates the setup of development environments through a centralized YAML configuration. The system emphasizes safety, reversibility, and maintainability through master switches and comprehensive backup capabilities.

## Key Features

- **Safe by Design**
  - APFS snapshots for rollback
  - Master switches for control
  - Validation before changes
  - Backup of existing configs

- **Simple but Powerful**
  - Single config.yaml
  - No external dependencies
  - Homebrew integration
  - Modern tooling support

- **Structured Approach**
  - Organized configuration
  - Clear separation of concerns
  - Consistent directory layout
  - Easy to maintain

## Working with Cops

### Installation Location (~/.cops)

Your active configuration lives in ~/.cops:

- Personal settings in config.yaml
- Custom tool configurations
- Shell preferences and aliases
- Fresh git repo for tracking changes

```bash
# Track your changes
cd ~/.cops
git add .
git commit -m "Updated my configuration"

# Optional: Backup to your own repository
git remote add origin <your-repo-url>
git push -u origin main
```

### Development Location (optional)

You can also run cops from a different location:

```bash
# Clone to any directory for testing
git clone https://github.com/shaneholloman/cops.git ~/projects/cops
cd ~/projects/cops
./cops-setup.sh  # Updates ~/.cops
```

This allows you to:

- Test changes before applying
- Maintain a development copy
- Still update ~/.cops consistently

## Documentation

- [Core Concepts](./docs/core-concepts.md) - Philosophy and architecture
- [Installation Guide](./docs/installation.md) - Detailed setup instructions
- [Development Guide](./docs/dev/development.md) - Contributing and extending

## Contributing

To contribute to the cops framework:

1. Fork <https://github.com/shaneholloman/cops>
2. Clone your fork to a development location (not ~/.cops)
3. Make changes and test
4. Submit pull request

## License

MIT License - See [LICENSE](./LICENSE) file for details
