# Repository Rename Guide

This document provides instructions for both administrators performing repository renames and users updating their local repositories.

## For Administrators

### Prerequisites

- GitHub CLI (`gh`) installed
- Admin access to the repository
- Local clone of the repository

### Renaming Process

1. Create and test changes in a feature branch:

   ```bash
   # Create branch
   git checkout -b refactor/rename-repo

   # Make necessary changes
   # Test changes via CI
   ```

2. Merge to main:

   ```bash
   # Switch to main
   git checkout main

   # Merge changes
   git merge refactor/rename-repo

   # Push to GitHub
   git push origin main
   ```

3. Rename repository using GitHub CLI:

   ```bash
   # Rename repository
   gh repo rename new-name

   # Verify remote URLs updated
   git remote -v
   ```

4. Create release:

   ```bash
   # Create and push tag
   git tag -a v2.0.0 -m "Repository renamed"
   git push origin v2.0.0

   # Create GitHub release
   gh release create v2.0.0 \
     --title "v2.0.0 - Repository Renamed" \
     --notes "BREAKING CHANGE: Repository renamed. See documentation for details."
   ```

## For Users

When a repository is renamed, you need to update your local repository to point to the new URL.

### Automatic Update

If you have a recent version of Git, it should automatically update when pulling:

```bash
git pull
```

### Manual Update

If the automatic update doesn't work:

1. Check current remotes:

   ```bash
   git remote -v
   ```

2. Update origin URL:

   ```bash
   git remote set-url origin https://github.com/username/new-name.git
   ```

3. Verify update:

   ```bash
   git remote -v
   git fetch
   ```

## GitHub CLI Commands Used

The GitHub CLI provides efficient commands for repository management:

```bash
# Rename repository
gh repo rename new-name

# Create release
gh release create <tag> --title "title" --notes "notes"

# List releases
gh release list

# View release
gh release view <tag>
```

## Notes

- Repository renames affect all clones and forks
- GitHub automatically redirects from old URLs
- Users should update their remotes for best practice
- Consider updating any documentation references
- Update any CI/CD configurations that reference the repository
