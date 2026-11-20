local M = {}

---Synchronously request code actions of `kind` from `client` and apply them.
---@param client vim.lsp.Client
---@param bufnr integer
---@param kind lsp.CodeActionKind
---@param timeout_ms integer
M.code_action_sync = function(client, bufnr, kind, timeout_ms)
  local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
  ---@diagnostic disable-next-line: inject-field
  params.context = { only = { kind }, diagnostics = {} } -- `diagnostics` is required by the spec

  local resp = client:request_sync("textDocument/codeAction", params, timeout_ms, bufnr)
  for _, action in ipairs(resp and resp.result or {}) do
    if not action.edit and client:supports_method("codeAction/resolve") then
      local resolved = client:request_sync("codeAction/resolve", action, timeout_ms, bufnr)
      action = resolved and resolved.result or action
    end

    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

return M
