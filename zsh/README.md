# ZSH

## To reproduce my `zsh` shell:

Prerequisites

- `fzf` (fuzzy finder)
- `fd` or `fd-find` (the Rust alternative to the `find` command)
- `figlet`
- `lolcat`

Recommended:

- `bat` (the Rust alternative to the `cat` command)
- `exa` (the Rust alternative to the `ls` command)

## Steps:

### Step 1

```sh
$ git clone https://github.com/KulkarniKaustubh/dotfiles
$ cd dotfiles
$ stow --ignore="fonts" zsh
$ chsh -s $(which zsh)
```

> You can change the shell variable `EDITOR` in the last line of the `.zshrc` file

For the right [fonts](https://github.com/KulkarniKaustubh/dotfiles/tree/main/zsh/fonts), follow these commands once you are in the `dotfiles` directory:

```sh
$ sudo cp fonts/Speed.flf /usr/share/figlet/fonts/
$ cp fonts/Fura\ Mono\ Regular\ Nerd\ Font\ Complete\ Mono.otf $HOME/.local/share/fonts/
 ```

### Step 2
Change your terminal's font to "Fura Mono NF".

### Step 3
Log out and log in.

You're done! This will produce results as good as `oh-my-zsh` without any of the bloat.

Once you open your terminal for the first time after switching to `zsh`, the correct git repositories as well as directories will be created in `$HOME/.zsh`.

## Additional Features

- Hitting `Ctrl-f` will enable you to go from any directory to any other directory within the home directory with a fuzzy finding menu.
- `Ctrl-r` will show up a fuzzy menu with a list of your previous commands.
- A bunch of useful aliases you can find in the three `.aliases*.zsh` files.
- Issues with emacs tramp will not occur (a common issue with non-bash shells).
- You will get bash's command not found helper.


## Downsides

- You will have to manually clone any other `zsh` plugins you want into the `$HOME/.zsh` directory, and source the correct file inside the `zshrc` file.
- Updation of the plugins will need to be done manually by running `git pull` on any `zsh` plugins present in the `$HOME/.zsh` directory.
