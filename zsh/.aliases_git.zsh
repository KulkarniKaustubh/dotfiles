if command -v "git" &> /dev/null; then
    alias gst="git status"
    alias ga="git add"
    alias gcm="git commit -m"
    alias gl="git pull"
    alias gp="git push"
    alias gcl="git clone"
else
    echo "Install git."
fi
