local keymaps = require("utils.keymaps")

local mappings = {
    n = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Flash jump" },
    },
    v = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Flash jump" },
    },
    x = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Flash jump" },
    },
    o = {
        { "<leader>fh", "<cmd> HopWord <CR>", desc = "Flash jump" },
    },
}

keymaps.add(mappings)

return {
    "smoka7/hop.nvim",
    opts = {
        keys = "etovxqpdygfblzhckisuran",
    },
}
