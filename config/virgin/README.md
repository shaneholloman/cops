# Virgin macOS Configs

This directory contains the default configuration files and directories from a fresh macOS system, captured using GitHub Actions runners.

These files serve as reference points to:

- Compare against your current configuration
- See what the original macOS defaults were
- Understand what customizations COPS has added

## Captured Files

### Shell Configs

- `zshrc`: Default system-wide zshrc from /private/etc/zshrc
- `.bash_profile`: Default bash login configuration
- `.bashrc`: Default bash shell configuration

### Development Tools

- `.cargo/`: Rust package manager configuration
- `.rustup/`: Rust toolchain configuration
- `.gradle/`: Gradle build system configuration
- `.yarn/`: Yarn package manager configuration
- `.dotnet/`: .NET SDK configuration
- `.net/`: .NET user-specific configuration

### Cloud & DevOps

- `.azure-devops/`: Azure DevOps configuration
- `.azcopy/`: Azure Copy tool configuration
- `.ssh/`: SSH directory structure (empty for security)

### Mobile Development

- `.android/`: Android SDK configuration

### General Configuration

- `.config/`: XDG base directory for application configs
- `.local/`: User-specific data files
- `.cache/`: Cache directory structure
- `.gitconfig`: Global Git configuration

Note: These configurations are captured from a fresh GitHub Actions macOS runner, representing the default state of a new macOS system.
