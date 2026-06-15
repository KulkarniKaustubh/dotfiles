-- Declaratively install LSP servers + formatter CLIs through Mason.
-- Names are Mason package names (not lspconfig names).
return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    opts = {
        ensure_installed = {
            -- LSP servers
            "lua-language-server",
            "gopls",
            "pyright",
            "ruff",
            "clangd",
            "typescript-language-server",
            -- Formatters
            "gofumpt",
            "golines",
            "clang-format",
        },
    },
}
