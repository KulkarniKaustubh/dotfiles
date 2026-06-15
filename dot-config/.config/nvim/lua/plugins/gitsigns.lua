return {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
        current_line_blame = true,
        current_line_blame_opts = { delay = 300, virt_text_pos = "eol" },
    },
}
