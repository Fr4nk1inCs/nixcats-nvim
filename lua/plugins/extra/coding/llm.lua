return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          model = "claude-3.7-sonnet-thought",
        },
      },
      input = {
        provider = "snacks",
        provider_opts = {
          title = "Avante Input",
          icon = " ",
        },
      },
    },
    build = require("nixCatsUtils").lazyAdd("make", nil),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "ibhagwan/fzf-lua",
      "echasnovski/mini.icons",
      "zbirenbaum/copilot.lua",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      "folke/snacks.nvim",
    },
  },
}
