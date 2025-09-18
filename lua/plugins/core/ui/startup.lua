return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qS",
        function()
          require("persistence").select()
        end,
        desc = "Select Session",
      },
      {
        "<leader>ql",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
      {
        "<leader>qd",
        function()
          require("persistence").stop()
        end,
        desc = "Don't Save Current Session",
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      dashboard = {
        preset = {
          header = [[
███████╗██████╗ ██╗  ██╗███╗   ██╗██╗  ██╗ ██╗██╗███╗   ██╗
██╔════╝██╔══██╗██║  ██║████╗  ██║██║ ██╔╝███║██║████╗  ██║
█████╗  ██████╔╝███████║██╔██╗ ██║█████╔╝ ╚██║██║██╔██╗ ██║
██╔══╝  ██╔══██╗╚════██║██║╚██╗██║██╔═██╗  ██║██║██║╚██╗██║
██║     ██║  ██║     ██║██║ ╚████║██║  ██╗ ██║██║██║ ╚████║
╚═╝     ╚═╝  ╚═╝     ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═╝╚═╝╚═╝  ╚═══╝]],
          keys = {
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", limit = 8, indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", limit = 6, indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
}
