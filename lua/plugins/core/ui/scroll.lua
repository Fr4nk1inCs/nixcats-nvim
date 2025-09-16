return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = not (vim.g.neovide or vim.env.SSH_TTY),
      },
    },
  },
}
