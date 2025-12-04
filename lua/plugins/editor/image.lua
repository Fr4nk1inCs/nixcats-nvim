return {
  {
    "folke/snacks.nvim",
    ---@module "snacks"
    ---@type snacks.Config
    opts = {
      image = {
        enabled = true,
        doc = {
          inline = false,
          float = true,
        },
        math = {
          enabled = false,
        },
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = { "PasteImage" },
    opts = {},
    keys = {
      {
        "<leader>p",
        "<cmd>PasteImage<cr>",
        desc = "Paste image from system clipboard",
      },
    },
  },
}
