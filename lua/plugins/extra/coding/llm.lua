---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    cmd = { "CodeCompanion" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "franco-ruggeri/codecompanion-spinner.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
    opts = {
      adapter = {
        acp = {
          gemini_cli = function()
            return require("codecompanion.adapters").extend(
              "gemini_cli",
              { defaults = { auth_method = "oauth-personal" } }
            )
          end,
        },
      },
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        cmd = { adapter = "copilot" },
      },
      extensions = {
        spinner = {},
        history = { enabled = true },
      },
    },
  },
  {
    "folke/sidekick.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "Sidekick" },
    ---@module "sidekick"
    ---@type sidekick.Config
    opts = {
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
    keys = {
      {
        "<c-a>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<c-a>"
          end
        end,
        expr = true,
        desc = "Goto/Apply next edit suggestion",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_x = opts.sections.lualine_x or {}

      -- Copilot status
      table.insert(
        opts.sections.lualine_x,
        2,
        Utils.lualine.status(" ", function()
          local status = require("sidekick.status").get()
          if status == nil then
            return nil
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
