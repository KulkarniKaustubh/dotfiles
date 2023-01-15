# ZSH

Prerequisites to reproduce my `zsh` shell:

- `fzf` (fuzzy finder)
- `fd` or `fd-find` (the Rust alternative to the `find` command)

Recommended:

- `bat` (the Rust alternative to the `cat` command)
- `exa` (the Rust alternative to the `ls` command)
- `figlet`
- `lolcat`

Also install the fonts from the `fonts` directory. `Speed.flf` is a `figlet` font, and `MesloLGS NF Regular.ttf` is a system font. Change your terminal's font to "MesloLGS NF Regular".

Steps:

```
$ git clone https://github.com/KulkarniKaustubh/dotfiles
$ cd dotfiles
$ stow --ignore="fonts" zsh
$ chsh -s $(which zsh)
```

> You can change the shell variable `EDITOR` in the last line of the `.zshrc` file

Log out and log in after this.

This will produce results as good as `oh-my-zsh` without any of the bloat.

Once you open your terminal for the first time after switching to `zsh`, the correct git repositories as well as directories will be created.

## Additional Features

- Hitting `Ctrl-f` will enable you to go from any directory to any other directory within the home directory with a fuzzy finding menu.
- `Ctrl-r` will show up a fuzzy menu with a list of your previous commands.
- A bunch of useful aliases you can find in the three `.aliases*.zsh` files.
- Issues with emacs tramp will not occur (a common issue with non-bash shells).
- You will get bash's command not found helper.