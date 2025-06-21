vim.lsp.enable(LangSettings.core.lsps)

return {
  LangSettings.core.plugins,
  { import = "plugins.core.editor" },
  { import = "plugins.core.ui" },
  { import = "plugins.core.coding" },
  { import = "plugins.core.protocols" },
}
