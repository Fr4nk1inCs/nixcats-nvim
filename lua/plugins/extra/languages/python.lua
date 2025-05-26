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
        local python = nixCats("debugpy_python")
        if not python then
          pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
          local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
          python = root .. "/packages/debugpy/venv/bin/python"
          if not vim.uv.fs_stat(python) and not require("lazy.core.config").headless() then
            vim.notify(
              "Mason package path not found for **debugpy**:\n"
                .. "- `/venv/bin/python`\n"
                .. "You may need to force update the package.",
              vim.log.levels.WARN
            )
          end
        end
        require("dap-python").setup(python)
      end,
    },
  },
  {
    "mason-org/mason.nvim",
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
