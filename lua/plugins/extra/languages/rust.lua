local lsp_pick = function(command)
  return function()
    require("fzf-lua")[command]({ jump1 = true, ignore_current_line = true })
  end
end

return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", silent = true, bufnr = bufnr })
          vim.keymap.set(
            "n",
            "gK",
            vim.lsp.buf.signature_help,
            { desc = "Signature help", silent = true, bufnr = bufnr }
          )
          vim.keymap.set(
            "i",
            "<c-s>",
            vim.lsp.buf.signature_help,
            { desc = "Signature help", silent = true, bufnr = bufnr }
          )
          vim.keymap.set(
            { "n", "v" },
            "<leader>cc",
            vim.lsp.codelens.run,
            { desc = "Run codelens", silent = true, bufnr = bufnr }
          )
          vim.keymap.set(
            { "n", "v" },
            "<leader>cC",
            vim.lsp.codelens.refresh,
            { desc = "Refresh codelens", silent = true, bufnr = bufnr }
          )
          vim.keymap.set(
            "n",
            "gd",
            lsp_pick("lsp_definitions"),
            { desc = "Goto definition", silent = true, bufnr = bufnr }
          )
          vim.keymap.set("n", "gr", lsp_pick("lsp_references"), { desc = "References", silent = true, bufnr = bufnr })
          vim.keymap.set(
            "n",
            "gI",
            lsp_pick("lsp_implementations"),
            { desc = "Goto implementation", silent = true, bufnr = bufnr }
          )
          vim.keymap.set(
            "n",
            "gy",
            lsp_pick("lsp_typedefs"),
            { desc = "Goto t[y]pe definition", silent = true, bufnr = bufnr }
          )

          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          if client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
              buffer = bufnr,
              callback = vim.lsp.codelens.refresh,
            })
          end

          vim.keymap.set("n", "<leader>ca", function()
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
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      if vim.fn.executable("rust-analyzer") == 0 then
        Snacks.notify.error(
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          { title = "rustaceanvim" }
        )
      end
    end,
  },
}
