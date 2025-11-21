local keymaps = {}

local wk = require("which-key")

function keymaps.add(mappings, opts)
    -- Loop over modes and register all mappings with which-key
    for mode, maps in pairs(mappings) do
        for k, map in pairs(maps) do
            local numeric_keys = {}
            local wk_map = {}

            for k, v in ipairs(map) do
                table.insert(wk_map, v)
                table.insert(numeric_keys, k)
            end

            for k, v in pairs(map) do
                if type(k) ~= "number" then
                    wk_map[k] = v
                end
            end

            if #numeric_keys == 2 then
                vim.keymap.set(mode, map[1], map[2], opts)
            end

            wk.add(wk_map, { mode = mode })
        end
    end
end

return keymaps
