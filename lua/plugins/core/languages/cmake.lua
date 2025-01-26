return {
  {
    "Civitasv/cmake-tools.nvim",
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load({ plugins = { "cmake-tools.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        neocmake = {},
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = {
      sources = {
        require("null-ls").builtins.diagnostics.cmake_lint,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "cmakelint" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "cmake" },
    },
  },
}
