---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    ---@module "avante"
    ---@type avante.Config
    "folke/sidekick.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "Sidekick" },
    ---@module "sidekick"
    ---@type sidekick.Config
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
      keymap = {
        ["<c-a>"] = {
          function()
            return require("sidekick").nes_jump_or_apply()
          end,
          vim.lsp.inline_completion.get,
          "fallback",
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
    keys = {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
        "<c-a>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<c-a>"
          end
        end,
        expr = true,
        desc = "Goto/Apply next edit suggestion",
      },
      "folke/snacks.nvim",
    },
    -- FIXME: This is a temporary fix for the horizontal layout issue.
    config = function(_, opts)
      require("avante").setup(opts)

      local open_sidebar = require("avante.sidebar").open
      require("avante.sidebar").open = function(self, open_opts)
        open_sidebar(self, open_opts)
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

        if self:get_layout() == "horizontal" then
          if self.containers.input ~= nil then
            self.containers.input:update_layout({
              size = {
                width = "40%",
              },
            })
      -- Copilot status
      table.insert(
        opts.sections.lualine_x,
        2,
        Utils.lualine.status(" ", function()
          local status = require("sidekick.status").get()
          if status == nil then
            return nil
          end
        end
      end
          if status.busy then
            return "pending"
          end
          return status.kind == "Error" and "error" or "ok"
        end)
      )

      -- CLI session status
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local status = require("sidekick.status").cli()
          return " " .. (#status > 1 and #status or "")
        end,
        cond = function()
          return #require("sidekick.status").cli() > 0
        end,
        color = function()
          return "Special"
        end,
      })
    end,
  },
}
