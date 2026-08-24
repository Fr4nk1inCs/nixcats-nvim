---@type LazySpec[]
return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "echasnovski/mini.icons" },
    opts = {},
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
