# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# Fixing zsh history problems on multiple terminals
setopt inc_append_history
setopt share_history

# Ignore duplicate commands in history file
setopt histignorealldups

# Fixing control + left/right in zsh
autoload -Uz select-word-style
select-word-style bash

bindkey ";5C" forward-word
bindkey ";5D" backward-word

# Add highlight enabled tab completion with colors
zstyle ':completion:*' menu select
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Get bash's compgen
autoload -Uz compinit
compinit
autoload -Uz bashcompinit
bashcompinit

# Downloading and sourcing themes, plugins, etc.
# check if ~/.zsh exists
if [ ! -d "$HOME/.zsh" ]; then
    echo "Creating a .zsh folder in $HOME"
    echo "This can be copied elsewhere and then linked, preferrably using GNU stow"
    mkdir .zsh
fi

# check if p10k exists
if [ ! -d "$HOME/.zsh/powerlevel10k" ]; then
    echo "Installing powerelevel10k theme."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.zsh/powerlevel10k
fi

source $HOME/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# check if zsh autosuggest exists
if [ ! -d "$HOME/.zsh/zsh-autosuggestions" ]; then
    echo "Installing zsh autosuggestions."
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
fi

source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# check if zsh syntax highlighting exists
if [ ! -d "$HOME/.zsh/zsh-syntax-highlighting" ]; then
    echo "Installing zsh syntax highlighting."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
fi

source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# check if zsh history susbtring search
if [ ! -d "$HOME/.zsh/zsh-history-substring-search" ]; then
    echo "Installing zsh history substring search."
    git clone https://github.com/zsh-users/zsh-history-substring-search.git $HOME/.zsh/zsh-history-substring-search
fi

source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
# enabling up and down arrow keys to use the plugin
bindkey "^[OA" history-substring-search-up
bindkey "^[OB" history-substring-search-down

# end

# source fuzzy find
# instructions to install fzf are found on github
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
# end

# ROS setup file
# source /opt/ros/noetic/setup.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# add binaries to $PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/cuda/bin
export PATH=$PATH:/usr/local/cuda/bin
export PATH=$PATH:/home/kaustubh/.local/bin
# end of $PATH exports

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

# git aliases
alias gst="git status"
alias ga="git add"
alias gcm="git commit -m"
alias gl="git pull"
alias gp="git push"
alias gcl="git clone"
# end of git aliases

# docker aliases
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias drm="docker rm"
alias drmi="docker rmi"
alias dsi="docker start -i"
alias dpl="docker pull"
# end of docker aliases

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

alias srm="gio trash" # safe rm command

alias e="emacsclient -c"

alias erestart="emacsclient -e '(save-buffers-kill-emacs)'; emacs --daemon"
# end of aliases

# ZSH key binds
bindkey -s "^[e" "emacsclient -c . &; disown %1; ^M"
bindkey -s "^[n" "nautilus . &; disown %1; ^M"
# end

# check and source machine specific/private .zsh files
if compgen -G "$HOME/.dotfiles/zsh/.private_*.zsh" > /dev/null; then
    source $HOME/.private_*.zsh
fi
