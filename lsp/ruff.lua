local black_format_code = vim.tbl_contains(LangSettings, "black")
local isort_format_imports = vim.tbl_contains(LangSettings, "isort")

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
    if black_format_code then
      client.server_capabilities.documentFormattingProvider = false
    end

    if not isort_format_imports then
      vim.b[bufnr].custom_autofmt = true
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function(event)
          if Utils.autofmt.get(event.buf) then
            vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 5000 })
            Utils.lsp.code_action_sync(client, event.buf, "source.organizeImports", 2000)
          end
        end,
      })
    end
  end,
}
