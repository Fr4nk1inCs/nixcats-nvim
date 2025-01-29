return {
  -- prettier
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "prettier" } },
      },
    },
    opts = {
      sources = {
        require("null-ls").builtins.formatting.prettier,
      },
    },
  },
  -- eslint
  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
            format = true,
          },
        },
        cssls = {},
      },
    },
  },
}
