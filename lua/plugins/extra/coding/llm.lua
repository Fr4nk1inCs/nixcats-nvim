return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "deepseek-chat",
      vendors = {
        ["deepseek-chat"] = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-chat",
        },
        ["deepseek-reasoner"] = {
          __inherited_from = "openai",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-chat",
        },
        ["copilot-o3-mini"] = {
          __inherited_from = "copilot",
          model = "o3-mini",
        },
        ["copilot-claude-3.5-sonnet"] = {
          __inherited_from = "copilot",
          model = "claude-3.5-sonnet",
        },
        ["copilot-gpt-4o"] = {
          __inherited_from = "copilot",
          model = "gpt-4o",
        },
      },
    },
    build = require("nixCatsUtils").lazyAdd("make", nil),
    dependencies = {
      "stevearc/dressing.nvim",
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
    },
  },
}
