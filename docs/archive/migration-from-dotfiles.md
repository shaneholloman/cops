# Migration from Dotfiles to Cops

This guide helps you transition from an existing dotfiles installation to cops.

## Prerequisites

Before starting:

- Backup your data
- Note any custom configurations you've made
- Have the new cops repository URL ready

## Step-by-Step Migration

### 1. Create Backup

```bash
# Create timestamped backup directory
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="$HOME/.dotfiles_backup_$timestamp"
mkdir -p "$backup_dir"

# Backup entire dotfiles directory
cp -R "$HOME/.dotfiles" "$backup_dir/"

# Backup existing symlinks
for file in .zshrc .gitconfig .vimrc .aliases; do
    if [[ -L "$HOME/$file" ]]; then
        cp -P "$HOME/$file" "$backup_dir/"
    fi
done

# Save list of all symlinks for reference
ls -la "$HOME" | grep " -> " > "$backup_dir/symlinks.txt"
```

### 2. Remove Old Installation

```bash
# Remove old symlinks
unlink "$HOME/.zshrc"
unlink "$HOME/.gitconfig"
unlink "$HOME/.vimrc"
unlink "$HOME/.aliases"

# Move old dotfiles directory to backup (if not already done)
mv "$HOME/.dotfiles" "$backup_dir/" 2>/dev/null || true
```

### 3. Install Cops

```bash
# Clone new repository
git clone https://github.com/shaneholloman/cops.git "$HOME/.config/cops"

# Run setup script
cd "$HOME/.config/cops"
./cops.sh
```

### 4. Verify Installation

```bash
# Check symlinks point to new locations
ls -la ~/.zshrc ~/.gitconfig ~/.vimrc ~/.aliases

# Verify cops environment
echo $COPS_ROOT
```

### 5. Restore Custom Configurations

If you had custom configurations:

1. Compare backup files with new ones:

   ```bash
   diff "$backup_dir/.dotfiles/config/zsh/.zshrc" "$HOME/.config/cops/config/zsh/.zshrc"
   ```

2. Copy custom configurations:

   ```bash
   # Example: Restoring custom aliases
   cp "$backup_dir/.dotfiles/config/zsh/.aliases" "$HOME/.config/cops/config/zsh/.aliases"
   ```

## Rollback Plan

If something goes wrong:

```bash
# Remove new installation
rm -rf "$HOME/.config/cops"
rm "$HOME/.zshrc" "$HOME/.gitconfig" "$HOME/.vimrc" "$HOME/.aliases"

# Restore from backup
cp -R "$backup_dir/.dotfiles" "$HOME/"
cp -P "$backup_dir"/.* "$HOME/"
```

## Verification Checklist

- [ ] All symlinks point to new cops locations
- [ ] Shell configuration loads without errors
- [ ] Git configuration is correct
- [ ] Custom aliases work
- [ ] Vim configuration loads properly
- [ ] All tools and applications work as before

## Common Issues

1. **Old symlinks persist**
   - Solution: Use `ls -la` to find and `unlink` them

2. **Shell startup errors**
   - Check `~/.zshrc` points to correct location
   - Verify `$COPS_ROOT` is set correctly

3. **Missing custom configurations**
   - Compare backup with new installation
   - Restore from backup directory

4. **Path issues**
   - Update any hardcoded paths from ~/.dotfiles to ~/.config/cops
   - Check environment variables in shell configuration

## Notes

- Keep backup directory until fully satisfied with migration
- Update any scripts that referenced old dotfiles paths
- Consider updating any documentation or notes you maintain
- Test all critical functionality before removing backup
