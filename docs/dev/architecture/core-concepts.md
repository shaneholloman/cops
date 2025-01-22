# Core Architecture Concepts

> COPS (Config OPeratorS): A modern, safe, and structured approach to macOS configuration management.

## Architectural Philosophy

COPS is built on four core architectural principles:

1. **Safety by Design**
   - Every operation is reversible
   - Changes are validated before execution
   - Comprehensive backup system
   - Master switches for granular control

2. **Single Source of Truth**
   - Centralized config.yaml
   - Structured configuration
   - Version controlled
   - Clear organization

3. **Modular Architecture**
   - Independent modules
   - Clear separation of concerns
   - Consistent interfaces
   - Pluggable design

4. **Zero External Dependencies**
   - Native shell implementation
   - Built-in safety mechanisms
   - Self-contained operation
   - macOS-native features

## System Architecture

### 1. Core Layers

```
┌─────────────────────────┐
│    Configuration Layer  │
│    (config.yaml)       │
├─────────────────────────┤
│    Validation Layer    │
│    (checks, safety)    │
├─────────────────────────┤
│    Operation Layer     │
│    (modules, actions)  │
├─────────────────────────┤
│    Safety Layer        │
│    (backups, restore)  │
└─────────────────────────┘
```

### 2. Module Organization

```sh
lib/
├── main.sh                 # Core orchestration
├── config.sh              # Configuration management
├── checks.sh             # System validation
├── preferences.sh        # Preferences management
├── preferences-discovery.sh # Preferences utilities
├── restore.sh           # Backup and restore
├── install.sh          # Package installation
├── validate.sh        # Configuration validation
└── output.sh         # Logging and output
```

### 3. Safety Infrastructure

```
┌─────────────────────┐
│   APFS Snapshots   │
├─────────────────────┤
│   Config Backups   │
├─────────────────────┤
│   Validation      │
├─────────────────────┤
│   Master Switches │
└─────────────────────┘
```

## Core Subsystems

### 1. Configuration Management

The config.yaml file serves as the single source of truth:

```yaml
# Feature Control
enable_preferences: true
enable_tools: true

# User Configuration
user:
  name: "User Name"
  email: "user@example.com"

# System Settings
preferences:
  enable_groups:
    terminal: true
    finder: true
```

### 2. Preferences System

Manages macOS system preferences:

- Group-based organization
- Automatic backup/restore
- Type validation
- Safe defaults

### 3. Backup and Restore

Comprehensive data protection:

- Timestamped backups
- File verification
- Atomic operations
- Dry-run support

### 4. Package Management

Structured tool installation:

```yaml
tools:
  cli:
    - terraform
    - kubernetes-cli
  cask:
    - docker
    - visual-studio-code
```

## Implementation Principles

### 1. Module Design

Each module follows:

- Single responsibility
- Clear interface
- Error handling
- Documentation
- Test coverage

### 2. Safety Mechanisms

Every operation includes:

- Pre-execution validation
- Automatic backup
- Error recovery
- Status logging

### 3. Configuration Flow

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│  Parse   │ -> │ Validate │ -> │  Backup  │
└──────────┘    └──────────┘    └──────────┘
     ↓              ↑               ↑
┌──────────┐    ┌──────────┐    ┌──────────┐
│  Apply   │ <- │  Check   │ <- │ Prepare  │
└──────────┘    └──────────┘    └──────────┘
```

## Development Guidelines

1. **Module Creation**
   - Follow single responsibility
   - Implement safety checks
   - Add comprehensive tests
   - Document thoroughly

2. **Safety Integration**
   - Add master switch
   - Implement backups
   - Add validation
   - Include dry-run

3. **Error Handling**
   - Clear messages
   - Recovery steps
   - State validation
   - Cleanup procedures

## Summary

COPS provides:

- Safe configuration management
- Structured organization
- Comprehensive backup/restore
- Clear development patterns

Through:

- Modular architecture
- Built-in safety
- Clear interfaces
- Consistent patterns
