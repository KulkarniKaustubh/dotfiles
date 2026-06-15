local keymaps = require("utils.keymaps")

local mappings = {
    n = {
        { "<leader>lt", "<cmd> Trouble diagnostics toggle <CR>",            desc = "Trouble diagnostics" },
        { "<leader>lo", "<cmd> Trouble diagnostics toggle filter.buf=0 <CR>", desc = "Trouble diagnostics (buffer)" },
    },
}

keymaps.add(mappings)

return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
}
