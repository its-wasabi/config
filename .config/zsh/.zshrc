if (( $EUID != 0 && $SHLVL < 3)); then
	uwufetch;
	echo;
fi

##########
# CONFIG #
##########

alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME';

###########
# HISTORY #
###########

HISTFILE="$HOME/.config/zsh/history"
HISTSIZE=1000
SAVEHIST=1000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY


###########
# GENERAL #
###########

unsetopt BEEP

zstyle :compinstall filename "$HOME/.config/zsh/.zshrc"

[[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"

autoload -Uz compinit
compinit

export MANPAGER='nvim +Man!'

export PATH="$PATH:$HOME/.local/bin"

#######
# MOD #
#######

zmodload zsh/datetime;

###########
# ALIASES #
###########

alias idk='echo "me too bro me too (T^T)"'

alias ls='eza -aF --icons --color=always --group-directories-first --long --time-style=long-iso'
alias l=ls
alias mk=mkdir
alias rmd='rm -d'
alias rmr='rm -r'
alias rmfr='rm -rf'
alias c=clear
alias h=hyprland
alias v=nvim
alias vim=nvim
alias rd=radare2
alias e=exit
alias q=exit
alias ':e'=exit
alias ':q'=exit

alias gs='git status -s'
alias ga='git add'
alias gd='git diff'
alias gcm='git commit -m'
alias gps='git push'

alias a='ip -c a'
alias myip='curl -s ifconfig.me;echo;'

alias co=cargo
alias snote='hyprctl notify -1 999999999 "rgb(ffffff)"'


#############
# FUNCTIONS #
#############

udate() {
	trap 'echo; return' INT;
	while true; do
		printf '\r%s' "$(date)";
		sleep 1;
	done
}

############
# VIM MODE #
############

bindkey -v
KEYTIMEOUT=1
stty -ixon

zle-line-init() {
	zle -K viins
	PROMPT_VIMODE=""
	zle reset-prompt
}
zle -N zle-line-init

zle-keymap-select() {
	case $KEYMAP in
		vicmd) PROMPT_VIMODE="%F{yellow}❮N❯%f" ;;
		viins|main) PROMPT_VIMODE="" ;;
	esac
	zle reset-prompt
}
zle -N zle-keymap-select

bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^[[3~' delete-char

bindkey -r '^[x'
bindkey -r '^X'

##########
# PROMPT #
##########

setopt PROMPT_SUBST
setopt EXTENDED_GLOB

BACKGROUND_COLOR="#181818"
MARKER_COLOR="#444444"
TIME_COLOR="cyan"
SHLVL_COLOR="blue"
SSH_COLOR="#00FF00"
GIT_COLOR="#FD0D08"
CARGO_COLOR="#ED4316"

SEPARATOR="]["
PROMPT_COLOR="magenta"

root_marker() {
  (( $EUID == 0 )) && echo -n "%{%F{red}%}❰ROOT❱%{%f%} "
}

command_status() {
	if (( EXIT_CODE == 0 )); then
		echo -n "%{%F{green}%}OK%{%f%}"
	elif (( EXIT_CODE > 128 )); then
		echo -n "%{%F{red}%}SIG-$(( EXIT_CODE - 128 ))%{%f%}"
	else
		echo -n "%{%F{red}%}$EXIT_CODE%{%f%}"
	fi
	(( CMD_TIME > 0.5 )) && \
		echo -n "%{%F{$PROMPT_COLOR}%}~%{%F{$TIME_COLOR}%}${CMD_TIME}s%{%f%}";
}

shell_level() {
	(( SHLVL > 1 )) && \
		echo "%{%F{$PROMPT_COLOR}%}${SEPARATOR}%{%F{$SHLVL_COLOR}%}$SHLVL%{%f%}";
}


ssh_info() {
	[[ -n $SSH_CONNECTION ]] && \
		echo "%{%F{$PROMPT_COLOR}%}${SEPARATOR}%{%F{$SSH_COLOR}%}SSH%{%f%}";
}

git_info() {
	local ref dirty;

	ref=$(git symbolic-ref --quiet --short HEAD 2>/dev/null \
	   || git rev-parse --abbrev-ref HEAD 2>/dev/null \
	   || git describe --tags --dirty --always 2>/dev/null) || return;

	[[ -n $(git status --porcelain 2>/dev/null) ]] && dirty="*"

	echo "%{%F{$PROMPT_COLOR}%}${SEPARATOR}%{%F{$GIT_COLOR}%}$ref$dirty%{%f%}";
}

cargo_info() {
	if [[ $PWD != $_CARGO_LAST_PWD ]]; then
		local cargo_toml name version key value info=""

		cargo_toml=$(cargo locate-project --message-format=plain 2>/dev/null)
		if [[ $? -eq 0 ]]; then
			while IFS='=' read -r key value; do
				key="${${key##[[:space:]]#}%%[[:space:]]#}"
				value="${${${value//\"/}##[[:space:]]#}%%[[:space:]]#}"
				case $key in
					name)    name=$value ;;
					version) version=$value ;;
				esac
			done < "$cargo_toml"

			# if no [package] name, use the directory name
			[[ -z $name ]] && name="${cargo_toml:h:t}"

			info="%{%F{$PROMPT_COLOR}%}${SEPARATOR}%{%F{$CARGO_COLOR}%}$name"
			[[ -n $version ]] && info+="-$version"
			info+="%{%f%}"
		fi

		_CARGO_LAST_PWD=$PWD
		_CARGO_INFO=$info
	fi

	echo -n "$_CARGO_INFO"
}


