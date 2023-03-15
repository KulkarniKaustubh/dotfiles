# Make `cd` use `pushd`
setopt AUTO_PUSHD

fzf-dir() {
    if ! command -v "fd" &> /dev/null; then
        echo "Install fd (or fd-find) for this feature to work."
        return -1
    fi

    if ! command -v "fzf" &> /dev/null; then
        echo "Install fzf for this feature to work."
        return -1
    fi

    local dir ret=$?

    local history_prompt="---- Recent History ----"
    local history_file="$HOME/.local/share/zsh/widgets/dir-operations-history"

    if [ ! -f $history_file ]; then
        if [ ! -d $(dirname $history_file) ]; then
            mkdir -p $(dirname $history_file)
        fi
        touch $history_file
    fi
    
    local dir_histsize=10

    local sed_cmd="sed -e 's|$HOME|~|g'"
    # local pwd_sed_cmd="sed -e 's|$PWD|\.|g'"
    
    local pwd_fd_cmd="fd . . -Ha --type directory | $sed_cmd"
    local home_fd_cmd="fd . $HOME -Ha --type directory | (\tac \"$history_file\" && echo \"\n$history_prompt\n\" && \cat) | $sed_cmd"

    local preview_cmd="echo {} | sed -e 's|~|$HOME|g' | xargs -d '\n' tree -C -L 1 | head -n 20"

    if [ $PWD != $HOME ]; then
        dir=$(eval $pwd_fd_cmd | awk 'NF==0{print;next} !seen[$0]++' |
                  fzf --header="C-f : search ~ | C-v : search ." \
                      --height=60% \
                      --border "top" \
                      --prompt="Search for a directory> " \
                      --bind "ctrl-f:reload(eval $home_fd_cmd)" \
                      --bind "ctrl-v:reload(eval $pwd_fd_cmd)" \
                      --preview "$preview_cmd" \
                      --preview-window 35%,border-left \
              )
    else
        dir=$(eval $home_fd_cmd | awk 'NF==0{print;next} !seen[$0]++' |
                  fzf --height=60% \
                      --border "top" \
                      --prompt="Search for a directory> " \
                      --bind "change:first" \
                      --preview "$preview_cmd" \
                      --preview-window 35%,border-left \
              )
    fi

    if [[ $dir == $history_prompt ]] || [ -z "$dir" ]; then
        zle redisplay
        return 0
    fi

    dir=$(echo "$dir" | sed -e "s|~|$HOME|g")

    pushd $dir >/dev/null

    # Delete existing directory from history file if same as current directory
    sed -i -e "\|$dir|d" $history_file

    local curr_dir_histsize=$(\cat $history_file | wc -l)

    if [ $curr_dir_histsize -lt $dir_histsize ]; then
        echo $dir >> $history_file
    else
        sed -i '1d' $history_file
        echo $dir >> $history_file
    fi

    # precmd functions are the functions/hooks run everytime to reset the prompt
    local precmd
    for precmd in $precmd_functions; do
      $precmd
    done
    zle reset-prompt

    return $ret
}

zle -N fzf-dir
bindkey "^F" fzf-dir

prevd() {
    pushd +1 >/dev/null 2>&1 

    # precmd functions are the functions/hooks run everytime to reset the prompt
    local precmd
    for precmd in $precmd_functions; do
      $precmd
    done
    zle reset-prompt

    return $ret
}

zle -N prevd
bindkey "^[[1;3D" prevd

nextd() {
    pushd -0 >/dev/null 2>&1

    # precmd functions are the functions/hooks run everytime to reset the prompt
    local precmd
    for precmd in $precmd_functions; do
      $precmd
    done
    zle reset-prompt

    return $ret
}

zle -N nextd
bindkey "^[[1;3C" nextd
