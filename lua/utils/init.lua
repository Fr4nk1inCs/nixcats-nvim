local M = {}

M.norm = function(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then
      home = home:sub(1, -2)
    end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

M.dedup = function(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

---@param name string
M.opts = function(name)
  local plugin = require("lazy.core.config").spec.plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

M.is_loaded = function(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

M.get_system = function()
  if vim.fn.has("mac") == 1 then
    return "mac"
  elseif vim.fn.has("wsl") == 1 then
    return "wsl"
  elseif vim.fn.has("linux") == 1 then
    return "linux"
  end
end

return M
