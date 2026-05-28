---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "folke/sidekick.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "Sidekick" },
    ---@module "sidekick"
    ---@type sidekick.Config
    opts = {
      cli = {
        layout = "left",
      },
    },
    keys = {
      {
        "<c-;>",
        function()
          require("sidekick").nes_jump_or_apply()
        end,
        desc = "Goto/Apply next edit suggestion",
      },
      {
        "<c-;>",
        function()
          if require("sidekick").nes_jump_or_apply() then
            return "<c-;>"
          end
        end,
        mode = "i",
        expr = true,
        desc = "Goto/Apply next edit suggestion",
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle()
        end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").select()
        end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function()
          require("sidekick.cli").close()
        end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function()
          require("sidekick.cli").send({ msg = "{this}" })
        end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function()
          require("sidekick.cli").send({ msg = "{file}" })
        end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function()
          require("sidekick.cli").send({ msg = "{selection}" })
        end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").prompt()
        end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
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

      table.insert(
        opts.sections.lualine_x,
        3,
        Utils.lualine.status(" ", function()
          local status = require("sidekick.status").cli()
          if status == 0 then
            return nil
          end
          return "ok"
        end)
      )
    end,
  },
}
