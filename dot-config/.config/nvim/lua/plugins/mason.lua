local keymaps = require("utils.keymaps")

local mappings = {
    n = {
        { "<leader>M", "<cmd> Mason <CR>", desc = "Open Mason" },
    },
}

keymaps.add(mappings)

return {
    "mason-org/mason.nvim",
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    },
}
