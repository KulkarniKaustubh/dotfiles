local keymaps = require("utils.keymaps")
local opts = { noremap = true, silent = true }

-- Leader is Space (in top-level init.lua)

local mappings = {
    n = {
        { "<leader>w", proxy = "<C-w>", desc = "Window commands" },
        { "<leader>wc", "<C-w>c", desc = "Close window" },
        { "<leader>wq", "<cmd> qa <CR>", desc = "Quit all" },
        { "<leader>q", "<cmd> q <CR>", desc = "Quit buffer" },
        { "<leader>s", "<cmd> w <CR>", desc = "Save file" },
        { "<S-l>", "<cmd> bnext <CR>", desc = "Next buffer" },
        { "<S-h>", "<cmd> bprevious <CR>", desc = "Prev buffer" },
        { "<C-l>", "zz", desc = "Center current line" },
        { "<leader>/", "<cmd> norm gcc <CR>", desc = "Toggle comment" },
        { "<ESC>", "<cmd> noh <CR>", desc = "Clear highlights" },
        { "<C-j>", "<Down>", desc = "Go down" },
        { "<C-k>", "<Up>", desc = "Go up" },

        -- No idea why indentation doesn't work without this
        { "<<", "<<", desc = "Indent left" },
        { ">>", ">>", desc = "Indent right" },
    },

    v = {
        { "<", "<gv", desc = "Indent left" },
        { ">", ">gv", desc = "Indent right" },
        { "<leader>/", "<cmd> norm gc <CR>", desc = "Toggle comment" },
    },

    x = {
        { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', desc = "Don't copy replaced text", silent = true },
    },
}

keymaps.add(mappings, opts)

for _, char in ipairs({",", ".", "!", "?"}) do
    vim.keymap.set("i", char, char .. "<C-g>u")
end
