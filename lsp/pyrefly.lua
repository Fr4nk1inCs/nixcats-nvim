---@type vim.lsp.Config
return {
  init_options = {
    pyrefly = {
      displayTypeErrors = "force-on",
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
