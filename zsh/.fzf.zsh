# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kaustubh/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/kaustubh/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kaustubh/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/kaustubh/.fzf/shell/key-bindings.zsh"
