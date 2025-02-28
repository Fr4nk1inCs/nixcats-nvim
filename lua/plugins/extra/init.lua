if not require("nixCatsUtils").enableForCategory("extra", true) then
  return {}
end

return {
  { import = "plugins.extra.coding" },
  { import = "plugins.extra.editor" },
  { import = "plugins.extra.external" },
  { import = "plugins.extra.debug" },
  { import = "plugins.extra.languages" },
}
