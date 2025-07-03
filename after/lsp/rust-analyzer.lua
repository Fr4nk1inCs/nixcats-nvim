return {
  on_attach = function(_, bufnr)
    vim.keymap.set("n", "gra", function()
      vim.cmd.RustLsp("codeAction")
    end, { desc = "Code Action", buffer = bufnr })
    vim.keymap.set("n", "<leader>dr", function()
      vim.cmd.RustLsp("debuggables")
    end, { desc = "Rust Debuggables", buffer = bufnr })
    vim.keymap.set("n", "K", function()
      vim.cmd.RustLsp({ "hover", "actions" })
    end, { desc = "Rust hover actions", silent = true, buffer = bufnr })
    vim.keymap.set("n", "<leader>cD", function()
      vim.cmd.RustLsp("explainError")
    end, { desc = "Rust explain error", buffer = bufnr })
  end,
  default_settings = {
    -- rust-analyzer language server configuration
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
      },
      -- Add clippy lints for Rust if using rust-analyzer
      checkOnSave = true,
      -- Enable diagnostics if using rust-analyzer
      diagnostics = {
        enable = true,
      },
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
      files = {
        excludeDirs = {
          ".direnv",
          ".git",
          ".github",
          ".gitlab",
          "bin",
          "node_modules",
          "target",
          "venv",
          ".venv",
        },
      },
    },
  },
}
