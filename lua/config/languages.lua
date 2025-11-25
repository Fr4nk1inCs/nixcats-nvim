---@type string[]
local must_installed_treesitter = {
  "diff",
  "html",
  "markdown",
  "markdown_inline",
  "printf",
  "query",
  "regex",
  "toml",
  "vim",
  "vimdoc",
  "xml",
}

---@type table<string, LanguageConfig>
local core = {
  lua = {
    lsp = "lua_ls",
    formatter = "stylua",
    mason = { "lua-language-server", "stylua" },
    treesitter = { "lua", "luadoc", "luap" },
    plugin = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
          library = {
            { path = (nixCats.nixCatsPath or "") .. "/lua", words = { "nixCats" } },
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "LazyVim", words = { "LazyVim" } },
            { path = "snacks.nvim", words = { "Snacks" } },
            { path = "lazy.nvim", words = { "LazyVim" } },
          },
        },
      },
    },
  },
  bash = {
    lsp = "bashls",
    treesitter = "bash",
    formatter = "shellharden",
    mason = { "bash-language-server", "shfmt", "shellharden", "shellcheck" },
  },
  cxx = {
    lsp = "clangd",
    treesitter = { "c", "cpp", "cuda" },
    mason = { "clangd" },
    plugin = {
      {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        config = function() end,
        opts = {
          inlay_hints = {
            inline = false,
          },
          ast = {
            --These require codicons (https://github.com/microsoft/vscode-codicons)
            role_icons = {
              type = "",
              declaration = "",
              expression = "",
              specifier = "",
              statement = "",
              ["template argument"] = "",
            },
            kind_icons = {
              Compound = "",
              Recovery = "",
              TranslationUnit = "",
              PackExpansion = "",
              TemplateTypeParm = "",
              TemplateTemplateParm = "",
              TemplateParamObject = "",
            },
          },
        },
      },
    },
  },
  cmake = {
    lsp = "neocmake",
    linter = "cmake_lint",
    treesitter = "cmake",
    mason = { "neocmakelsp", "cmakelang" },
    plugin = {
      {
        "Civitasv/cmake-tools.nvim",
        lazy = true,
        init = function()
          local loaded = false
          local function check()
            local cwd = vim.uv.cwd()
            if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
              require("lazy").load({ plugins = { "cmake-tools.nvim" } })
              loaded = true
            end
          end
          check()
          vim.api.nvim_create_autocmd("DirChanged", {
            callback = function()
              if not loaded then
                check()
              end
            end,
          })
        end,
        opts = {},
      },
    },
  },
  json_yaml = {
    lsp = { "jsonls", "yamlls" },
    treesitter = { "json", "jsonc", "json5", "yaml" },
    mason = { "json-lsp", "yaml-language-server" },
    plugin = {
      {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false, -- last release is way too old
      },
    },
  },
  python = {
    lsp = { "basedpyright", "ruff" },
    treesitter = { "python", "ninja", "rst" },
    formatter = { "black", "isort" },
    mason = { "basedpyright", "ruff", "black", "isort" },
  },
  copilot = {
    lsp = "copilot",
    mason = { "copilot-language-server" },
    treesitter = {},
  },
}
if vim.fn.executable("nix") == 1 then
  core.nix = {
    lsp = "nixd",
    linter = { "deadnix", "statix" },
    code_action = "statix",
    treesitter = "nix",
    mason = {},
  }
end

---@type table<string, LanguageConfig>
local extra = {
  astro = {
    lsp = "astro",
    treesitter = { "astro", "css" },
    mason = { "astro-language-server" },
  },
  dotfiles = {
    lsp = {},
    treesitter = { "git_config", "hyprlang", "fish", "rasi" },
    mason = {},
  },
  frontend = {
    lsp = { "vtsls", "cssls" },
    treesitter = { "html", "css", "javascript", "jsdoc" },
    formatter = "prettier",
    mason = { "vtsls", "css-lsp", "prettier" },
  },
  go = {
    lsp = "gopls",
    treesitter = { "go", "gomod", "gowork", "gosum" },
    formatter = { "gofumpt", "goimports" },
    code_action = { "gomodifytags", "impl" },
    mason = { "gopls", "delve", "goimports", "gofumpt", "gomodifytags", "impl" },
    plugin = {
      {
        "echasnovski/mini.icons",
        opts = {
          file = {
            [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
          },
          filetype = {
            gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
          },
        },
      },
    },
  },
  harper = {
    lsp = "harper_ls",
    mason = "harper-ls",
    treesitter = {},
  },
  latex = {
    lsp = "texlab",
    treesitter = { "bibtex", "latex" },
    mason = "texlab",
  },
  markdown = {
    lsp = "marksman",
    treesitter = { "markdown", "markdown_inline" },
    mason = { "marksman" },
    plugin = {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          code = {
            sign = false,
            width = "block",
            right_pad = 1,
            min_width = 45,
          },
          heading = { sign = false },
          html = { conceal = false },
          latex = { enabled = false },
        },
        ft = { "markdown", "norg", "rmd", "org" },
        config = function(_, opts)
          require("render-markdown").setup(opts)
          Snacks.toggle({
            name = "Render Markdown",
            get = function()
              return require("render-markdown.state").enabled
            end,
            set = function(enabled)
              local m = require("render-markdown")
              if enabled then
                m.enable()
              else
                m.disable()
              end
            end,
          }):map("<leader>um")
        end,
      },
    },
  },
  rust = {
    lsp = {},
    treesitter = { "rust", "ron" },
    mason = { "rust-analyzer" },
    plugin = {
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
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
        lazy = false,
        config = function(_, opts)
          vim.g.rustaceanvim = opts
        end,
      },
    },
  },
  toml = {
    lsp = "taplo",
    treesitter = "toml",
    mason = "taplo",
  },
  typescript = {
    lsp = "vtsls",
    treesitter = { "typescript", "tsx" },
    mason = { "vtsls" },
    plugin = {
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
    },
  },
  typst = {
    lsp = "tinymist",
    treesitter = "typst",
    mason = { "tinymist" },
    plugin = {
      {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        version = "1.*",
        opts = {
          dependencies_bin = {
            ["tinymist"] = vim.fn.executable("tinymist") == 1 and vim.fn.exepath("tinymist") or nil,
            ["websocat"] = vim.fn.executable("websocat") == 1 and vim.fn.exepath("websocat") or nil,
          },
          get_root = function(path)
            if vim.env["TYPST_ROOT"] then
              return vim.env["TYPST_ROOT"]
            end
            return vim.fs.dirname(vim.fs.find(".git", { path = path, upward = true })[1])
              or vim.fn.fnamemodify(path, ":p:h")
          end,
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        indent = {
          disable = { "typst" },
        },
      },
    },
  },
}

local merged_core = Utils.lang.merge(core)
merged_core.treesitters = Utils.dedup(vim.list_extend(merged_core.treesitters, must_installed_treesitter))
local merged_extra = Utils.lang.merge(extra)

_G.LangSettings = {
  core = merged_core,
  extra = merged_extra,
}
