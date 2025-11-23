local keymaps = require("utils.keymaps")
local opts = { noremap = true, silent = true }

local mappings = {
    n = {
        { "<leader>gg", "<cmd> vert Git <CR>", desc = "Git status" },
    },
}

keymaps.add(mappings, opts)

return {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gedit", "Gsplit", "Gdiffsplit" },
}
