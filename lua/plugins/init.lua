vim.lsp.enable(LangSettings.lsps)

return {
  LangSettings.lazy,
  { import = "plugins.coding" },
  { import = "plugins.debugger" },
  { import = "plugins.editor" },
  { import = "plugins.external" },
  { import = "plugins.protocols" },
  { import = "plugins.ui" },
}
