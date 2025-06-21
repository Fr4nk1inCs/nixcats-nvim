return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Ensure C/C++ debugger is installed
      "mason-org/mason.nvim",
      opts = { ensure_installed = { "codelldb" } },
    },
    opts = function()
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "executable",
        command = nixCats("codelldb") or "codelldb",
      }

      dap.configurations.c = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          runInTerminal = true,
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      dap = nixCats("codelldb") and {
        adapter = {
          type = "executable",
          command = nixCats("codelldb"),
          name = "codelldb",
        },
      } or nil,
    },
  },
}
