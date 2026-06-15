-- AI assistant. One active provider at a time: swap by changing `active` and
-- adding an entry to `providers`. Each provider returns a lazy.nvim spec and
-- registers its own <leader>a keymaps, so inactive providers contribute
-- nothing -- adding/switching to another AI is a one-line change here.
local keymaps = require("utils.keymaps")

local active = "augment"

local providers = {}

-- Augment (augmentcode/augment.vim). Chat-only: inline completions were sunset
-- upstream, so there is no accept keymap and nothing conflicts with blink.cmp.
-- Requires Node.js >= 22 and a one-time `:Augment signin` before chat works.
providers.augment = function()
    -- Deferred: this provider is imported during lazy's spec phase, before
    -- which-key is loaded, and the "AI" group entry needs which-key. schedule
    -- runs it after startup, once which-key is available.
    vim.schedule(function()
        keymaps.add({
            n = {
                { "<leader>a",  group = "AI" },
                { "<leader>ac", "<cmd> Augment chat <CR>",        desc = "Chat" },
                { "<leader>ai", "<cmd> Augment chat-input <CR>",  desc = "Chat input" },
                { "<leader>an", "<cmd> Augment chat-new <CR>",    desc = "New chat" },
                { "<leader>at", "<cmd> Augment chat-toggle <CR>", desc = "Toggle chat" },
                { "<leader>as", "<cmd> Augment status <CR>",      desc = "Status" },
            },
            v = {
                { "<leader>ac", "<cmd> Augment chat <CR>", desc = "Chat about selection" },
            },
        })
    end)

    return {
        "augmentcode/augment.vim",
        cmd = "Augment",
        -- Must be set before the plugin loads; lazy runs `init` at startup.
        init = function()
            vim.g.augment_workspace_folders = { vim.fn.getcwd() }
        end,
    }
end

return providers[active]()
