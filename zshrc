# History
HISTSIZE=1000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY

# Colors
alias ls='ls -a --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export LS_COLORS='di=38;5;183:ln=38;5;153:so=38;5;180:pi=38;5;180:ex=38;5;218:bd=38;5;181:cd=38;5;181:su=38;5;217:sg=38;5;217:tw=38;5;250:ow=38;5;250'

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vi=nvim
alias vim=nvim

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
export PATH="/usr/games:$PATH"

# Named directories
hash -d win=/mnt/c/Users/dumbh

# Editor
export EDITOR=nvim

# Plugins
DOTFILES="$HOME/dotfiles"
source "$DOTFILES/vendor/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$DOTFILES/vendor/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Keybindings
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey -e

# Starship
eval "$(starship init zsh)"
