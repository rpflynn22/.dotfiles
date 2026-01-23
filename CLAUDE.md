# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Note:** The file at `./claude/CLAUDE.md` is NOT for this repository. It contains global Claude Code settings that get symlinked to `~/.claude/CLAUDE.md`. This root CLAUDE.md is the one that applies when working in the dotfiles repo.

## CRITICAL: No Secrets

**NEVER commit API keys, tokens, passwords, or any secrets to this repository.**

This repo is public. Before committing ANY file, verify it contains no:
- API keys or tokens
- Passwords or credentials
- Private keys or certificates
- Environment variables with sensitive values

Use `*.local` or `*.local.json` files for sensitive config (these are gitignored).

## Repository Purpose

Manages dotfiles via symlinks. Files live in `~/.dotfiles/` and get symlinked to their expected locations.

## Setup

Run `./setup.sh` after cloning. It creates symlinks and reports conflicts (won't overwrite existing files).

```bash
git clone git@github.com:rpflynn22/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./setup.sh
```

## Managed Configurations

| Repository Path | Symlink Target |
|-----------------|----------------|
| `.gitconfig` | `~/.gitconfig` |
| `.tmux.conf` | `~/.tmux.conf` |
| `.zshrc` | `~/.zshrc` |
| `claude/*` | `~/.claude/*` |
| `claude/agents/` | `~/.claude/agents/` |
| `nvim/` | `~/.config/nvim` |

## Local-Only Files (Not Version Controlled)

These must be created manually on each machine:
- `~/.zshrc.local` - Work-specific aliases and k8s contexts
- `~/.claude/settings.local.json` - AWS auth, env vars, statusLine
- `~/.claude/statusline.sh` - Status line script

## Adding a New Dotfile

1. Move file to repo: `mv ~/.config-file ~/.dotfiles/.config-file`
2. Add to `setup.sh` with a `link_file` call
3. Run `./setup.sh` to create the symlink
4. Commit both the file and updated setup.sh
