NUM_SPACES = 4

local options = {
    autoindent = true,
    expandtab = true,
    smartindent = true,
    tabstop = NUM_SPACES,
    shiftwidth = NUM_SPACES,
    undofile = true,
    number = true,
    relativenumber = true,
    timeout = true,
    timeoutlen = 400,
    splitbelow = true,
    splitright = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.clipboard:append { "unnamed", "unnamedplus" }
