---@module "lspconfig"

---@type vim.lsp.Config
return {
  ---@type lspconfig.settings.zls
  settings = {
    zls = {
      inlay_hints_hide_redundant_param_names = true,
      inlay_hints_hide_redundant_param_names_last_token = true,
      warn_style = true,
    },
  },
  on_attach = function(client, bufnr)
    vim.b[bufnr].custom_autofmt = true
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function(event)
        if Utils.autofmt.get(event.buf) then
          vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 5000 })
          Utils.lsp.code_action_sync(client, event.buf, "source.organizeImports", 2000)
          Utils.lsp.code_action_sync(client, event.buf, "source.fixAll", 2000)
        end
      end,
    })
  end,
}
