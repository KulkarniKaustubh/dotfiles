local keymaps = require("utils.keymaps")
local opts = { noremap = true, silent = true }

local mappings = {
    n = {
        { "grr", function() return vim.lsp.buf.references() end, desc = "Show LSP References" },
    },
}

keymaps.add(mappings, opts)
