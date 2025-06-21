if not require("nixCatsUtils").enableForCategory("extra", true) then
  return {}
end

vim.lsp.enable(LangSettings.extra.lsps)

return {
  LangSettings.extra.plugins,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = LangSettings.extra.treesitters,
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = LangSettings.extra.mason,
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      opts.sources = vim.list_extend(opts.sources or {}, Utils.lang.none_ls(LangSettings.extra))
    end,
  },
  { import = "plugins.extra.coding" },
  { import = "plugins.extra.editor" },
  { import = "plugins.extra.external" },
  { import = "plugins.extra.debugger" },
}
