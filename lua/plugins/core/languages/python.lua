return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
            inlayHints = {
              callArgumentNames = "partial",
              functionReturnTypes = true,
              pytestParameters = true,
              variableTypes = true,
            },
          },
        },
        ruff = {
          cmd_env = { RUFF_TRACE = "messages" },
          init_options = {
            settings = {
              logLevel = "error",
            },
          },
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.formatting.isort,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "black", "isort" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ninja", "rst" },
    },
  },
}
