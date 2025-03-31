vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client.name == "ltex" then
      require("ltex_extra").setup({
        load_langs = { "en-US", "zh-CN" },
        path = ".ltex",
      })
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "barreiroleo/ltex_extra.nvim",
        ft = { "markdown", "tex" },
      },
    },
    opts = {
      servers = {
        ltex = {
          settings = {},
        },
      },
    },
  },
}
