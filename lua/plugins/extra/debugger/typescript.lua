return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ensure_installed = { "js-debug-adapter" },
        },
      },
    },
    opts = function()
      local dap_debug_server = nixCats("js_debug_server")
      if not dap_debug_server then
        pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
        local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
        dap_debug_server = root .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
        if not vim.uv.fs_stat(dap_debug_server) and not require("lazy.core.config").headless() then
          vim.notify(
            "Mason package path not found for **js-debug-adapter**:\n"
              .. "- `/js-debug/src/dapDebugServer.js`"
              .. "You may need to force update the package.",
            vim.log.levels.WARN
          )
        end
      end

      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              dap_debug_server,
              "${port}",
            },
          },
        }
      end
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },
}
