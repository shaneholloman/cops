# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**COPS (Config OPeratorS)** is a modern macOS configuration management system written in Bash. It provides safe, structured macOS system configuration with comprehensive backup and restore capabilities.

## Key Commands

### Primary Operations

```bash
# System preparation for new machines
./bootstrap.sh

# Apply configuration (main command)
./cops.sh

# Use custom config file
./cops.sh --config-file configs/desktop.yaml

# Auto-agree mode (CI only)
./cops.sh --auto-agree

# Code quality analysis (MUST run after any script changes)
./analyze.sh
```

### Development Workflow

```bash
# Development location (optional approach)
git clone https://github.com/shaneholloman/cops.git ~/projects/cops
cd ~/projects/cops
./cops.sh  # Still updates ~/.cops

# Active configuration location
cd ~/.cops
# All changes go here, this is the single source of truth
```

## Architecture

### Core Design Principles

- **Safety by Design**: APFS snapshots, validation, master switches, reversible operations
- **Single Source of Truth**: Centralized `~/.cops/config.yaml`
- **Modular Architecture**: Independent library modules in `lib/` directory
- **Zero External Dependencies**: Native shell implementation, self-contained

### Key Files Structure

```tree
~/.cops/
├── config.yaml          # Master configuration file
├── cops.sh               # Main setup script
├── bootstrap.sh          # System preparation
├── analyze.sh    # Code quality tool
└── lib/                  # Modular libraries
    ├── main.sh           # Core orchestration
    ├── output.sh         # Console output functions
    ├── config.sh         # Configuration parsing
    ├── brewbundle.sh     # Package management
    ├── preferences.sh    # macOS system preferences
    └── [other modules]
```

## Development Standards (CRITICAL)

### Shell Script Requirements

Every shell script MUST have:

1. Shebang: `#!/bin/bash`
2. ShellCheck directive: `# shellcheck shell=bash`
3. Error handling: `set -e`
4. Undefined variable protection: `set -u`
5. Executable permissions

### Code Style Rules

- Use `printf` instead of `echo`
- Use `[[ ]]` for file testing (never `[ ]`)
- Quote all variable expansions: `"$variable"`
- Use `local` variables in functions
- Avoid hardcoded paths (use `$HOME`, `$COPS_ROOT`, `$LIB_DIR`)
- No trailing whitespace
- Function naming: `name()` format (avoid 'function' keyword)

### Validation Process (MANDATORY)

1. **ALWAYS** run `./analyze.sh` after ANY script modification
2. Fix ALL issues before proceeding to next file
3. Never commit code that doesn't pass analysis
4. Follow file-by-file validation workflow

### Path Variables

- `$COPS_ROOT`: Points to ~/.cops
- `$LIB_DIR`: Points to ~/.cops/lib
- `$HOME`: User home directory
- Always use these instead of hardcoded paths

## Configuration System

### Master Configuration: `config.yaml`

Contains master switches for all system-modifying features:

- `enable_spotlight`: Spotlight indexing control
- `enable_preferences`: System preferences
- `enable_tools`: CLI tools installation
- `enable_aliases`: Shell aliases
- `enable_vim`: Vim configuration
- `enable_snapshots`: APFS snapshots
- `enable_brewbundle`: Package management

### Safety Features

- APFS snapshots before changes
- Comprehensive backup system with timestamps
- Master switches for granular control
- Validation layers before execution
- Reversible operations with restore capabilities

## Library Module System

### Core Libraries (`lib/` directory)

- `main.sh`: Core orchestration logic
- `output.sh`: Standardized console output
- `config.sh`: Configuration parsing and validation
- `brewbundle.sh`: Homebrew package management
- `preferences.sh`: macOS system preferences
- `aliases.sh`: Shell alias management
- `spotlight.sh`: Spotlight indexing control
- `restore.sh`: Backup and restore operations
- `validate.sh`: System validation checks

### Adding New Modules

1. Create in `lib/` directory with `.sh` extension
2. Make executable: `chmod +x newmodule.sh`
3. Source in `cops.sh` using `$LIB_DIR`
4. Export any shared variables
5. Run `./analyze.sh` to verify

## Testing and Quality Assurance

### Before Any Changes

1. Read `docs/reference/shell-standards.md`
2. Understand existing code structure
3. Plan changes carefully

### During Development

1. Edit one file at a time
2. Run `./analyze.sh` after each change
3. Fix ALL issues before proceeding

### Before Committing

1. Run final `./analyze.sh` check
2. Verify all scripts pass validation
3. Test functionality if possible

## Documentation Structure

- `docs/user/`: User guides and configuration reference
- `docs/dev/`: Developer documentation and architecture
- `docs/reference/`: Shell standards and project status
- `docs/dev/briefs/`: Development session documentation

## Override API Key for Claude Code

To override the API key used for Claude Code, you can use any of these methods:

### Environment Variable

```bash
export ANTHROPIC_API_KEY="your-api-key"
claude-code
```

### Command Line Flag

```bash
claude-code --api-key="your-api-key"
```

### Configuration File

Create `~/.config/claude-code/config.yaml`:

```yaml
api_key: "your-api-key"
```

### Per-Project Configuration

Create `.claude-code.yaml` in your project root:

```yaml
api_key: "your-api-key"
```

The precedence order is: command line flag > environment variable > project config > global config.
