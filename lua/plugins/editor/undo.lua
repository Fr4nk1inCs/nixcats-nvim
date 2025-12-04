return {
  {
    "XXiaoA/atone.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    cmd = "Atone",
    opts = {
      layout = {
        direction = "right",
      },
    },
  },
}
