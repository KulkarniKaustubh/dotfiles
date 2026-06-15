-- Make Mason-installed servers/formatters resolvable to bare `cmd`/system calls.
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

require("lsp.keymaps")
require("lsp.format")

local servers = {
    require("lsp.servers.gopls"),
    require("lsp.servers.lua_ls"),
    require("lsp.servers.pyright"),
    require("lsp.servers.ruff"),
    require("lsp.servers.clangd"),
    require("lsp.servers.ts_ls"),
}

-- Completion capabilities (blink) applied to every server.
local capabilities = require("blink.cmp").get_lsp_capabilities()
capabilities.offsetEncoding = { "utf-16" }

vim.lsp.config("*", {
    capabilities = capabilities,
})

for _, server in pairs(servers) do
    local name, config = server[1], server[2]
    if config then
        vim.lsp.config(name, config)
    end
    vim.lsp.enable(name)
end

-- Diagnostics presentation
vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    float = { border = "single" },
})
vim.o.winborder = "single"

-- Per-server capability tweaks
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_tweaks", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        if client.name == "ruff" then
            -- Pyright owns hover for Python
            client.server_capabilities.hoverProvider = false
        elseif client.name == "clangd" then
            client.server_capabilities.signatureHelpProvider = false
        end
    end,
})
