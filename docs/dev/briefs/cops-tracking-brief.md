# COPS Tracking System Brief

## Overview

This brief outlines the design and implementation plan for a SQLite-based tracking system for COPS backups. The system will provide detailed insights into backup history, file changes, and restore points.

## Implementation Details

### Database Location

```sh
~/.cops/db/backups.db
```

### Schema Design

#### Backup Sets Table

```sql
CREATE TABLE backup_sets (
    timestamp TEXT PRIMARY KEY,  -- YYYYMMDD_HHMMSS format
    type TEXT NOT NULL,         -- 'scheduled', 'manual', 'pre-change'
    trigger_source TEXT,        -- what initiated the backup
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

#### Backup Files Table

```sql
CREATE TABLE backup_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    backup_timestamp TEXT,      -- links to backup_sets
    file_type TEXT NOT NULL,    -- 'preferences', 'shell', 'git', 'vim'
    original_path TEXT NOT NULL, -- original file path
    backup_path TEXT NOT NULL,   -- path in .cops/backups
    checksum TEXT,              -- file hash for integrity
    FOREIGN KEY (backup_timestamp) REFERENCES backup_sets(timestamp)
);
```

#### File Changes Table

```sql
CREATE TABLE file_changes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    backup_file_id INTEGER,
    change_type TEXT,          -- 'modified', 'added', 'removed'
    diff_summary TEXT,         -- brief description of changes
    FOREIGN KEY (backup_file_id) REFERENCES backup_files(id)
);
```

## Python Integration

### Dependencies

- Install isolated Python environment using `uv`:

```bash
uv pip install sqlite3
```

### Core Functions

```python
def init_db():
    """Initialize database and create tables if they don't exist"""

def record_backup(timestamp, type, trigger):
    """Record a new backup set"""

def add_backup_file(timestamp, file_type, original_path, backup_path):
    """Record a backed up file"""

def record_changes(backup_file_id, changes):
    """Record file changes"""

def get_backup_history(file_type=None):
    """Get backup history, optionally filtered by type"""

def get_file_changes(backup_timestamp):
    """Get all file changes for a backup set"""
```

## CLI Integration

### New Commands

```bash
cops-setup.sh --show-history [type]     # Show backup history
cops-setup.sh --show-changes [backup]   # Show changes in a backup
cops-setup.sh --verify-backup [backup]  # Verify backup integrity
```

### Example Output

```sh
=== Backup History ===
2025-01-22 14:15:04 (manual)
  • Modified: .zshrc
    - Added new aliases
  • Modified: com.apple.finder.plist
    - Changed view settings

2025-01-22 11:49:32 (pre-change)
  • Added: .gitconfig
  • Modified: com.apple.dock.plist
    - Updated dock position
```

## Future Enhancements

### Phase 1: Basic Tracking

- Implement core schema
- Basic backup recording
- Simple history viewing

### Phase 2: Advanced Features

- Backup integrity verification
- Change diffing and summaries
- Backup set relationships

### Phase 3: Analytics

- Backup frequency analysis
- Common change patterns
- Storage usage trends

## Integration Points

### With Existing Backup System

- Record backups as they occur
- Maintain file relationships
- Track restore operations

### With Restore System

- Verify backup integrity before restore
- Log restore operations
- Track success/failure rates

## Technical Considerations

### Performance

- Index frequently queried columns
- Regular database maintenance
- Efficient change tracking

### Storage

- Regular cleanup of old records
- Compression of change data
- Backup rotation policies

### Security

- Secure storage of sensitive data
- Access controls
- Data integrity checks

## Implementation Strategy

1. Database Setup
   - Create database structure
   - Implement initialization
   - Add migration support

2. Core Functionality
   - Implement basic tracking
   - Add file change recording
   - Create history queries

3. CLI Integration
   - Add history commands
   - Implement reporting
   - Create admin tools

4. Testing
   - Unit tests for core functions
   - Integration tests
   - Performance testing

## Next Steps

1. Set up isolated Python environment using `uv`
2. Create database initialization script
3. Implement core tracking functions
4. Integrate with existing backup system
5. Add CLI commands
6. Create comprehensive tests

This tracking system will provide valuable insights into backup operations while maintaining COPS' commitment to reliability and ease of use.
