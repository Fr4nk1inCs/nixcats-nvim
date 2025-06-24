return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    ---@class PluginLspOpts
    opts = {},
    config = function(_, _) end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts_extend = { "sources" },
    opts = function(_, opts)
      opts.root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git")
      opts.sources = vim.list_extend(opts.sources or {}, LangSettings.none_ls:resolve())
    end,
  },
  {
    "mason-org/mason.nvim",
    enabled = require("nixCatsUtils").lazyAdd(true, false),
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    ---@module "mason"
    ---@type MasonSettings
    opts = {
      PATH = "append",
      ensure_installed = LangSettings.mason,
      github = { download_url_template = "https://ghfast.top/https://github.com/%s/releases/download/%s/%s" },
    },
    config = function(_, opts)
      local ensure_installed = opts.ensure_installed or {}
      opts.ensure_installed = nil

      require("mason").setup(opts)
      local Registry = require("mason-registry")

      local installed = Registry.get_installed_package_names()
      local missing = {}
      for _, pkg_name in ipairs(ensure_installed) do
        if not vim.tbl_contains(installed, pkg_name) then
          missing[#missing + 1] = { package = Registry.get_package(pkg_name), name = pkg_name }
        end
      end
      for _, pkg in ipairs(missing) do
        vim.notify(("Installing %s via mason.nvim..."):format(pkg.name))
        pkg.package:install(
          {},
          vim.schedule_wrap(function(success, err)
            if success then
              vim.notify(("%s was successfully installed via mason.nvim."):format(pkg.name))
            else
              vim.notify(("failed to install %s via mason.nvim.\n%s"):format(pkg.name, err), vim.log.levels.ERROR)
            end
          end)
        )
      end
    end,
  },
}
