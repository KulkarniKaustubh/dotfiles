local keymaps = require("utils.keymaps")
local border_style = "rounded"

local mappings = {
    n = {
        { "<leader>e", function() require("oil").toggle_float() end, desc = "Oil explorer (float)" },
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
        view_options = {
            show_hidden = true,
        },
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
