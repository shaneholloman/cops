# Installation Guide

This guide explains the different ways to install and use cops.

## Standard Installation (Most Users)

The standard installation is for users who want to manage their macOS configuration:

```sh
# 1. Clone cops to your home directory
git clone https://github.com/shaneholloman/cops.git ~/.cops

# 2. Review and customize settings
cd ~/.cops
vim config.yaml

# 3. Run the setup
./cops-setup.sh
```

After installation:

- Your configuration lives in ~/.cops
- A fresh git repository is initialized
- You can track your changes
- Push to your own remote repository

### Managing Your Configuration

```sh
# Track your changes
cd ~/.cops
git add .
git commit -m "Updated my configuration"

# Optional: Backup to your own repository
git remote add origin <your-repo-url>
git push -u origin main
```

## Development Installation

For testing changes or contributing to cops:

```sh
# Clone to a development location
git clone https://github.com/shaneholloman/cops.git ~/projects/cops
cd ~/projects/cops

# Make and test changes
vim config.yaml
./cops-setup.sh  # Updates ~/.cops
```

### Key Points About Development Installation

1. Running Location:
   - Can run cops-setup.sh from any directory
   - Will always update ~/.cops
   - Maintains consistency across locations

2. Testing Changes:
   - Make changes in development location
   - Run to update ~/.cops
   - Safe to experiment

3. Contributing:
   - Fork the repository
   - Clone your fork to development location
   - Never clone development copy to ~/.cops
   - Submit pull requests from development copy

## Understanding Both Locations

1. Installation Location (~/.cops):
   - Your active configuration
   - Fresh git repo for your changes
   - Where cops actually runs from
   - Contains your personal settings

2. Development Location (if used):
   - For testing changes
   - For contributing to framework
   - Updates ~/.cops when run
   - Keeps development separate from config

## Common Operations

### Updating Your Configuration

```sh
cd ~/.cops
vim config.yaml  # Make changes
./cops-setup.sh  # Apply changes
git add .
git commit -m "Updated configuration"
```

### Testing Changes (Development)

```sh
cd ~/projects/cops  # Your development location
vim config.yaml    # Make changes
./cops-setup.sh    # Test changes (updates ~/.cops)
```

### Resetting to Default

```sh
cd ~/.cops
git reset --hard   # Reset any uncommitted changes
./cops-setup.sh    # Reapply configuration
```

## Next Steps

- Review [Core Concepts](dev/architecture/core-concepts.md)
- Check [Development Guide](dev/development.md) if contributing
- Explore available [Master Switches](dev/master-switches.md)
