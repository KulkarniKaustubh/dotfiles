return {
    "rmagatti/auto-session",
    lazy = false,
    opts = {
        bypass_save_filetypes = { "fugitive" },
        -- Don't pull telescope in at startup just to register the picker.
        session_lens = { load_on_setup = false },
    },
}
