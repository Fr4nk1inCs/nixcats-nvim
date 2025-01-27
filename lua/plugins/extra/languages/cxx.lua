local command = vim.fn.exepath("lldb-dap")
if command == "" then
  Snacks.notify("LLDB is not installed, please install it to use the C/C++ debugger", "error")
  return {}
end

return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    -- dependencies = {
    --   -- Ensure C/C++ debugger is installed
    --   "williamboman/mason.nvim",
    --   optional = true,
    --   opts = { ensure_installed = { "lldb" } },
    -- },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["lldb"] then
        require("dap").adapters["lldb"] = {
          type = "executable",
          command = command,
        }
      end
      for _, lang in ipairs({ "c", "cpp" }) do
        dap.configurations[lang] = {
          {
            type = "lldb",
            request = "launch",
            name = "Launch file",
            program = function()
              return vim.fn.input("Path to executable (compiled with -gdwarf-4): ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            runInTerminal = true,
          },
          {
            type = "lldb",
            request = "attach",
            name = "Attach to process",
            pid = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end
    end,
  },
}
