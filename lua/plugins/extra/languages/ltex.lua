return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "barreiroleo/ltex_extra.nvim",
        ft = { "markdown", "tex" },
      },
    },
    opts = {
      servers = {
        ltex = {
          on_attach = function(_, bufnr)
            require("ltex_extra").setup({
              load_langs = { "en-US", "zh-CN" },
              path = ".ltex",
            })
          end,
          settings = {},
        },
      },
    },
  },
}
