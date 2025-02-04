--- This extends a deeply nested list with a key in a table
--- that is a dot-separated string.
--- The nested list will be created if it does not exist.
---@generic T
---@param t T[]
---@param key string
---@param values T[]
---@return T[]?
local function extend(t, key, values)
  local keys = vim.split(key, ".", { plain = true })
  for i = 1, #keys do
    local k = keys[i]
    t[k] = t[k] or {}
    if type(t) ~= "table" then
      return
    end
    t = t[k]
  end
  return vim.list_extend(t, values)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "astro", "css" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = {},
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local path = nixCats("astro_ts_plugin")
      if not path then
        pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
        local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
        path = root .. "/packages/astro-language-server/node_modules/@astrojs/ts-plugin"
        if not vim.uv.fs_stat(path) and not require("lazy.core.config").headless() then
          vim.notify(
            "Mason package path not found for **astro-language-server**:\n"
              .. "- `/node_modules/@astrojs/ts-plugin`\n"
              .. "You may need to force update the package.",
            vim.log.levels.WARN
          )
        end
      end

      extend(opts.servers, "vtsls.settings.vtsls.tsserver.globalPlugins", {
        {
          name = "@astrojs/ts-plugin",
          location = path,
          enableForWorkspaceTypeScriptVersions = true,
        },
      })
    end,
  },
}
