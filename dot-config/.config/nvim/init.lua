vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.lazy")
require("config.keymaps")

vim.cmd.colorscheme("catppuccin-mocha")
