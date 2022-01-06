# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# fixing control + left/right in zsh
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# sourcing plugins, themes, etc.
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# end

# ROS setup file
# source /opt/ros/noetic/setup.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# add binaries to $PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/cuda/bin
export PATH=$PATH:/usr/local/cuda/bin:/home/kaustubh/.cargo/bin
export PATH=$PATH:/home/kaustubh/.local/bin
# end of $PATH exports

# pip zsh completion start
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] 2>/dev/null ))
}
compctl -K _pip_completion pip
# pip zsh completion end

# bash's command not found auto suggest
command_not_found_handler () {
    if [ -x /usr/lib/command-not-found ]
    then
        /usr/lib/command-not-found -- "$1"
        return $?
    else
        if [ -x /usr/share/command-not-found/command-not-found ]
        then
            /usr/share/command-not-found/command-not-found -- "$1"
            return $?
        else
            printf "%s: command not found\n" "$1" >&2
            return 127
        fi
    fi
}

# git aliases
alias gst="git status"
alias ga="git add"
alias gcm="git commit -m"
alias gl="git pull"
alias gp="git push"
alias gcl="git clone"
# end of git aliases

# getting Emacs tramp to work with zsh
if [[ "$TERM" == "dumb" ]]
then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
fi

# start of aliases
alias c='cd'

# alias ll='ls -l'
# alias la='ls -A'
# alias l='ls -CF'
# alias lla='ls -alF'

alias ls='exa'
alias ll='exa -l'
alias la='exa -a'
alias lla='exa -laF'
alias l="ls"
alias c..='cd ..'

alias cat="batcat"

alias p="python"
alias p3="python3"
alias cls="clear"

alias envmerger="source envmerger"

alias e="emacsclient -c"
# end of aliases
