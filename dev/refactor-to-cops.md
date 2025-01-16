# Refactoring from Dotfiles to Cops

This document tracks the refactoring process from "dotfiles" to "cops" naming convention.

## Phase 1: Repository Changes (Completed)

### Initial Analysis

1. Reviewed project structure and identified files needing changes
2. Analyzed case sensitivity requirements:
   - lowercase: general usage and paths
   - uppercase: environment variables
   - title case: documentation headers

### Code Changes

1. Created new branch: `refactor/dotfiles-to-cops`
2. Performed case-sensitive replacements:
   - "dotfiles" → "cops"
   - "DOTFILES" → "COPS"
   - "Dotfiles" → "Cops"
3. Renamed files:
   - `dotfiles-setup.sh` → `cops-setup.sh`
   - `dotfiles-restore.sh` → `cops-restore.sh`
4. Updated documentation and configuration files
5. Committed changes with breaking change notice
6. Pushed to GitHub for CI testing

### CI Verification (In Progress)

1. Updated workflow name in `.github/workflows/ci.yml` to "macOS Cops Test"
2. Triggered workflow manually using:

   ```bash
   gh workflow run "macOS Cops Test" --ref refactor/dotfiles-to-cops
   ```

3. Monitoring CI results to ensure changes work correctly

## Phase 2: Local Migration Plan (Pending)

### Current System State

```bash
# Existing symlinks
.aliases -> /Users/shaneholloman/.dotfiles/config/zsh/.aliases
.gitconfig -> /Users/shaneholloman/.dotfiles/config/git/.gitconfig
.vimrc -> /Users/shaneholloman/.dotfiles/config/vim/.vimrc
.zshrc -> /Users/shaneholloman/.dotfiles/config/zsh/.zshrc

# Existing backups
.gitconfig.backup -> /Users/shaneholloman/.dotfiles/config/git/.gitconfig
.vimrc.backup -> /Users/shaneholloman/.dotfiles/config/vim/.vimrc
.zshrc.backup -> /Users/shaneholloman/.dotfiles/config/zsh/.zshrc
```

### Backup Phase (TODO)

1. Create timestamped backup directory:

   ```bash
   timestamp=$(date +%Y%m%d_%H%M%S)
   backup_dir="$HOME/.dotfiles_backup_$timestamp"
   mkdir -p "$backup_dir"
   ```

2. Backup all relevant files:

   ```bash
   # Copy current dotfiles directory
   cp -R "$HOME/.dotfiles" "$backup_dir/"

   # Backup symlinks and their targets
   for file in .zshrc .gitconfig .vimrc .aliases; do
     if [[ -L "$HOME/$file" ]]; then
       cp -P "$HOME/$file" "$backup_dir/"
     fi
   done
   ```

### Migration Phase (TODO)

1. Clone new repository:

   ```bash
   git clone -b refactor/dotfiles-to-cops https://github.com/shaneholloman/cops-macos.git ~/.config/cops
   ```

2. Update symlinks:

   ```bash
   # Remove old symlinks
   rm "$HOME/.zshrc" "$HOME/.gitconfig" "$HOME/.vimrc" "$HOME/.aliases"

   # Create new symlinks
   ln -s "$HOME/.config/cops/config/zsh/.zshrc" "$HOME/.zshrc"
   ln -s "$HOME/.config/cops/config/git/.gitconfig" "$HOME/.gitconfig"
   ln -s "$HOME/.config/cops/config/vim/.vimrc" "$HOME/.vimrc"
   ln -s "$HOME/.config/cops/config/zsh/.aliases" "$HOME/.aliases"
   ```

### Verification Phase (TODO)

1. Verify symlinks point to correct locations:

   ```bash
   ls -la ~/.zshrc ~/.gitconfig ~/.vimrc ~/.aliases
   ```

2. Test configuration loading:

   ```bash
   # Source zsh configuration
   source ~/.zshrc

   # Verify git configuration
   git config --list
   ```

3. Run cops setup script:

   ```bash
   cd ~/.config/cops
   ./cops-setup.sh
   ```

### Rollback Plan (If Needed)

1. Restore from backup:

   ```bash
   # Remove new symlinks
   rm ~/.zshrc ~/.gitconfig ~/.vimrc ~/.aliases

   # Restore old symlinks from backup
   cp -P "$backup_dir"/.* ~/

   # Restore old dotfiles directory
   rm -rf ~/.dotfiles
   cp -R "$backup_dir/.dotfiles" ~/.dotfiles
   ```

## Next Steps

1. Wait for CI workflow completion
2. Review any CI failures and make necessary adjustments
3. Once CI passes, proceed with local migration
4. Update repository name on GitHub
5. Update all documentation references

## Notes

- All changes maintain existing functionality
- Only naming conventions and paths are being updated
- Backup strategy ensures safe rollback if needed
- CI verification ensures changes work in clean environment
