require("lsp.keymaps")

local lsps = {
    require("lsp.gopls"),
    require("lsp.lua_ls"),
}

for _, lsp in pairs(lsps) do
    local name, config = lsp[1], lsp[2]
    vim.lsp.enable(name)

    if config then
        vim.lsp.config(name, config)
    end
end
