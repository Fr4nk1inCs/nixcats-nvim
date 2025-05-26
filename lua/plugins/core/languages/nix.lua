if not vim.fn.executable("nix") then
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          settings = {
            nixd = {
              formatting = {
                command = { "alejandra" },
              },
            },
          },
        },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        require("null-ls").builtins.diagnostics.deadnix,
        require("null-ls").builtins.diagnostics.statix,
        require("null-ls").builtins.code_actions.statix,
      },
    },
  },
  -- {
  --   "mason-org/mason.nvim",
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
