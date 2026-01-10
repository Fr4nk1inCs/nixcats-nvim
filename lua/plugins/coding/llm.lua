---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      "folke/which-key.nvim",
      opts = {
        ---@module "which-key"
        ---@type wk.Spec
        spec = {
          {
            mode = { "n", "x" },
            { "<leader>o", group = "opencode" },
          },
        },
      },
    },
    config = function(_)
      ---@module "opencode"
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        provider = {
          enabled = "snacks",
        },
      }
      vim.o.autoread = true
    end,
    keys = {
      {
        "<leader>oa",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Ask Opencode",
      },
      {
        "<leader>os",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "Execute Opencode Action",
      },
      {
        "<leader>ou",
        function()
          require("opencode").command("session.half.page.up")
        end,
        mode = "n",
        desc = "Opencode Session Up",
      },
      {
        "<leader>od",
        function()
          require("opencode").command("session.half.page.down")
        end,
        mode = "n",
        desc = "Opencode Session Down",
      },
      {
        "<leader>or",
        function()
          return require("opencode").operator("@this ")
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Add range to Opencode",
      },
      {
        "<leader>ol",
        function()
          return require("opencode").operator("@this ") .. "_"
        end,
        mode = "n",
        expr = true,
        desc = "Add line to Opencode",
      },
      {
        "<c-o>",
        function()
          require("opencode").toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle Opencode",
      },
    },
  },
  {
    "folke/sidekick.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = { "Sidekick" },
    ---@module "sidekick"
    ---@type sidekick.Config
    opts = {},
    keys = {
      {
        "<c-tab>",
        function()
          require("sidekick").nes_jump_or_apply()
        end,
        desc = "Goto/Apply next edit suggestion",
      },
      {
        "<c-tab>",
        function()
          if require("sidekick").nes_jump_or_apply() then
            return "<c-tab>"
          end
        end,
        mode = "i",
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
        require("opencode").statusline,
      })
    end,
  },
}
