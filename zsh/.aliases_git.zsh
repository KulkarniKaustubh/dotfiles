if command -v "git" &> /dev/null; then
    alias gst="git status"
    alias ga="git add"
    alias gcm="git commit -m"
    alias gl="git pull"
    alias gp="git push"
    alias gcl="git clone"
    alias glo="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"
    alias gloa="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
else
    echo "Install git."
fi
