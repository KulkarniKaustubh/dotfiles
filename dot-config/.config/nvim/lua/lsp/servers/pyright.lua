return {
    "pyright",
    {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            ".git",
        },
        settings = {
            pyright = {
                -- ruff owns import organization
                disableOrganizeImports = true,
            },
        },
    },
}
