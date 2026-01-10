local black_format_code = vim.tbl_contains(LangSettings, "black")
local isort_format_imports = vim.tbl_contains(LangSettings, "isort")

---@param client vim.lsp.Client
---@param bufnr number
local organize_imports = function(client, bufnr, timeout_ms)
  local result, err = client:request_sync("codeAction/resolve", {
    data = vim.uri_from_bufnr(bufnr),
    kind = "source.organizeImports.ruff",
    title = "Ruff: Organize Imports",
  }, timeout_ms, bufnr)

  local err_msg = nil
  if result == nil or err then
    err_msg = err or "No result from Ruff organize imports"
  elseif result.err ~= nil then
    err_msg = result.err.message .. " [" .. result.err.code .. "]"
  else
    vim.lsp.util.apply_workspace_edit(result.result.edit, client.offset_encoding)
  end

  if err_msg ~= nil then
    vim.notify("Ruff organize imports error: " .. err_msg, vim.log.levels.ERROR)
  end
end

---@param event vim.api.keyset.create_autocmd.callback_args
---@param ruff_client vim.lsp.Client
local autofmt = function(event, ruff_client)
  if Utils.autofmt.get(event.buf) then
    vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 5000 })
    organize_imports(ruff_client, event.buf, 2000)
  end
end

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
          autofmt(event, client)
        end,
      })
    end
  end,
}
