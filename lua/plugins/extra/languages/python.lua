local debugpy_python = nixCats("debugpy_python")
if not debugpy_python then
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  debugpy_python = root .. "/packages/debugpy/venv/bin/python"
  if not vim.uv.fs_stat(debugpy_python) and not require("lazy.core.config").headless() then
    Snacks.notify.warn([[Mason package path not found for **debugpy**:
- `/venv/bin/python`
You may need to force update the package.]])
  end
end

local function dap_python(command)
  return function()
    require("dap-python")[command]()
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", dap_python("test_method"), desc = "Debug Method", ft = "python" },
        { "<leader>dPc", dap_python("test_class"),  desc = "Debug Class",  ft = "python" },
      },
      config = function()
        require("dap-python").setup(debugpy_python)
      end,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "debugpy" } },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      handlers = {
        python = function() end,
      },
    },
  },
}
