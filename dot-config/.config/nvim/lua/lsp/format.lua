-- Native, (mostly) plugin-free formatting on save.
--
-- Each filetype maps to an ordered list of steps. A step is either:
--   * an argv list  -> the buffer is piped through the CLI (stdin -> stdout)
--   * a function(buf) -> runs in place (used for LSP-driven steps)
-- Steps always read the current buffer state, so order is preserved even when
-- mixing external CLIs and LSP edits.

local M = {}

-- Organize Go imports via gopls (module-aware; replaces goimports-reviser).
local function go_organize_imports(buf)
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "gopls" })) do
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { "source.organizeImports" }, diagnostics = {} }

        local resp = client:request_sync("textDocument/codeAction", params, 1000, buf)
        for _, action in ipairs((resp or {}).result or {}) do
            if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            end
        end
    end
end

local function lsp_format(name)
    return function(buf)
        vim.lsp.buf.format({ bufnr = buf, name = name, async = false })
    end
end

local steps = {
    go = {
        go_organize_imports,
        { "gofumpt" },
        { "golines", "--max-len=79" },
    },
    c = { { "clang-format", "--style={IndentWidth: 4}" } },
    cpp = { { "clang-format", "--style={IndentWidth: 4}" } },
    python = { lsp_format("ruff") },
    lua = { lsp_format("lua_ls") },
}

-- Pipe the whole buffer through `argv` (stdin -> stdout) and write the result
-- back, preserving the cursor/view. Leaves the buffer untouched on failure.
local function pipe_through(buf, argv)
    local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
    local out = vim.fn.system(argv, content)

    if vim.v.shell_error ~= 0 then
        vim.notify(("format: %s failed\n%s"):format(argv[1], out), vim.log.levels.ERROR)
        return
    end

    local lines = vim.split(out, "\n", { trimempty = false })
    if lines[#lines] == "" then
        table.remove(lines)
    end

    if not vim.deep_equal(lines, vim.api.nvim_buf_get_lines(buf, 0, -1, false)) then
        local view = vim.fn.winsaveview()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.fn.winrestview(view)
    end
end

-- Format the whole buffer according to its filetype's step list.
function M.format(buf)
    buf = buf or vim.api.nvim_get_current_buf()
    local list = steps[vim.bo[buf].filetype]
    if not list then
        return
    end

    for _, step in ipairs(list) do
        if type(step) == "function" then
            step(buf)
        else
            pipe_through(buf, step)
        end
    end
end

-- Pick the LSP client to use for range formatting on the current buffer.
local function range_format_client(buf)
    local clients = vim.lsp.get_clients({ bufnr = buf })
    for _, c in ipairs(clients) do
        if c:supports_method("textDocument/rangeFormatting") then
            return c
        end
    end
end

-- <leader>ps: format only the git-modified ranges, then write.
-- Skips the whole-file on-save formatter for this write.
function M.format_modifications_and_write()
    local buf = vim.api.nvim_get_current_buf()

    local client = range_format_client(buf)
    if not client then
        vim.notify("format: no LSP client with range formatting here", vim.log.levels.WARN)
        return
    end

    local ok, fmtmod = pcall(require, "lsp-format-modifications")
    if not ok then
        vim.notify("lsp-format-modifications not installed", vim.log.levels.ERROR)
        return
    end

    fmtmod.format_modifications(client, buf)
    vim.b[buf].skip_format_on_save = true
    vim.cmd("write")
    vim.b[buf].skip_format_on_save = false
end

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true }),
    callback = function(args)
        if vim.b[args.buf].skip_format_on_save then
            return
        end
        M.format(args.buf)
    end,
})

return M
