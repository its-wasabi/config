unsetopt BEEP

setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_FLOW_CONTROL 

HISTFILE="$HOME/.config/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

zstyle :compinstall filename "$HOME/.config/zsh/.zshrc"
autoload -Uz compinit && compinit

zstyle ':completion:*'              menu select=2 
zstyle ":completion:*"				group-name ''
zstyle ':completion:*'				list-colors 'di=34:ln=36:ex=32:fi=34'
zstyle ':completion:*'              special-dirs true
zstyle ':completion:*:descriptions' format ''
zstyle ':completion:*:warnings'     format '%k%F{red}❰no matches❱%f%k'

zle_highlight+=(
  default:fg=blue
  normal:fg=blue
)

# dotfiles bare repo
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# filesystem
alias ls='eza -aF --icons --color=always --group-directories-first --long --time-style=long-iso'
alias l=ls
alias mk=mkdir
alias rmd='rm -d'
alias rmr='rm -r'
alias rmfr='rm -rf'
alias c=clear

# editors / tools
alias v=nvim
alias vim=nvim

alias co=cargo
alias coc='cargo check'
alias cob='cargo build'
alias cor='cargo run'

# launch / exit
alias h=hyprland
alias e=exit
alias q=exit
alias ':e'=exit
alias ':q'=exit

# git
alias gs='git status -s'
alias ga='git add'
alias gd='git diff'
alias gcm='git commit -m'
alias gps='git push'

# network
alias a='ip -c a'
alias myip='curl -s ifconfig.me; echo'

# misc
alias idk='echo "me too bro me too (T^T)"'
alias snote='hyprctl notify -1 999999999 "rgb(ffffff)"'

steam() {
	echo "RUN STEAM"

    local w h res
    
    # 1. Query Niri 
    if command -v niri >/dev/null 2>&1; then
        res=$(niri msg outputs | awk '/Logical size:/ {print $3; exit}')
        w=${res%x*}
        h=${res#*x}
    fi

    # 2. XWayland Fallback
    if [[ -z "$w" || -z "$h" ]] && command -v xrandr >/dev/null 2>&1; then
        res=$(xrandr --current | awk '/\*/ {print $1; exit}')
        w=${res%x*}
        h=${res#*x}
    fi

    # 3. Failsafe Defaults 
    w=${w:-2560}
    h=${h:-1440}

    echo "Starting Steam in Gamescope (${w}x${h})..."

    env XDG_CURRENT_DESKTOP=X-Generic gamescope -e -w "$w" -h "$h" -- /usr/bin/steam "$@" >/dev/null 2>&1 &!
}

command_not_found_handler() {
  printf '\e[1;31m❰COMMAND NOT FOUND: \e[38;5;4m%s\e[1;31m❱\e[0m\n' "$1"
  return 127
}

bindkey -v
KEYTIMEOUT=1

_zle_git_add() {
  LBUFFER+="git add "
}
zle -N _zle_git_add

_zle_git_commit() {
  LBUFFER+='git commit -m "'
  RBUFFER='"'$RBUFFER   # cursor lands between the quotes
}
zle -N _zle_git_commit

bindkey -M viins '^x^a' _zle_git_add       
bindkey -M viins '^x^m' _zle_git_commit  

(( EUID != 0 && SHLVL < 3 )) && { 
	echo;
	clear;
	uwufetch;
}

eval "$(starship init zsh)"
