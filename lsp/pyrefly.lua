---@type vim.lsp.Config
return {
  init_options = {
    pyrefly = {
      typeCheckingMode = "default",
      analysis = {
        inlayHints = {
          callArgumentNames = "partial",
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
        showHoverGoToLinks = false,
      },
    },
  },
}
