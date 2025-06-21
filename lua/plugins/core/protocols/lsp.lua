return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    ---@class PluginLspOpts
    opts = {},
    config = function(_, _) end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts_extend = { "sources" },
    opts = function(_, opts)
      opts.root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, Utils.lang.none_ls(LangSettings.core))
    end,
  },
  {
    "mason.nvim",
    enabled = require("nixCatsUtils").lazyAdd(true, false),
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = LangSettings.core.mason,
    },
  },
}
