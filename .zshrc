# --- 1. COMPLETION SYSTEM ---
# This initializes the advanced Tab-completion engine we installed earlier
autoload -Uz compinit
compinit

# --- 2. HISTORY SETUP ---
# Zsh needs to know where to save your typed commands so autosuggestions can learn
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory      # Add new commands to the file instead of overwriting it
setopt sharehistory       # Share history across multiple open terminal windows

# --- 3. THE GOODIES (PLUGINS) ---
# Sourcing tells Zsh to read and execute the plugin files we downloaded via pacman
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 4. TERMINAL PROMPT ---
# This hooks Starship into Zsh so you get your fast, beautiful prompt
eval "$(starship init zsh)"

# --- 5. CUSTOM ALIASES ---
# Your automated GitHub push command for the RiceWiki
# (Make sure this path points to the vault folder you created in Obsidian!)
alias sync-wiki="pushd ~/Documents/EverythingArtix > /dev/null && git add . && git commit -m \"Terminal Sync: \$(date +'%Y-%m-%d %H:%M')\" && git push && popd > /dev/null"
alias ls="ls --color=auto" # Ensures basic ls output is colorful
alias ff="fastfetch"

# Enable advanced wildcard matching (like ^ for NOT)
setopt extended_glob
