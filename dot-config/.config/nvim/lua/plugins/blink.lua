return {
    "saghen/blink.cmp",
    -- Use a release tag so blink pulls its prebuilt fuzzy-matcher binary
    -- instead of needing a local `cargo build`.
    version = "*",
    lazy = false,
    opts = {
        keymap = { preset = "default" }, -- <C-y> accept, <C-n>/<C-p> select, <C-space> docs
        appearance = { nerd_font_variant = "mono" },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
}
