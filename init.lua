-- NOTE: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require("nixCatsUtils").setup({
  non_nix_value = true,
})

require("utils")
require("config.languages")
require("config.after")
require("config.autocmds")
require("config.options")

-- NOTE: You might want to move the lazy-lock.json file
local function get_lockfile_path()
  if require("nixCatsUtils").isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
    return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
  else
    return vim.fn.stdpath("config") .. "/lazy-lock.json"
  end
end
local lazyOptions = {
  lockfile = get_lockfile_path(),
  install = { colorscheme = { "nordfox" } },
  ui = { border = "rounded" },
}

-- NOTE: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
  },
  { import = "plugins" },
}, lazyOptions)

require("config.lsp")
require("config.keymaps")

if vim.g.neovide then
  require("config.neovide")
end
