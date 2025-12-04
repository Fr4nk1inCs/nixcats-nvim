return {
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      render = "virtual",
    },
  },
}
