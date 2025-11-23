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

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp", { clear = true }),

    callback = function(args)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.format { async = false, id = args.data.client_id }
            end,
        })
    end
})
