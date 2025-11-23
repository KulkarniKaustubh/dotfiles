local keymaps = require("utils.keymaps")
local border_style = "rounded"

local mappings = {
    n = {
        { "<leader>e", "<cmd> Oil <CR>", desc = "Oil explorer" },
    },
}

keymaps.add(mappings)

return {
    "stevearc/oil.nvim",
    dependencies = {
        { "nvim-mini/mini.icons",       opts = {} },
        { "nvim-tree/nvim-web-devicons" },
    },
    lazy = false,
    opts = {
        default_file_explorer = true,
        keymaps = {
            ["<C-v>"] = { "actions.select", opts = { vertical = true } },
            ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
        },
        columns = {
            "icon",
        },
        float = {
            border = border_style,
        },
        confirmation = {
            border = border_style,
        },
        keymaps_help = {
            border = border_style,
        },
    },
}
