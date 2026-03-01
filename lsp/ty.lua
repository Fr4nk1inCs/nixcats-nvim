---@type vim.lsp.Config
return {
  settings = {
    ty = {
      diagnosticMode = "workspace",
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
      completions = {
        autoImport = true,
      },
    },
  },
}
