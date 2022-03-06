alias c='cd'
alias c..='cd ..'

# alias ll='ls -l'
# alias la='ls -A'
# alias l='ls -CF'
# alias lla='ls -alF'

alias ls='exa'
alias ll='exa -l'
alias la='exa -a'
alias lla='exa -laF'
alias l="ls"

alias cat="bat"

alias p="python"
alias p3="python3"
alias cls="clear"

alias srm="gio trash" # safe rm command

alias ec="emacsclient -c"
alias ecnw="TERM=xterm-direct emacsclient -c -nw"
alias e="emacs"
alias enw="TERM=xterm-direct emacs -nw"

alias erestart="emacsclient -e '(save-buffers-kill-emacs)'; emacs --daemon"
