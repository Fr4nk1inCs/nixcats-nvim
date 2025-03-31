return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    ---@class PluginLspOpts
    opts = {
      servers = {},
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = true,
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = true,
      },
      -- add any global capabilities here
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:PluginLspOpts):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup keymaps
      local lsp_pick = function(command)
        return function()
          require("fzf-lua")[command]({ jump_to_single_result = true, ignore_current_line = true })
        end
      end

      local servers = opts.servers

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
          vim.keymap.set({ "n", "v" }, "grc", vim.lsp.codelens.run, { desc = "Run codelens" })
          vim.keymap.set({ "n", "v" }, "grc", vim.lsp.codelens.refresh, { desc = "Refresh codelens" })
          vim.keymap.set("n", "gd", lsp_pick("lsp_definitions"), { desc = "Goto definition" })
          vim.keymap.set("n", "grr", lsp_pick("lsp_references"), { desc = "References" })
          vim.keymap.set("n", "gri", lsp_pick("lsp_implementations"), { desc = "Goto implementation" })
          vim.keymap.set("n", "gry", lsp_pick("lsp_typedefs"), { desc = "Goto t[y]pe definition" })
          vim.keymap.set("n", "gO", require("fzf-lua").lsp_document_symbols, { desc = "Document symbol" })
          vim.keymap.set("n", "gwO", require("fzf-lua").lsp_live_workspace_symbols, { desc = "Workspace symbol" })

          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

          if client.server_capabilities.foldingRangeProvider then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
          end

          if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end

          if client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
              buffer = bufnr,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspDetach", { command = "setl foldexpr<" })

      local blink = require("blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        blink.get_lsp_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            require("lazy.core.plugin").values(
              require("lazy.core.config").spec.plugins["mason-lspconfig.nvim"],
              "opts",
              false
            ).ensure_installed or {}
          ),
          handlers = { setup },
        })
      end
    end,
  },
  {
    "mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      enabled = require("nixCatsUtils").lazyAdd(true, false),
      config = function() end,
    },
    enabled = require("nixCatsUtils").lazyAdd(true, false),
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {},
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "folke/snacks.nvim",
    opts = {
      words = { enabled = true },
    },
  },
}
