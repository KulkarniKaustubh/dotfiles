local NUM_SPACES = 4

local options = {
    autoindent = true,
    expandtab = true,
    smartindent = true,
    tabstop = NUM_SPACES,
    softtabstop = NUM_SPACES,
    shiftwidth = NUM_SPACES,
    undofile = true,
    number = true,
    relativenumber = true,
    timeout = true,
    timeoutlen = 150,
    splitbelow = true,
    splitright = true,
    scrolloff = 15,
    -- ported from nvim-config
    colorcolumn = "80",
    signcolumn = "yes",
    ignorecase = true,
    smartcase = true,
    inccommand = "split",
    updatetime = 250,
    confirm = true,
    linebreak = true,
    -- For auto-session
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions",
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.clipboard:append { "unnamed", "unnamedplus" }

vim.opt.listchars = {
    tab = "→ ",
    space = "·",
    nbsp = "␣",
    trail = "•",
    eol = "$",
    precedes = "«",
    extends = "»",
}

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.hl.on_yank({ timeout = 150 })
    end,
})
