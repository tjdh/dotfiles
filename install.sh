#!/usr/bin/env bash
# Clone: git clone git@gitlab:<user>/dotfiles.git ~/dotfiles && ~/dotfiles/install.sh

set -e

DOTFILES="$HOME/dotfiles"

link() {
    src="$1"
    dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        mv "$dst" "$dst.backup.$(date +%Y%m%d%H%M%S)"
    fi

    ln -sfn "$src" "$dst"
}

link "$DOTFILES/tmux.conf"           "$HOME/.tmux.conf"
link "$DOTFILES/zshrc"               "$HOME/.zshrc"
link "$DOTFILES/gitconfig"           "$HOME/.gitconfig"
link "$DOTFILES/config/nvim"         "$HOME/.config/nvim"
link "$DOTFILES/vendor/nvim/mason"   "$HOME/.local/share/nvim/mason"
link "$DOTFILES/config/starship.toml" "$HOME/.config/starship.toml"

# Claude Code
mkdir -p "$HOME/.claude/themes"
link "$DOTFILES/claude/settings.json"            "$HOME/.claude/settings.json"
link "$DOTFILES/claude/keybindings.json"         "$HOME/.claude/keybindings.json"
link "$DOTFILES/claude/statusline-command.py"    "$HOME/.claude/statusline-command.py"
link "$DOTFILES/claude/themes/softspectrum.json" "$HOME/.claude/themes/softspectrum.json"

if grep -qi microsoft /proc/version 2>/dev/null; then
    WIN_HOME="$(wslpath "$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("UserProfile")' | tr -d '\r')")"

    rm -rf "$WIN_HOME/.config/wezterm"
    mkdir -p "$WIN_HOME/.config/wezterm"
    cp "$DOTFILES/wezterm/wezterm.lua" "$WIN_HOME/.config/wezterm/wezterm.lua"
else
    link "$DOTFILES/wezterm" "$HOME/.config/wezterm"
fi
