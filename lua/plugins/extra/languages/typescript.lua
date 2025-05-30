local function action(command)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { command },
        diagnostics = {},
      },
    })
  end
end

---@class keymapOpts
---@field [1] string lhs
---@field [2] string|function rhs
---@field desc? string

---lsp buflocal keymap
---@param bufnr number
---@param maps keymapOpts[]
local function keymap(bufnr, maps)
  for _, map in ipairs(maps) do
    vim.keymap.set("n", map[1], map[2], { buffer = bufnr, desc = map.desc })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client.name ~= "vtsls" then
      return
    end

    keymap(args.buf, {
      {
        "gD",
        function()
          local params = vim.lsp.util.make_position_params()
          require("trouble").open({
            mode = "lsp_command",
            params = {
              command = "typescript.goToSourceDefinition",
              arguments = { params.textDocument.uri, params.position },
            },
          })
        end,
        desc = "Goto Source Definition",
      },
      {
        "gR",
        function()
          require("trouble").open({
            mode = "lsp_command",
            params = {
              command = "typescript.findAllFileReferences",
              arguments = { vim.uri_from_bufnr(0) },
            },
          })
        end,
        desc = "File References",
      },
      {
        "<leader>co",
        action("source.organizeImports"),
        desc = "Organize Imports",
      },
      {
        "<leader>cM",
        action("source.addMissingImports.ts"),
        desc = "Add missing imports",
      },
      {
        "<leader>cu",
        action("source.removeUnused.ts"),
        desc = "Remove unused imports",
      },
      {
        "<leader>cD",
        action("source.fixAll.ts"),
        desc = "Fix all diagnostics",
      },
      {
        "<leader>cV",
        function()
          vim.lsp.buf_request(0, "workspace/executeCommand", {
            command = "typescript.selectTypeScriptVersion",
          })
        end,
        desc = "Select TS workspace version",
      },
    })

    client.commands["_typescript.moveToFileRefactoring"] = function(command, _)
      ---@type string, string, lsp.Range
      local _, uri, range = unpack(command.arguments)

      local function move(newf)
        client:request("workspace/executeCommand", {
          command = command.command,
          arguments = { action, uri, range, newf },
        })
      end

      local fname = vim.uri_to_fname(uri)
      client:request("workspace/executeCommand", {
        command = "typescript.tsserverRequest",
        arguments = {
          "getMoveToRefactoringFileSuggestions",
          {
            file = fname,
            startLine = range.start.line + 1,
            startOffset = range.start.character + 1,
            endLine = range["end"].line + 1,
            endOffset = range["end"].character + 1,
          },
        },
      }, function(_, result)
        ---@type string[]
        local files = result.body.files
        table.insert(files, 1, "Enter new path...")
        vim.ui.select(files, {
          prompt = "Select move destination:",
          format_item = function(f)
            return vim.fn.fnamemodify(f, ":~:.")
          end,
        }, function(f)
          if f and f:find("^Enter new path") then
            vim.ui.input({
              prompt = "Enter move destination:",
              default = vim.fn.fnamemodify(fname, ":h") .. "/",
              completion = "file",
            }, function(newf)
              return newf and move(newf)
            end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
      },
      setup = {
        vtsls = function(_, opts)
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },

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

  -- Filetype icons
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },
}
