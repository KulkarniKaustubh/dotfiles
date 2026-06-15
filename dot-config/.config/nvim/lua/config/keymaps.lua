local keymaps = require("utils.keymaps")
local opts = { noremap = true, silent = true }

-- Leader is Space (in top-level init.lua)

local M = {}

-- Prefill an interactive :substitute for the word under the cursor.
-- feedkeys lands it in the command line so the replacement stays editable.
function M.replace_cword()
    local word = vim.fn.expand("<cword>")
    if word == "" then
        return
    end
    vim.api.nvim_feedkeys(":%s/\\<" .. word .. "\\>/" .. word .. "/gcI", "n", false)
end

-- Same idea for the current visual selection.
function M.replace_selection()
    vim.cmd('noautocmd normal! "hy')
    local sel = vim.fn.escape(vim.fn.getreg("h"), "/\\")
    vim.api.nvim_feedkeys(":%s/" .. sel .. "/" .. sel .. "/gcI", "n", false)
end

local mappings = {
    n = {
        { "<leader>w",  proxy = "<C-w>",        desc = "Window commands" },
        { "<leader>wc", "<C-w>c",               desc = "Close window" },
        { "<leader>wq", "<cmd> qa <CR>",        desc = "Quit all" },
        { "<leader>q",  "<cmd> bd <CR>",        desc = "Quit buffer" },
        { "<leader>s",  "<cmd> w <CR>",         desc = "Save file" },
        { "<S-l>",      "<cmd> bnext <CR>",     desc = "Next buffer" },
        { "<S-h>",      "<cmd> bprevious <CR>", desc = "Prev buffer" },
        { "<C-l>",      "zz",                   desc = "Center current line" },
        { "<leader>/",  "<cmd> norm gcc <CR>",  desc = "Toggle comment" },
        { "<ESC>",      "<cmd> noh <CR>",       desc = "Clear highlights" },
        { "<C-j>",      "<Down>",               desc = "Go down" },
        { "<C-k>",      "<Up>",                 desc = "Go up" },

        -- Keep cursor centered while navigating
        { "n",          "nzz",                  desc = "Next search result (centered)" },
        { "N",          "Nzz",                  desc = "Prev search result (centered)" },
        { "<C-d>",      "<C-d>zz",              desc = "Half page down (centered)" },
        { "<C-u>",      "<C-u>zz",              desc = "Half page up (centered)" },

        -- Find and replace the word under the cursor
        { "<leader>r",  M.replace_cword,        desc = "Replace word under cursor" },

        -- No idea why indentation doesn't work without this
        { "<<",         "<<",                   desc = "Indent left" },
        { ">>",         ">>",                   desc = "Indent right" },
    },

    v = {
        { "<",         "<gv",                   desc = "Indent left" },
        { ">",         ">gv",                   desc = "Indent right" },
        { "<leader>/", "<cmd> norm gc <CR>",    desc = "Toggle comment" },
        { "<leader>r", M.replace_selection,     desc = "Replace selection" },
    },

    x = {
        { "p", 'p:let @+=@0<CR>:let @"=@0<CR>', desc = "Don't copy replaced text", silent = true },
    },

    i = {
        { "jk", "<ESC>", desc = "Exit insert mode" },
    },
}

keymaps.add(mappings, opts)

for _, char in ipairs({ ",", ".", "!", "?" }) do
    vim.keymap.set("i", char, char .. "<C-g>u")
end

return M
