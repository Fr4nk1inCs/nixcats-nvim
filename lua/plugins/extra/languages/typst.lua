local system = require("utils").get_system()

local open_cmd
if system == "mac" then
  open_cmd = "open"
elseif system == "linux" then
  open_cmd = "xdg-open"
elseif system == "wsl" then
  open_cmd = "wsl-open"
end

local dependencies_bin = {
  ["tinymist"] = nil,
  ["websocat"] = nil,
}
if vim.fn.executable("tinymist") == 1 then
  dependencies_bin["tinymist"] = vim.fn.exepath("tinymist")
end
if vim.fn.executable("websocat") == 1 then
  dependencies_bin["websocat"] = vim.fn.exepath("websocat")
end

return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {
      open_cmd = open_cmd .. " %s",
      dependencies_bin = dependencies_bin,
      get_root = function(path)
        return vim.fs.dirname(vim.fs.find(".git", { path = path, upward = true })[1]) or path
      end,
    },
  },
  {
    "kaarmu/typst.vim",
    ft = "typst",
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            exportPdf = "onDocumentHasTitle",
            formatterMode = "typstyle",
            semanticTokens = "disable",
            compileStatus = "disable",
          },
        },
      },
    },
  },
}
