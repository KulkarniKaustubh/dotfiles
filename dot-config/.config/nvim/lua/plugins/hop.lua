local keymaps = require("utils.keymaps")

local mappings = {
    n = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Hop jump" },
    },
    v = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Hop jump" },
    },
    x = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Hop jump" },
    },
    o = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Hop jump" },
    },
}

keymaps.add(mappings)

return {
    "smoka7/hop.nvim",
    opts = {
        keys = "etovxqpdygfblzhckisuran",
    },
}
