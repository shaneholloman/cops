# Cops

> [!CAUTION]
> Current commit `feat: added Brewfile incorporation warning` should not be used. Check back in a few hours!

- [core-concepts](./dev/core-concepts.md)
- [project analysis](./dev/project-analysis-sequence.md)

> [!IMPORTANT]
> Works, but not complete yet!
>
> This cops setup implements opinionated configuration choices and represents an initial foundation. For a complete overview of planned enhancements and additional features, please refer to the [blueprint](./dev/project-blueprint.md).
>
> The repository provides multiple safeguards for risk-free testing and deployment:
>
> - Develop from any directory while targeting ~/.cops
> - Run risk free automated tests in clean CI environments directly in GitHub
> - Verify idempotency through repeated test runs
> - Use Time Machine snapshots for instant rollbacks
> - Test changes in isolation from your active configuration

A modular cops management system for macOS that automates the setup of development environments through a centralized YAML configuration. The system emphasizes safety, reversibility, and maintainability through master switches and comprehensive backup capabilities.

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
  - Targeted cops restoration
  - Home directory restore capabilities
  - Comprehensive backup before changes

## Installation

```bash
# Clone repository
git clone https://github.com/shaneholloman/cops.git ~/.cops

# Review and customize configuration
vim ~/.cops/config.yaml

# Run setup
./cops-setup.sh
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
> These features are under development. See [blueprint](./dev/project-blueprint.md) for details.

- Manual binary installations for non-Homebrew tools
- Improved security configurations
- Development environment enhancements
- Application-specific configurations
- Extended backup capabilities

## Development Workflow

> [!NOTE]
> This repository is designed to be location-independent, allowing for safe development and testing without affecting your actual cops.

### Location Independence

The setup supports two primary workflows:

1. **Direct Installation**

    ```bash
    # Clone and run from ~/.cops
    git clone https://github.com/shaneholloman/cops-macos.git ~/.cops
    cd ~/.cops
    ./cops-setup.sh
    ```

2. **Development Mode**

    ```bash
    # Clone to any development location
    git clone https://github.com/shaneholloman/cops-macos.git ~/projects/cops-dev
    cd ~/projects/cops-dev
    ./cops-setup.sh
    ```

3. **CI Testing Mode**

    The repository includes GitHub Actions workflows that test the setup on clean macOS environments:

    ```yaml
    jobs:
      test-with-idempotency:
        runs-on: macos-latest
        steps:
          - uses: actions/checkout@v4
          - name: Test repeated installations
            run: |
              ./cops-setup.sh --auto-agree  # Skip confirmation prompts in CI
              ./cops-setup.sh --auto-agree  # Test idempotency
              ./cops-setup.sh --auto-agree  # Verify consistent results
    ```

    This provides several benefits:
    - Safe testing in isolated environments
    - Verification of idempotency through repeated runs
    - Automatic testing on clean macOS systems
    - No risk to local development environment

All approaches work identically because:

- The `config.yaml` defines the target location (`$HOME/.cops`) independently of the script location
- All paths are resolved relative to the configured `COPS_ROOT`
- Scripts can run from any location while still targeting the correct installation directory

This separation allows you to:

- Develop and test changes safely from any directory
- Keep your development work separate from your active cops
- Deploy to ~/.cops only when ready
- Maintain multiple versions or branches without conflicts

## Documentation

- [Blueprint](./dev/project-blueprint.md) - Comprehensive future plans
- [Manual Installations](./dev/archive/manual-installations.md) - Binary tool management (planned)
- [Restore Operations](./dev/archive/restore-operations.md) - Backup and restore capabilities
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
