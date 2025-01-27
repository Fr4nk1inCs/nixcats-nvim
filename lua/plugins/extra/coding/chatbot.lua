return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = "VeryLazy",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = require("nixCatsUtils").lazyAdd("make tiktoken"),
    opts = {
      window = { border = "rounded" },
    },
  },
}
