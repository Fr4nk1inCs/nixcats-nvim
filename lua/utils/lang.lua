---@class LanguageConfig
---@field lsp? string|string[] LSP server name(s) used for this language.
---@field treesitter? string|string[] Treesitter parser(s) used for this language.
---@field mason? string|string[] Mason package(s) used for this language.
---@field formatter? string|string[] Formatter(s) used for this language.
---@field linter? string|string[] Linter(s) used for this language.
---@field code_action? string|string[] Code action(s) used for this language.
---@field plugin? LazyPluginSpec[] Special plugin(s) used for this language.

---@class NoneLsConfig
---@field formatting string[]
---@field diagnostics string[]
---@field code_actions string[]
local NoneLsConfig = {}

---@return NoneLsConfig
function NoneLsConfig:new()
  local obj = {
    formatting = {},
    diagnostics = {},
    code_actions = {},
  }
  setmetatable(obj, self)
  self.__index = self
  return obj
end

---@param kind "formatting"|"diagnostics"|"code_actions"
function NoneLsConfig:_to_source(kind)
  return vim.tbl_map(function(name)
    return require("null-ls").builtins[kind][name]
  end, self[kind])
end

function NoneLsConfig:resolve()
  if self._sources then
    return self._sources
  end
  self._sources = {}
  vim.list_extend(self._sources, self:_to_source("formatting"))
  vim.list_extend(self._sources, self:_to_source("diagnostics"))
  vim.list_extend(self._sources, self:_to_source("code_actions"))
  return self._sources
end

---@class MergedConfig
---@field lsps string[] LSP server names.
---@field treesitters string[] Treesitter parser names.
---@field none_ls NoneLsConfig none-ls configurations
---@field mason string[] Mason package names.
---@field lazy LazyPluginSpec[] Special plugin specifications.

local M = {}

---@param lst string[]
---@param val nil|string|string[]
local function extend(lst, val)
  if val == nil then
    return
  end
  if vim.islist(val) then
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.list_extend(lst, val)
  else
    vim.list_extend(lst, { val })
  end
end

---@param configurations table<string, LanguageConfig>
M.merge = function(configurations)
  ---@type MergedConfig
  local merged = {
    lsps = {},
    treesitters = {},
    mason = {},
    none_ls = NoneLsConfig:new(),
    lazy = {},
  }

  for _, config in pairs(configurations) do
    extend(merged.lsps, config.lsp)
    extend(merged.treesitters, config.treesitter)
    extend(merged.mason, config.mason)
    extend(merged.lazy, config.plugin)

    extend(merged.none_ls.formatting, config.formatter)
    extend(merged.none_ls.diagnostics, config.linter)
    extend(merged.none_ls.code_actions, config.code_action)
  end

  merged.lsps = Utils.dedup(merged.lsps)
  merged.treesitters = Utils.dedup(merged.treesitters)
  merged.mason = Utils.dedup(merged.mason)

  merged.none_ls.formatting = Utils.dedup(merged.none_ls.formatting)
  merged.none_ls.diagnostics = Utils.dedup(merged.none_ls.diagnostics)
  merged.none_ls.code_actions = Utils.dedup(merged.none_ls.code_actions)

  return merged
end

local LOCAL_CONFIG = ".langconfig.lua"

local function check_config(config)
  if type(config) ~= "table" then
    vim.notify("Project local config must return a table, got " .. type(config) .. " instead.", vim.log.levels.ERROR)
    return false
  end
  return true
end

---@return table<string, LanguageConfig>?
M.resolve_local = function()
  local read_config = vim.secure.read(LOCAL_CONFIG)
  if read_config == true then
    vim.notify("Project local config does not support directorys. Please use a file.", vim.log.levels.ERROR)
    return nil
  elseif read_config == nil then
    return nil
  end

  assert(type(read_config) == "string", "Expected string from `vim.secure.read`, got " .. type(read_config))

  local config_fn, err_msg = load(read_config)
  if not config_fn then
    vim.notify("Error parsing project local config: " .. err_msg, vim.log.levels.ERROR)
    return nil
  end

  local ok, config = pcall(config_fn)
  if not ok then
    vim.notify("Error loading project local config: " .. config, vim.log.levels.ERROR)
    return nil
  end

  if not check_config(config) then
    return nil
  end

  return config
end

return M
