local keymaps = {}

-- which-key options that double as vim.keymap.set() options.
local map_opts = { "desc", "silent", "noremap", "nowait", "expr", "buffer", "remap" }

-- Register mappings grouped by mode. A spec is { lhs, rhs, desc = ... }; the
-- keymap is created with vim.keymap.set and which-key shows it via its `desc`.
-- Specs without an rhs (groups, `proxy`) go straight to which-key.
function keymaps.add(mappings, opts)
    opts = opts or {}
    for mode, specs in pairs(mappings) do
        for _, spec in ipairs(specs) do
            local lhs, rhs = spec[1], spec[2]
            if rhs == nil then
                spec.mode = mode
                require("which-key").add(spec)
            else
                local o = vim.tbl_extend("force", {}, opts)
                for _, key in ipairs(map_opts) do
                    if spec[key] ~= nil then
                        o[key] = spec[key]
                    end
                end
                vim.keymap.set(mode, lhs, rhs, o)
            end
        end
    end
end

return keymaps
