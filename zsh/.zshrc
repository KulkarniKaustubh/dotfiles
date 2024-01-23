# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install

# sugon
# if command -v "figlet" &> /dev/null &&
#    command -v "lolcat" &> /dev/null;
# then
#     figlet -f Speed "SugoN" | lolcat
# fi
# end sugon

# Fixing zsh history problems on multiple terminals
setopt inc_append_history
setopt share_history

# Ignore duplicate commands in history file
setopt histignorealldups

# Fixing some keys inside zsh
autoload -Uz select-word-style
select-word-style bash

# Add highlight enabled tab completion with colors
zstyle ':completion:*' menu select
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Get bash's compgen
autoload -Uz compinit
compinit
autoload -Uz bashcompinit
bashcompinit

# Sourcing the different plugins I have in zsh
source $HOME/.plugins.zsh

# source fuzzy find
# instructions to install fzf are found on github
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
# end

# ROS setup file
# source /opt/ros/noetic/setup.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

# add binaries to $PATH
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/lib/cuda/bin
export PATH=$PATH:/usr/local/cuda/bin:/opt/cuda/bin
export PATH=$PATH:$HOME/.local/bin
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

# custom ZSH keybinds
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# if command -v "emacs" &> /dev/null; then bindkey -s "^[e" "emacsclient -c . &; disown %1; ^M"; fi
if command -v "nvim" &> /dev/null; then bindkey -s "^[e" "nvim "; fi
if command -v "neovide" &> /dev/null; then bindkey -s "^[E" "devour neovide . --nofork; "; fi
if command -v "nautilus" &> /dev/null; then bindkey -s "^[n" "nautilus . &!; exit; "; fi
# end

# loop through and source all aliases files
for aliases_file in $(\ls -a $HOME | \grep -E "\.aliases.*\.zsh"); do
    source $HOME/$aliases_file
done

# set editor
export EDITOR="/usr/bin/nvim"
