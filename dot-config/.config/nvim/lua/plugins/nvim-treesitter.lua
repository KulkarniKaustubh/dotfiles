return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    opts = {
        ensure_installed = {
            "c",
            "lua",
            "vim",
            "python",
            "markdown",
            "go",
            "json",
            "yaml",
        },
        auto_install = true,
    },
}
