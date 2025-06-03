# COPS Hostname Module Brief

## Project Overview

This brief outlines the implementation of a hostname management module for COPS, enabling automated hostname configuration on macOS systems.

## Implementation Requirements

### Module Integration

1. Source File Addition

   ```bash
   # Must be added to cops.sh
   # shellcheck source=lib/hostname.sh
   # shellcheck disable=SC1091
   source "${LIB_DIR}/hostname.sh"
   ```

2. Configuration Addition

   ```yaml
   # config.yaml
   system:
     hostname:
       enable: true
       computer_name: "dev-macbook"  # User's computer name
       host_name: "dev-macbook"      # Network hostname
       local_host_name: "dev-macbook" # Bonjour hostname
   ```

### Master Switch Integration

```yaml
# Master Switches section in config.yaml
enable_system: true  # Parent switch for system configurations
```

## Implementation Details

### Core Functions

#### Hostname Management

```bash
set_hostname() {
  local computer_name="$1"
  local host_name="$2"
  local local_host_name="$3"

  print_header "Configuring system hostnames"

  # Requires sudo - must follow sudo handling pattern
  sudo scutil --set ComputerName "$computer_name"
  sudo scutil --set HostName "$host_name"
  sudo scutil --set LocalHostName "$local_host_name"

  # Flush DNS cache to ensure changes take effect
  sudo dscacheutil -flushcache
}

validate_hostname() {
  local hostname="$1"

  # RFC 1123 hostname validation
  if [[ ! "$hostname" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]]; then
    print_error "Invalid hostname format: $hostname"
    return 1
  fi
}
```

### Safety Features

1. Backup Current Settings
   - Store existing hostname configuration
   - Enable rollback capability
   - Document changes in backup log

2. Validation Checks
   - Verify hostname format
   - Check length restrictions
   - Validate character set
   - Ensure network compatibility

3. Error Handling
   - Graceful failure recovery
   - Clear error messages
   - Logging of changes
   - Rollback procedures

## Implementation Strategy

### Phase 1: Core Implementation

1. Create `lib/hostname.sh`
2. Implement hostname functions
3. Add configuration schema
4. Add source line to cops.sh

### Phase 2: Safety Features

1. Add validation functions
2. Implement backup system
3. Add error handling
4. Create recovery procedures

### Phase 3: Integration

1. Add master switch support
2. Implement sudo handling
3. Add logging support
4. Update documentation

## Related Files

- `lib/hostname.sh` (to be created)
- `lib/sudo.sh` (dependency)
- `lib/backup.sh` (dependency)
- `cops.sh` (requires modification)

## Common Pitfalls to Address

1. Sudo Requirements
   - Use sudo module functions exclusively - no direct sudo calls
   - Handle privilege timeouts gracefully
   - Proper error handling if sudo access fails
   - Clear user communication about privilege requirements

2. Network Impact
   - Service interruptions during hostname changes
   - DNS cache clearing requirements
   - Network stack reload timing
   - Bonjour service restart considerations

3. Validation
   - RFC 1123 hostname compliance
   - Local network constraints
   - OS version compatibility checks
   - Duplicate hostname detection

4. Error States
   - Failed sudo authentication
   - Network service unavailability
   - Invalid hostname formats
   - System state inconsistencies

## Testing Requirements

1. Functionality Testing
   - Setting each hostname type
   - Validation functions
   - Error scenarios
   - Backup/restore operations
   - Sudo integration points

2. Integration Testing
   - Sudo module interaction
   - Configuration parsing
   - Master switch behavior
   - Module sourcing order
   - Spotlight module compatibility

3. Network Testing
   - Local network visibility
   - Bonjour service detection
   - DNS resolution
   - Network service impacts
   - Multiple network interface handling

4. Security Testing
   - Privilege escalation handling
   - Credential management
   - Secure string handling
   - Injection prevention

## Documentation Requirements

1. User Guide
   - Configuration options
   - Usage examples
   - Troubleshooting steps
   - Sudo requirements
   - Network considerations

2. Developer Documentation
   - Function documentation
   - Error code reference
   - Testing procedures
   - Sudo module integration
   - Module dependencies

3. Integration Guide
   - Dependencies
   - Setup requirements
   - Network considerations
   - Privilege requirements
   - Module order requirements

## Next Steps

1. Complete sudo module implementation
   - Implement Keychain integration
   - Create sudo helper functions
   - Document sudo API

2. Update spotlight module
   - Refactor to use new sudo functions
   - Test automated operation
   - Update documentation

3. Create hostname module
   - Implement core functions
   - Add configuration support
   - Create test suite
   - Write documentation

4. Integration testing
   - Test module interactions
   - Verify sudo handling
   - Check network impacts
   - Validate configuration

5. Documentation updates
   - Update main README
   - Create usage examples
   - Document configuration
   - Add troubleshooting guide

## Future Enhancements

1. Hostname Templates
   - Support for hostname patterns
   - Environment-based naming
   - Role-based naming
   - Team conventions

2. Network Integration
   - DHCP integration
   - DNS update support
   - Active Directory support
   - Zero-conf improvements

3. Monitoring
   - Hostname change logging
   - Network impact tracking
   - Performance metrics
   - Status reporting

4. Advanced Features
   - Hostname rotation
   - Environment-based switching
   - Cluster naming support
   - Cloud provider integration

## Implementation Checklist

- [ ] Complete sudo module
- [ ] Update spotlight module
- [ ] Create hostname.sh
- [ ] Add configuration schema
- [ ] Implement core functions
- [ ] Create test suite
- [ ] Write documentation
- [ ] Perform integration testing
- [ ] Update existing modules
- [ ] Final security review

## Technical Debt Considerations

1. Module Dependencies
   - Track sudo module versioning
   - Monitor spotlight compatibility
   - Document API changes
   - Maintain backwards compatibility

2. Configuration Management
   - Version configuration schema
   - Handle upgrades gracefully
   - Maintain defaults
   - Document changes

3. Testing Infrastructure
   - Maintain test coverage
   - Update integration tests
   - Document test cases
   - Track performance metrics

4. Documentation Maintenance
   - Keep examples current
   - Update troubleshooting guides
   - Maintain API documentation
   - Track configuration changes
