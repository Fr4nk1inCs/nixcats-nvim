if not vim.fn.executable("nix") then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          on_attach = function(client, _)
            -- disable LSP formatting
            client.server_capabilities.documentFormattingProvider = false
          end,
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        require("null-ls").builtins.formatting.alejandra,
        require("null-ls").builtins.diagnostics.deadnix,
        require("null-ls").builtins.diagnostics.statix,
        require("null-ls").builtins.code_actions.statix,
      },
    },
  },
  -- {
  --   "williamboman/mason.nvim",
  --   opts = {
  --     ensure_installed = { "nil", "alejandra" },
  --   },
  -- },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "nix" },
    },
  },
}
