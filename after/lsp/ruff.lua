---@type vim.lsp.Config
return {
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = {
      logLevel = "error",
    },
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.hoverProvider = false

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.code_action({
          context = { diagnostics = {}, only = { "source.organizeImports" } },
          apply = true,
        })
      end,
    })
  end,
}
