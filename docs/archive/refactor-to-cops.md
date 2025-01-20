# Refactoring from Dotfiles to Cops

This document tracks the refactoring process from "dotfiles" to "cops" naming convention.

## Phase 1: Repository Changes (Completed ✓)

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

### CI Verification (Completed ✓)

1. Updated workflow name in `.github/workflows/ci.yml` to "macOS Cops Test"
2. Triggered workflow manually using GitHub CLI:

   ```bash
   # Trigger the workflow
   gh workflow run "macOS Cops Test" --ref refactor/dotfiles-to-cops

   # Monitor workflow status
   gh run list --workflow=ci.yml

   # View detailed results
   gh run view [RUN_ID]
   ```

3. CI Results:
   - Both test runs completed successfully
   - Verified renaming changes work correctly
   - Confirmed script idempotency (multiple runs succeed)
   - All core functionality remains intact

### Next Steps

1. Merge to Main:

   ```bash
   # Switch to main branch
   git checkout main

   # Merge the refactor branch
   git merge refactor/dotfiles-to-cops

   # Push changes
   git push origin main
   ```

2. Update Repository Name:
   - Go to GitHub repository settings
   - Change repository name from `dotfiles-macos` to `cops`
   - Update local repository remote:

   ```bash
   git remote set-url origin https://github.com/shaneholloman/cops.git
   ```

3. Update Documentation:
   - Review all markdown files for any remaining "dotfiles" references
   - Update project description in GitHub
   - Update any external documentation or links

4. Create Release:

   ```bash
   # Create and push tag
   git tag -a v2.0.0 -m "Rename project from dotfiles to cops"
   git push origin v2.0.0

   # Create GitHub release using CLI
   gh release create v2.0.0 \
     --title "v2.0.0 - Project Renamed to cops" \
     --notes "BREAKING CHANGE: Project renamed from dotfiles to cops. See dev/refactor-to-cops.md for details."
   ```

### GitHub CLI Commands Used

During this refactoring, we utilized several GitHub CLI commands that proved very useful:

```bash
# Workflow Management
gh workflow run - Trigger a workflow
gh run list    - List recent workflow runs
gh run view    - View detailed workflow results

# Example with filters
gh run list --workflow=ci.yml --limit 3  # Show last 3 runs of specific workflow

# Detailed run information
gh run view [RUN_ID] --log              # View complete run logs
gh run view [RUN_ID] --job [JOB_ID]     # View specific job details
```

These commands provided efficient workflow management and monitoring directly from the terminal.

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
   git clone -b refactor/dotfiles-to-cops https://github.com/shaneholloman/cops.git ~/.config/cops
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
