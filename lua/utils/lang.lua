---@class LanguageConfig
---@field lsp string|string[] LSP server name(s) used for this language.
---@field treesitter string|string[] Treesitter parser(s) used for this language.
---@field mason string|string[] Mason package(s) used for this language.
---@field formatter? string|string[] Formatter(s) used for this language.
---@field linter? string|string[] Linter(s) used for this language.
---@field code_action? string|string[] Code action(s) used for this language.
---@field plugin? LazyPluginSpec[] Special plugin(s) used for this language.

---@class MergedConfig
---@field lsps string[] LSP server names.
---@field treesitters string[] Treesitter parser names.
---@field mason string[] Mason package names.
---@field formatters string[] Formatter names.
---@field linters string[] Linter names.
---@field code_actions string[] Code action names.
---@field plugins LazyPluginSpec[] Special plugin specifications.

local M = {}

---@param value string|string[]
---@return string[]
local function toarray(value)
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(value) == "string" and { value } or value
end

---@param configurations table<string, LanguageConfig>
M.merge = function(configurations)
  local merged = {
    lsps = {},
    treesitters = {},
    mason = {},
    formatters = {},
    linters = {},
    code_actions = {},
    plugins = {},
  }

  for _, config in pairs(configurations) do
    vim.list_extend(merged.lsps, toarray(config.lsp))
    vim.list_extend(merged.treesitters, toarray(config.treesitter))
    vim.list_extend(merged.mason, toarray(config.mason))
    if config.formatter then
      vim.list_extend(merged.formatters, toarray(config.formatter))
    end
    if config.linter then
      vim.list_extend(merged.linters, toarray(config.linter))
    end
    if config.code_action then
      vim.list_extend(merged.code_actions, toarray(config.code_action))
    end
    if config.plugin then
      vim.list_extend(merged.plugins, config.plugin)
    end
  end

  for key, value in pairs(merged) do
    merged[key] = Utils.dedup(value)
  end

  return merged
end

---@param merged MergedConfig
---@return any[]
M.none_ls = function(merged)
  local sources = {}
  vim.list_extend(
    sources,
    vim.tbl_map(function(name)
      return require("null-ls").builtins.formatting[name]
    end, merged.formatters)
  )
  vim.list_extend(
    sources,
    vim.tbl_map(function(name)
      return require("null-ls").builtins.diagnostics[name]
    end, merged.linters)
  )
  vim.list_extend(
    sources,
    vim.tbl_map(function(name)
      return require("null-ls").builtins.code_actions[name]
    end, merged.code_actions)
  )
  return sources
end

return M
