if not vim.g.vscode then
  return {}
end

local enabled = {
  "lazy.nvim",
  "flash.nvim",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-context-commentstring",
  "snacks.nvim",
  "ts-comments.nvim",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
  return vim.tbl_contains(enabled, plugin.name)
end
vim.g.snacks_animate = false

-- Add some vscode specific keymaps
-- VSCode-specific keymaps for search and navigation
vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

-- Keep undo/redo lists in sync with VsCode
vim.keymap.set("n", "u", "<Cmd>call VSCodeNotify('undo')<CR>")
vim.keymap.set("n", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")

-- Navigate VSCode tabs like lazyvim buffers
vim.keymap.set("n", "<S-h>", "<Cmd>call VSCodeNotify('workbench.action.previousEditor')<CR>")
vim.keymap.set("n", "<S-l>", "<Cmd>call VSCodeNotify('workbench.action.nextEditor')<CR>")

Utils.terminal.toggle = function()
  require("vscode").action("workbench.action.terminal.toggleTerminal")
end

vim.notify = require("vscode").notify

return {
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = false },
      dashboard = { enabled = false },
      indent = { enabled = false },
      input = { enabled = false },
      notifier = { enabled = false },
      picker = { enabled = false },
      quickfile = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { highlight = { enable = false } },
  },
}
