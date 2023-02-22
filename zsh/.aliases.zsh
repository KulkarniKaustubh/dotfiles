alias c='cd'
alias c..='cd ..'

if command -v "exa" &> /dev/null; then
    exa_cmd="exa --icons --group-directories-first"
    alias ls="$exa_cmd"
    alias l="$exa_cmd"
    alias ll="$exa_cmd -l"
    alias la="$exa_cmd -a"
    alias lla="$exa_cmd -laF"
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

alias rm="gio trash" # safe rm command

if command -v "emacs" &> /dev/null; then
    alias ec="emacsclient -c"
    alias ecnw="TERM=xterm-direct emacsclient -c -nw"
    alias e="emacs"
    alias enw="TERM=xterm-direct emacs -nw"
    alias erestart="emacsclient -e '(save-buffers-kill-emacs)'; emacs --daemon"
fi

alias keys="xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf \"%-3s %s\n\", $5, $8 }'"

alias yay="paru --bottomup"

alias tmux="tmux -u"
