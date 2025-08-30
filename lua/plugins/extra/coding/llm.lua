return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    ---@module "avante"
    ---@type avante.Config
    opts = {
      windows = {
        position = "smart",
      },
      mappings = {
        sidebar = {
          close_from_input = { normal = "q", insert = "<c-d>" },
        },
      },
      provider = "copilot",
      providers = {
        copilot = {
          model = "claude-sonnet-4",
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
    -- FIXME: This is a temporary fix for the horizontal layout issue.
    config = function(_, opts)
      require("avante").setup(opts)

      local open_sidebar = require("avante.sidebar").open
      require("avante.sidebar").open = function(self, open_opts)
        open_sidebar(self, open_opts)

        if self:get_layout() == "horizontal" then
          if self.containers.input ~= nil then
            self.containers.input:update_layout({
              size = {
                width = "40%",
              },
            })
          end
        end
      end
    end,
  },
}
