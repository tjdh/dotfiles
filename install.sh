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

# Compile tmux-256color terminfo with RGB (truecolor) support if missing
if ! TERMINFO=~/.terminfo infocmp -x tmux-256color 2>/dev/null | grep -q 'RGB'; then
  printf 'tmux-256color|tmux with 256 colors and truecolor,\n  RGB,\n  use=tmux-256color,\n' | tic -x -
fi

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

if grep -qi microsoft /proc/version 2>/dev/null && command -v powershell.exe >/dev/null 2>&1; then
  WIN_HOME="$(wslpath "$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("UserProfile")' | tr -d '\r')")"

  rm -rf "$WIN_HOME/.config/wezterm"
  mkdir -p "$WIN_HOME/.config/wezterm"
  cp "$DOTFILES/wezterm/wezterm.lua" "$WIN_HOME/.config/wezterm/wezterm.lua"
else
  link "$DOTFILES/wezterm" "$HOME/.config/wezterm"
fi
