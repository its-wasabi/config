(( EUID != 0 && SHLVL < 3 )) && { uwufetch; echo }

export MANPAGER='nvim +Man!'

[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"

unsetopt BEEP

setopt AUTO_CD
setopt EXTENDED_GLOB
setopt NO_FLOW_CONTROL 
setopt PROMPT_SUBST

HISTFILE="$HOME/.config/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt SHARE_HISTORY

zmodload zsh/datetime

zstyle :compinstall filename "$HOME/.config/zsh/.zshrc"
autoload -Uz compinit && compinit

zstyle ':completion:*'              menu yes 
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
alias rd=radare2
alias co=cargo

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

udate() {
  trap 'echo; return' INT
  while true; do
    printf '\r%s' "$(date)"
    sleep 1
  done
}

command_not_found_handler() {
  printf '\e[1;31m❰COMMAND NOT FOUND: \e[38;5;4m%s\e[1;31m❱\e[0m\n' "$1"
  return 127
}

bindkey -v
KEYTIMEOUT=1

bindkey '^?'    backward-delete-char
bindkey '^H'    backward-delete-char
bindkey '^[[3~' delete-char
bindkey -r '^[x'
bindkey -r '^X'

zle-line-init() {
  zle -K viins
  PROMPT_VIMODE=""
  zle reset-prompt
}
zle -N zle-line-init

zle-keymap-select() {
  case $KEYMAP in
    vicmd)      PROMPT_VIMODE="%F{yellow}❮N❯%f" ;;
    viins|main) PROMPT_VIMODE="" ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select

zle-line-finish() { zle -K viins }
zle -N zle-line-finish

# theme colors / config
_PC_BG="#181818"
_PC_MARKER="#444444"
_PC_TIME="cyan"
_PC_SHLVL="blue"
_PC_SSH="#00FF00"
_PC_GIT="#FD0D08"
_PC_CARGO="#ED4316"
_PC_ACC="magenta"
_SEP="]["
# each function prints its piece or nothing; consumed via $(...) in PROMPT

_p_root() {
  (( EUID == 0 )) && echo -n "%{%F{red}%}❰ROOT❱%{%f%} "
}

_p_status() {
  if (( EXIT_CODE == 0 )); then
    echo -n "%{%F{green}%}OK%{%f%}"
  elif (( EXIT_CODE > 128 )); then
    echo -n "%{%F{red}%}SIG-$(( EXIT_CODE - 128 ))%{%f%}"
  else
    echo -n "%{%F{red}%}${EXIT_CODE}%{%f%}"
  fi
  (( CMD_TIME > 0.5 )) && \
    echo -n "%{%F{${_PC_ACC}}%}~%{%F{${_PC_TIME}}%}${CMD_TIME}s%{%f%}"
}

_p_shlvl() {
  (( SHLVL > 1 )) && \
    echo -n "%{%F{${_PC_ACC}}%}${_SEP}%{%F{${_PC_SHLVL}}%}${SHLVL}%{%f%}"
}

_p_ssh() {
  [[ -n $SSH_CONNECTION ]] && \
    echo -n "%{%F{${_PC_ACC}}%}${_SEP}%{%F{${_PC_SSH}}%}SSH%{%f%}"
}

