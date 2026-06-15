# Port nvim-config (NvChad) → this repo's native/vanilla style

Date: 2026-06-14
Status: approved, implementing

## Goal

Full replacement: bring the NvChad-based `~/.config/nvim-config` to feature
parity inside this repo so `nvim-config` can be retired. Keep the repo's
existing idioms: native `vim.lsp` (no nvim-lspconfig), one-file-per-plugin under
`lua/plugins/`, the `utils.keymaps` helper, minimal moving parts.

## Decisions

- **Completion:** blink.cmp (single plugin, `version = "*"` for prebuilt binary).
- **Formatting:** plugin-free, native `BufWritePre` runner (`lua/lsp/format.lua`).
  Whole-file on save. External CLIs piped via stdin; LSP-native where the server
  formats (ruff, lua_ls).
  - **`<leader>ps`** = save + format only git-modified ranges (via
    `lsp-format-modifications.nvim`); bypasses the whole-file on-save formatter.
- **Servers:** gopls (rich settings), lua_ls, pyright, ruff, clangd, ts_ls.
  Each is a `{ name, config }` module under `lua/lsp/servers/`.
- **Python:** pyright (types) + ruff (lint/format) only. No mypy.
- **Go imports:** gopls `source.organizeImports` (replaces goimports-reviser),
  then gofumpt + golines (`--max-len=79`).
- **Plugins added:** blink.cmp, gitsigns, trouble, treesitter-context,
  lsp-format-modifications, mason-tool-installer. No go.nvim, no Augment AI.
- **Tooling install:** mason-tool-installer declares servers + formatters; mason
  bin dir is prepended to `vim.env.PATH` so external formatters/servers resolve.

## Layout

```
lua/
  config/options.lua    extend (colorcolumn, listchars, ignorecase/smartcase,
                        inccommand, signcolumn, updatetime, yank-highlight, ...)
  config/keymaps.lua    extend (centered nav, find-replace word, fugitive)
  lsp/init.lua          enable servers, blink capabilities, diagnostics,
                        per-server tweaks (ruff no-hover, clangd no-sigHelp)
  lsp/keymaps.lua       <leader>l* set + gr Telescope refs + <leader>ps
  lsp/format.lua        native formatter runner + on-save autocmd + ps handler
  lsp/servers/*.lua     gopls lua_ls pyright ruff clangd ts_ls
  plugins/*.lua         blink, gitsigns, trouble, treesitter-context,
                        mason-tool-installer (+ bare entry for lsp-format-mods)
```

## Diagnostics presentation

`virtual_text = false`, single borders for float + `winborder`, underline on.

## Cutover

When verified, delete `~/.config/nvim-config` (left to the user / final step).

## Known wrinkles

- gopls organizeImports replaces goimports-reviser's 3-group sort; flip back if
  the distinct project-group split is wanted.
- blink keymap uses the `default` preset; switch to `super-tab` if Tab-accept is
  preferred.
