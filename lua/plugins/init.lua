vim.lsp.enable(LangSettings.lsps)

return {
  LangSettings.lazy,
  { import = "plugins.editor" },
  { import = "plugins.ui" },
  { import = "plugins.coding" },
  { import = "plugins.protocols" },
}
