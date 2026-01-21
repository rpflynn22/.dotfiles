#!/bin/bash
# Dotfiles setup script
# Run this after cloning the repo to create symlinks

set -e

DOTFILES_DIR="$HOME/.dotfiles"

echo "Setting up dotfiles from $DOTFILES_DIR"

errors=0

# Create symlink only if destination doesn't exist
link_file() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        # Resolve both paths to compare actual targets
        local current_real=$(cd "$(dirname "$dest")" && realpath "$(readlink "$dest")" 2>/dev/null || echo "")
        local expected_real=$(realpath "$src" 2>/dev/null || echo "$src")
        if [ "$current_real" = "$expected_real" ]; then
            echo "  OK: $dest (already linked)"
        else
            echo "  CONFLICT: $dest is a symlink to $current_real"
            echo "            Expected: $expected_real"
            errors=$((errors + 1))
        fi
    elif [ -e "$dest" ]; then
        echo "  CONFLICT: $dest exists (not a symlink)"
        echo "            Remove it manually, then re-run this script"
        errors=$((errors + 1))
    else
        echo "  Linking: $dest -> $src"
        ln -s "$src" "$dest"
    fi
}

# Root-level dotfiles
echo ""
echo "Root dotfiles:"
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Claude configuration
echo ""
echo "Claude configuration:"
mkdir -p "$HOME/.claude"

for file in "$DOTFILES_DIR/claude/"*; do
    filename=$(basename "$file")
    link_file "$file" "$HOME/.claude/$filename"
done

# Neovim configuration
echo ""
echo "Neovim configuration:"
mkdir -p "$HOME/.config"
link_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

echo ""
if [ $errors -gt 0 ]; then
    echo "Completed with $errors conflict(s). Resolve manually and re-run."
    exit 1
else
    echo "Done!"
    echo ""
    echo "Remember to create local config files for machine-specific settings:"
    echo ""
    echo "  ~/.claude/settings.local.json:"
    echo "    - env (AWS_PROFILE, etc.)"
    echo "    - awsAuthRefresh"
    echo "    - statusLine"
    echo ""
    echo "  ~/.zshrc.local:"
    echo "    - Work directory shortcuts (cdapt, etc.)"
    echo "    - K8s context aliases (k8smk, k8sfd, etc.)"
fi
