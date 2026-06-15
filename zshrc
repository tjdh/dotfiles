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
alias lsd='ls -d */'
alias vi=nvim
alias vim=nvim

# Git shortcuts
alias g='git'
alias gc='git checkout'
alias gcn='git checkout -b'
alias gsu='git submodule update'

gcm() {
  local b
  if b=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null); then
    git checkout "${b#origin/}"
  elif git show-ref --verify --quiet refs/heads/main; then
    git checkout main
  else
    git checkout master
  fi
}

# Jupytext
alias ipy2py='jupytext --to py:percent'

py2ipy() {
  local args=() paths=()
  for a in "$@"; do
    if [[ "$a" == -* ]]; then args+=("$a"); else paths+=("$a"); fi
  done
  jupytext --to ipynb "${args[@]}" "${paths[@]}" || return $?
  for src in "${paths[@]}"; do
    local nb="${src%.py}.ipynb"
    [[ -f "$nb" ]] || continue
    python3 - "$nb" <<'PY'
import json, re, sys
path = sys.argv[1]
with open(path) as f:
    nb = json.load(f)
all_src = '\n'.join(
    ''.join(c.get('source', '')) for c in nb['cells']
    if c.get('cell_type') == 'code'
)
if '%matplotlib widget' in all_src:
    sys.exit(0)
mpl_re = re.compile(r'(?m)^[ \t]*(?:import\s+matplotlib|from\s+matplotlib)\b.*$')
inserted = False
for c in nb['cells']:
    if c.get('cell_type') != 'code':
        continue
    src = ''.join(c.get('source', []))
    matches = list(mpl_re.finditer(src))
    if not matches:
        continue
    end = matches[-1].end()
    c['source'] = src[:end] + '\n%matplotlib widget' + src[end:]
    inserted = True
    break
if not inserted:
    sys.exit(0)
with open(path, 'w') as f:
    json.dump(nb, f, indent=1)
PY
  done
}

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
export PATH="/usr/games:$PATH"

# Named directories
hash -d win=/mnt/c/Users/dumbh

# Date shorthand
td=$(date +%Y%m%d)

# Editor
export EDITOR=nvim

# WSL2: strip Windows /mnt paths from PATH so zsh-syntax-highlighting stops
# stat-ing 30+ slow 9P filesystem dirs on every keypress. Windows tools that
# matter get explicit aliases below; everything else use the full /mnt/c/... path.
export PATH=$(echo "$PATH" | tr ':' '\n' | grep -v '^/mnt/' | tr '\n' ':' | sed 's/:$//')

# Plugins
DOTFILES="$HOME/dotfiles"

# Autosuggestions: skip on long lines; avoid per-keypress widget rebind cost
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
source "$DOTFILES/vendor/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting: skip on very long lines to prevent paste lag
ZSH_HIGHLIGHT_MAXLENGTH=512
source "$DOTFILES/vendor/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Keybindings
bindkey -e
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Starship
command -v starship &>/dev/null && eval "$(starship init zsh)"
