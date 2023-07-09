alias c='cd'
alias c..='cd ..'

if command -v "exa" &> /dev/null; then
    exa_cmd="exa --icons --group-directories-first"
    alias ls="$exa_cmd"
    alias l="$exa_cmd"
    alias ll="$exa_cmd -hl"
    alias la="$exa_cmd -ha"
    alias lla="$exa_cmd -hlaF"
else
    alias l="ls"
    alias la="ls -a"
    alias lla="ls -lah"
fi

if command -v "bat" &> /dev/null; then
    alias cat="bat"
fi

alias p="python"
alias p3="python3"
alias cls="clear"

# safe rm command
alias rm="gio trash"

if command -v "emacs" &> /dev/null; then
    alias ec="emacsclient -c"
    alias ecnw="TERM=xterm-direct emacsclient -c -nw"
    alias e="emacs"
    alias enw="TERM=xterm-direct emacs -nw"
    alias erestart="emacsclient -e '(save-buffers-kill-emacs)'; emacs --daemon"
fi

alias yay="paru --bottomup"

alias tmux="tmux -u"

# alias to update all zsh plugins that are git repos.
alias zsh_update='for plugin in $HOME/.zsh/*; do [ -d $plugin/.git ] && echo \"Updating $plugin.\" && git -C $plugin pull 2> /dev/null; done'
