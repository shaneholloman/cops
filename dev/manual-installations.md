# Manual Installation Module Concept

Future, not implemented yet.

## Overview

An Ansible-inspired approach for managing manual binary installations that can't be handled through package managers like Homebrew.

## Configuration Structure

```yaml
tools:
  manual:
    - name: "terraform"
      version: "1.6.6"
      url: "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_darwin_amd64.zip"
      filename: "terraform.zip"
      binary_path: "terraform"
      install_name: "terraform"
      version_cmd: "terraform version"
      version_pattern: "v1.6.6"
```

## Key Components

1. **Declarative Configuration**
   - Tool metadata in config.yaml
   - Version control
   - Installation paths
   - Verification commands

2. **Implementation (lib/manual.sh)**
   - Download handling
   - Archive extraction
   - Binary installation
   - Permission management
   - Version verification

## Use Cases

1. **HashiCorp Tools**
   - Tools moving to BUSL license
   - Version-specific installations
   - Direct binary downloads

2. **Other Binary Tools**
   - Custom-built tools
   - Version-locked tools
   - Tools without package manager support

## Benefits

1. **Maintainability**
   - Clear separation of configuration and implementation
   - Easy version updates
   - Centralized tool management

2. **Flexibility**
   - Supports different archive formats
   - Handles various binary locations
   - Custom version verification

3. **Integration**
   - Fits existing cops structure
   - Uses current logging/output system
   - Follows established patterns

## Future Considerations

1. **Archive Types**
   - ZIP archives
   - TAR archives
   - Raw binaries
   - Installation scripts

2. **Verification Methods**
   - Version commands
   - SHA verification
   - GPG signature verification
   - Custom validation scripts

3. **Installation Locations**
   - /usr/local/bin
   - Custom paths
   - User-specific locations
   - Project-specific versions

## Implementation Notes

1. **Error Handling**
   - Download failures
   - Extraction issues
   - Permission problems
   - Version mismatches

2. **Cleanup**
   - Temporary files
   - Failed installations
   - Old versions
   - Backup management

3. **Logging**
   - Installation progress
   - Version changes
   - Error reporting
   - Success confirmation

## Example Tool Configurations

```yaml
# HashiCorp Tool
- name: "terraform"
  version: "1.6.6"
  url: "https://releases.hashicorp.com/terraform/${version}/terraform_${version}_darwin_amd64.zip"
  filename: "terraform.zip"
  binary_path: "terraform"
  install_name: "terraform"
  version_cmd: "terraform version"
  version_pattern: "v1.6.6"

# Tarball Example
- name: "custom-tool"
  version: "2.0.0"
  url: "https://example.com/tool-${version}.tar.gz"
  filename: "tool.tar.gz"
  binary_path: "dist/bin/tool"
  install_name: "tool"
  version_cmd: "tool --version"
  version_pattern: "2.0.0"
```

## Integration Points

1. **Main Flow**
   - After Homebrew installations
   - Before validation phase
   - With backup system

2. **Configuration**
   - Part of tools section
   - Version management
   - Path configuration

3. **Validation**
   - Installation checks
   - Version verification
   - Binary permissions

## Safety Considerations

1. **Backups**
   - Existing binaries
   - Configuration files
   - Version history

2. **Validation**
   - Checksum verification
   - Version confirmation
   - Permission checks

3. **Rollback**
   - Failed installations
   - Version conflicts
   - Corrupted binaries

## Notes

> This is a concept document for future development. The Ansible-inspired approach provides a clean way to manage manual binary installations while maintaining the simplicity and modularity of the cops system.
