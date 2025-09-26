if command -v "git" &> /dev/null; then
    alias gst="git status"
    alias ga="git add"
    alias gcm="git commit -m"
    alias gl="git pull"
    alias gp="git push"
    alias gcl="git clone"
    alias glo="git log --oneline --graph --decorate --color"
    alias gloa="git log --oneline --graph --decorate --all --color"
else
    echo "Install git."
fi
