local keymaps = require("utils.keymaps")

local mappings = {
    n = {
        { "<leader>,",  "<cmd>Telescope find_files follow=true no_ignore=true hidden=true <CR>", desc = "Find files" },
        { "<leader>.",  "<cmd>Telescope buffers<CR>",                                            desc = "Browse open buffers" },
        { "<leader>ll", "<cmd> Telescope diagnostics bufnr=0 <CR>",                              desc = "Telescope diagnostics for current buffer" },
        { "<leader>lA", "<cmd> Telescope diagnostics <CR>",                                      desc = "Telescope diagnostics for the project" },
        { "<C-f>",      "<cmd> Telescope live_grep <CR>",                                        desc = "Telescope live grep" },
        { "<leader>ft", "<cmd> Telescope live_grep <CR>",                                        desc = "Telescope live grep" },
        { "<C-s>",      "<cmd> Telescope current_buffer_fuzzy_find <CR>",                        desc = "Current buffer fuzzy find" },
    },
}

keymaps.add(mappings)

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        defaults = {
            prompt_prefix = "   ",
            selection_caret = "  ",
            entry_prefix = "  ",
            layout_strategy = "vertical",
            layout_config = { width = 0.8, prompt_position = "top", mirror = true, preview_height = 0.6 },
            sorting_strategy = "ascending",
            mappings = {
                i = {
                    ["<C-n>"] = require("telescope.actions").cycle_history_next,
                    ["<C-p>"] = require("telescope.actions").cycle_history_prev,
                    ["<C-j>"] = require("telescope.actions").move_selection_next,
                    ["<C-k>"] = require("telescope.actions").move_selection_previous,
                },
            },
        },
    },
}