_p_git() {
  local ref dirty
  ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
     || git rev-parse --abbrev-ref HEAD 2>/dev/null \
     || git describe --tags --dirty --always 2>/dev/null) || return
  [[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="*"
  echo -n "%{%F{${_PC_ACC}}%}${_SEP}%{%F{${_PC_GIT}}%}${ref}${dirty}%{%f%}"
}

_p_cargo() {
  # cache per-directory to avoid running cargo on every prompt redraw
  [[ $PWD == $_CARGO_LAST_PWD ]] && { echo -n "$_CARGO_INFO"; return }

  local toml name version key value in_package=0 info=""

  toml=$(cargo locate-project --message-format=plain 2>/dev/null) || {
    _CARGO_LAST_PWD=$PWD
    _CARGO_INFO=""
    return
  }

  # parse only the [package] section so we don't grab name/version from
  # [[bin]], [dependencies], etc.
  while IFS='=' read -r key value; do
    key="${${key##[[:space:]]#}%%[[:space:]]#}"
    value="${${${value//\"/}##[[:space:]]#}%%[[:space:]]#}"
    [[ $key == '[package]' ]] && { in_package=1; continue }
    [[ $key == '['*']'    ]] && in_package=0
    (( in_package )) || continue
    case $key in
      name)    name=$value    ;;
      version) version=$value ;;
    esac
    [[ -n $name && -n $version ]] && break
  done < "$toml"

  [[ -z $name ]] && name="${toml:h:t}"
  info="%{%F{${_PC_ACC}}%}${_SEP}%{%F{${_PC_CARGO}}%}${name}"
  [[ -n $version ]] && info+="-${version}"
  info+="%{%f%}"

  _CARGO_LAST_PWD=$PWD
  _CARGO_INFO=$info
  echo -n "$info"
}

_p_head() {
	echo -n "%{%B%F{${_PC_MARKER}}%}%{%K{${_PC_MARKER}}%K{${_PC_BG}}%}%{%F{${_PC_ACC}}%}%{%F{${_PC_MARKER}}%}"
}

# shared PS2 (same across all profiles)
_PS2="%k%f%B%F{${_PC_MARKER}}█%K{${_PC_BG}}%F{blue} "

# ── profiles ─────────────────────────────────────────────────────────────────

_prompt_main() {
  PROMPT="%k%f%B$(_p_head) - $(_p_root)%F{${_PC_ACC}}❰$(_p_status)$(_p_shlvl)$(_p_ssh)$(_p_git)$(_p_cargo)%F{${_PC_ACC}}❱%F{${_PC_MARKER}} %F{${_PC_ACC}}❰%~❱%F{blue} "
  RPROMPT="%F{${_PC_ACC}}%f"
  PS2=$_PS2
}

_prompt_full() {
  PROMPT="%k%f%B$(_p_head) - $(_p_root)%F{${_PC_ACC}}❰%~❱%F{blue} "
  RPROMPT="%F{${_PC_ACC}}❰$(_p_status)$(_p_shlvl)$(_p_ssh)$(_p_git)$(_p_cargo)%F{${_PC_ACC}}❱"
  PS2=$_PS2
}

_prompt_min() {
  PROMPT="%f%B%F{${_PC_ACC}}<%F{blue}%n%F{${_PC_ACC}}@%F{blue}%m%F{${_PC_ACC}}><%F{blue}%~%F{${_PC_ACC}}>%F{blue} "
  RPROMPT=""
  PS2=$_PS2
}

typeset -ga _PROMPT_PROFILES=(main min full)
typeset -gi _PROMPT_IDX=1
typeset -g  PROMPT_PROFILE=${_PROMPT_PROFILES[1]}

_prompt_apply() {
  case $PROMPT_PROFILE in
    main) _prompt_main ;;
    full) _prompt_full ;;
    min)  _prompt_min  ;;
  esac
}

prompt_switch() {
  (( _PROMPT_IDX = _PROMPT_IDX % $#_PROMPT_PROFILES + 1 ))
  PROMPT_PROFILE=${_PROMPT_PROFILES[$_PROMPT_IDX]}
  _prompt_apply
  zle reset-prompt
}
zle -N prompt_switch
bindkey '^@' prompt_switch

typeset -g CMD_TIME=0
typeset -g CMD_START=""

preexec() {
  print -n '\e[0m'

  CMD_START=$EPOCHREALTIME
}

precmd() {
  EXIT_CODE=$?
  if [[ -n $CMD_START ]]; then
    CMD_TIME=$(printf '%.3f' $(( EPOCHREALTIME - CMD_START )))
  else
    CMD_TIME=0
  fi
  CMD_START=""
  _prompt_apply
}
