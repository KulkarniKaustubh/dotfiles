local keymaps = require("utils.keymaps")
local opts = { noremap = true, silent = true }

-- Neovim 0.11 ships sensible LSP defaults already: grr (references),
-- gra (code action), grn (rename), gri (implementation), K (hover),
-- [d / ]d (diagnostics). These add the <leader>l* convenience layer on top.
local mappings = {
    n = {
        -- Override the default grr to use Telescope's picker (keeps gra/grn/gri intact)
        { "grr",        "<cmd> Telescope lsp_references <CR>",      desc = "LSP references (Telescope)" },
        { "<leader>lh", function() vim.lsp.buf.hover() end,         desc = "LSP hover" },
        { "<leader>la", function() vim.lsp.buf.code_action() end,   desc = "LSP code action" },
        { "<leader>lr", function() vim.lsp.buf.rename() end,        desc = "LSP rename" },
        { "<leader>ld", function() vim.diagnostic.setloclist() end, desc = "Diagnostics to loclist" },
        { "<leader>lL", function() vim.diagnostic.open_float() end, desc = "Floating diagnostic" },
        {
            "<leader>ps",
            function() require("lsp.format").format_modifications_and_write() end,
            desc = "Save + format modified ranges only",
        },
    },
}

keymaps.add(mappings, opts)
