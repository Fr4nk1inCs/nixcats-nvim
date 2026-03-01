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
      local opencode_cmd = "opencode --port"
      ---@type snacks.terminal.Opts
      local st_opts = {
        win = {
          position = "right",
          enter = false,
          on_win = function(win)
            -- Set up keymaps and cleanup for an arbitrary terminal
            require("opencode.terminal").setup(win.win)
          end,
        },
      }
      ---@module "opencode"
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require("snacks.terminal").open(opencode_cmd, st_opts)
          end,
          stop = function()
            require("snacks.terminal").get(opencode_cmd, st_opts):close()
          end,
          toggle = function()
            require("snacks.terminal").toggle(opencode_cmd, st_opts)
          end,
        },
      }
      vim.o.autoread = true

      -- Handle `opencode` events
      vim.api.nvim_create_autocmd("User", {
        pattern = "OpencodeEvent:*", -- Optionally filter event types
        callback = function(args)
          ---@type opencode.cli.client.Event
          local event = args.data.event
          ---@type number
          local port = args.data.port

          -- See the available event types and their properties
          vim.notify(vim.inspect(event))
          -- Do something useful
          if event.type == "session.idle" then
            vim.notify("`opencode` finished responding")
          end
        end,
      })
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
        "<m-o>",
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
