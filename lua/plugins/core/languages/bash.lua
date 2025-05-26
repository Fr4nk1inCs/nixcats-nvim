return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "shfmt", "shellharden", "shellcheck" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        require("null-ls").builtins.formatting.shellharden,
      },
    },
  },
}
