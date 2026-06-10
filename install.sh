#!usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"

ln -sf "$DOTFILES/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/zshrc" "$home/.zshrc"
ln -sf "$DOTFILES/gitconfig" "$HOME/.gitconfig"

mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES/config/nvim" "$HOME/.config/nvim"

