# Dotfiles Repository

This repository manages configuration files (dotfiles) using a symlink-based approach.

## CRITICAL: No Secrets

**NEVER commit API keys, tokens, passwords, or any secrets to this repository.**

This repo is public. Before committing ANY file, verify it contains no:
- API keys or tokens
- Passwords or credentials
- Private keys or certificates
- Environment variables with sensitive values

If a config file requires secrets, use environment variables or a separate
untracked file (add it to `.gitignore`).

## Structure

All dotfiles are stored in `~/.dotfiles/` and symlinked to their expected locations
in the home directory. This allows version control of configuration while keeping
files accessible where tools expect them.

## Current Symlinks

| Repository File | Symlink Location |
|-----------------|------------------|
| `.gitconfig`    | `~/.gitconfig`   |
| `.tmux.conf`    | `~/.tmux.conf`   |

## Adding a New Dotfile

1. Move the original file into this repository:
   ```bash
   mv ~/.some-config ~/.dotfiles/.some-config
   ```

2. Create a symlink from the home directory to the repo:
   ```bash
   ln -s ~/.dotfiles/.some-config ~/.some-config
   ```

3. Commit the new file:
   ```bash
   cd ~/.dotfiles && git add .some-config && git commit -m "Add some-config"
   ```

## Removing a Dotfile

1. Remove the symlink (not the file):
   ```bash
   rm ~/.some-config  # removes symlink only
   ```

2. Optionally remove from the repo or keep for reference.

## Setting Up on a New Machine

1. Clone the repository:
   ```bash
   git clone git@github.com:rpflynn22/.dotfiles.git ~/.dotfiles
   ```

2. Create symlinks for each file:
   ```bash
   ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
   ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
   ```

## Notes

- The `.orig` suffix indicates backup copies of configs not currently in use
- Always verify symlinks point to the correct location before committing changes
- Test configuration changes before pushing to avoid breaking other machines
