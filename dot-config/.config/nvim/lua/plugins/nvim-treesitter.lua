return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    -- IMPORTANT: opts must be applied via the `configs` module. The top-level
    -- `nvim-treesitter` module's setup() takes no args and silently ignores opts.
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {
            "c",
            "lua",
            "vim",
            "vimdoc",
            "python",
            "go",
            "gomod",
            "gosum",
            "markdown",
            "markdown_inline",
            "json",
            "yaml",
            "bash",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
}
