local astro_plugin_path = nixCats("astro_ts_plugin")
if not astro_plugin_path then
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  astro_plugin_path = root .. "/packages/astro-language-server/node_modules/@astrojs/ts-plugin"
  if not vim.uv.fs_stat(astro_plugin_path) and not require("lazy.core.config").headless() then
    vim.notify(
      "Mason package path not found for **astro-language-server**:\n"
        .. "- `/node_modules/@astrojs/ts-plugin`\n"
        .. "You may need to force update the package.",
      vim.log.levels.WARN
    )
  end
end

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

local lang_setting = {
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
}

return {
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
      globalPlugins = {
        {
          name = "@astrojs/ts-plugin",
          location = astro_plugin_path,
          enableForWorkspaceTypeScriptVersions = true,
        },
      },
    },
    typescript = lang_setting,
    javascript = lang_setting,
  },
  on_attach = function(client, bufnr)
    keymap(bufnr, {
      {
        "gD",
        function()
          ---@diagnostic disable-next-line: missing-parameter
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
              if newf then
                move(newf)
              end
            end)
          elseif f then
            move(f)
          end
        end)
      end)
    end
  end,
}
