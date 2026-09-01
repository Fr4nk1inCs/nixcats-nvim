---@module "lazy"
---@type LazySpec[]
return {
  ---@module "oil"
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "echasnovski/mini.icons" },
    ---@type oil.setupOpts
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-->"] = { "actions.select", opts = { horizontal = true } },
        ["<C-r>"] = "actions.refresh",
        ["q"] = { "actions.close", mode = "n" },
      },
      float = {
        padding = 5,
        border = "rounded",
      },
    },
    keys = {
      {
        "<leader>fo",
        function()
          require("oil").toggle_float()
        end,
        desc = "Toggle oil.nvim file explorer",
      },
      {
        "<leader>o",
        function()
          require("oil").toggle_float()
        end,
        desc = "Open oil.nvim file explorer",
      },
    },
  },
  ---@module "yazi"
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      {
        "<leader>fY",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>fy",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<leader>y",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume last yazi session",
      },
    },
    ---@type YaziConfig
    opts = {
      keymaps = {
        open_file_in_horizontal_split = "<c-h>",
        change_working_directory = "<c-d>",
      },
    },
  },
}