prompt_beginning() {
	echo -n "%{%B%F{$MARKER_COLOR}%}%{%K{$MARKER_COLOR}%F{$PROMPT_COLOR}%}%{%K{$BACKGROUND_COLOR}%F{$MARKER_COLOR}%}";
}

prompt_profile_main() {
	PROMPT="%k%f%B$(prompt_beginning) - $(root_marker)%F{$PROMPT_COLOR}❰$(command_status)$(shell_level)$(ssh_info)$(git_info)$(cargo_info)%F{$PROMPT_COLOR}❱%F{$MARKER_COLOR} %F{$PROMPT_COLOR}❰%~❱%F{blue} ";
	RPROMPT="%F{$PROMPT_COLOR}%f"
	PS2="%k%f%B%F{$MARKER_COLOR}█%K{$BACKGROUND_COLOR}%F{blue} "
}


prompt_profile_full() {
	PROMPT="%k%f%B$(prompt_beginning) - $(root_marker)%F{$PROMPT_COLOR}❰%~❱%F{blue} ";
	RPROMPT="%F{$PROMPT_COLOR}❰$(command_status)$(shell_level)$(ssh_info)$(git_info)$(cargo_info)%F{$PROMPT_COLOR}❱"
	PS2="%k%f%B%F{$MARKER_COLOR}█%K{$BACKGROUND_COLOR}%F{blue} "
}

prompt_profile_min() {
	PROMPT="%f%B%F{$PROMPT_COLOR}<%F{blue}%n%F{$PROMPT_COLOR}@%F{blue}%m%F{$PROMPT_COLOR}><%F{blue}%~%F{$PROMPT_COLOR}>%F{blue} "
	RPROMPT=""
	PS2="%k%f%B%F{$MARKER_COLOR}█%K{$BACKGROUND_COLOR}%F{blue} "
}

prompt_apply() {
	case $PROMPT_PROFILE in
		main) prompt_profile_main ;;
		full) prompt_profile_full ;;
		min) prompt_profile_min ;;
	esac
}

typeset -ga PROMPT_PROFILES=("main" "min" "full");
typeset -gi PROMPT_PROFILE_INDEX=1
typeset -g PROMPT_PROFILE=${PROMPT_PROFILES[1]}
prompt_switch() {
	(( PROMPT_PROFILE_INDEX++ ))

	if (( PROMPT_PROFILE_INDEX > $#PROMPT_PROFILES )); then
		PROMPT_PROFILE_INDEX=1
	fi

	PROMPT_PROFILE=${PROMPT_PROFILES[PROMPT_PROFILE_INDEX]}

	prompt_apply
	zle reset-prompt
}
zle -N prompt_switch
bindkey '^@' prompt_switch;

typeset CMD_TIME CMD_START CMD_END

preexec() {
	echo -ne '\e[0m'
	CMD_START=$EPOCHREALTIME
}

precmd() {
	EXIT_CODE=$?

	prompt_apply;

	CMD_END=${EPOCHREALTIME:-$(date +%s.%N)}
	if [[ -z $CMD_START ]]; then
		CMD_START=$CMD_END
		CMD_TIME=0
	else
		CMD_TIME=$(awk -v start="$CMD_START" -v end="$CMD_END" 'BEGIN{printf "%.3f", end-start}')
		CMD_START=$CMD_END
	fi
}

zle-line-finish() {
	zle -K viins
}
zle -N zle-line-finish

##########
# ERRORS #
##########

command_not_found_handler() {
	echo "\e[1;31m❰COMMAND NOT FOUND: \e[38;5;4m$1\e[1;31m❱\e[0m"
	return 127
}
