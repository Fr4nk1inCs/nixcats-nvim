---@module "lazy.nvim"
---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = require("nixCatsUtils").lazyAdd(":TSUpdate"),

    event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
    commands = { "TSLog", "TSUpdate", "TSInstall", "TSUninstall" },

    config = function()
      --- Install default parsers
      if require("nixCatsUtils").isNixCats then
        local langs = vim
          .iter(LangSettings.treesitters)
          :map(vim.treesitter.language.get_lang)
          :filter(function(lang)
            return not vim.treesitter.language.add(lang)
          end)
          :totable()
        require("nvim-treesitter").install(langs)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local ts = require("nvim-treesitter")
          local ft = args.match

          local lang = vim.treesitter.language.get_lang(ft)
          if lang == nil then
            return
          end

          if not require("nixCatsUtils").isNixCats and not vim.treesitter.language.add(lang) then
            if not vim.g.ts_available then
              vim.g.ts_available = ts.available_parsers()
            end
            if vim.tbl_contains(vim.g.ts_available, lang) then
              vim.notify(
                "Installing treesitter parser for " .. lang,
                vim.log.levels.INFO,
                { title = "nvim-treesitter" }
              )
              ts.install(lang)
            end
          end

          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      select = { lookahead = true },
      move = { set_jumps = true },
    },
    keys = function()
      local ts = vim._defer_require("nvim-treesitter-textobjects", {
        repeatable_move = {}, ---@module "nvim-treesitter.textobjects.repeatable_move"
        select = {}, ---@module "nvim-treesitter.textobjects.select"
        move = {}, ---@module "nvim-treesitter.textobjects.move"
      })

      return {
        {
          ";",
          function()
            ts.repeatable_move.repeat_last_move()
          end,
          mode = { "n", "x", "o" },
          desc = "Forward last move",
        },
        {
          ",",
          function()
            ts.repeatable_move.repeat_last_move_opposite()
          end,
          mode = { "n", "x", "o" },
          desc = "Backward last move",
        },
        {
          "af",
          function()
            ts.select.select_textobject("@function.outer")
          end,
          mode = { "o", "x" },
          desc = "Whole function",
        },
        {
          "if",
          function()
            ts.select.select_textobject("@function.inner")
          end,
          mode = { "o", "x" },
          desc = "Inner function",
        },
        {
          "ac",
          function()
            ts.select.select_textobject("@class.outer")
          end,
          mode = { "o", "x" },
          desc = "Whole class",
        },
        {
          "ic",
          function()
            ts.select.select_textobject("@class.inner")
          end,
          mode = { "o", "x" },
          desc = "Inner class",
        },
        {
          "aa",
          function()
            ts.select.select_textobject("@parameter.outer")
          end,
          mode = { "o", "x" },
          desc = "Whole parameter",
        },
        {
          "ia",
          function()
            ts.select.select_textobject("@parameter.inner")
          end,
          mode = { "o", "x" },
          desc = "Inner parameter",
        },
        {
          "]f",
          function()
            ts.move.goto_next_start("@function.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Next inner function",
        },
        {
          "]F",
          function()
            ts.move.goto_next_end("@function.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Next inner function end",
        },
        {
          "[f",
          function()
            ts.move.goto_previous_start("@function.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Previous inner function",
        },
        {
          "[F",
          function()
            ts.move.goto_previous_end("@function.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Previous inner function end",
        },
        {
          "]c",
          function()
            ts.move.goto_next_start("@class.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Next inner class",
        },
        {
          "]C",
          function()
            ts.move.goto_next_end("@class.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Next inner class end",
        },
        {
          "[c",
          function()
            ts.move.goto_previous_start("@class.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Previous inner class",
        },
        {
          "[C",
          function()
            ts.move.goto_previous_end("@class.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Previous inner class end",
        },
        {
          "]a",
          function()
            ts.move.goto_next_start("@parameter.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Next inner parameter",
        },
        {
          "]A",
          function()
            ts.move.goto_next_end("@parameter.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Next inner parameter end",
        },
        {
          "[a",
          function()
            ts.move.goto_previous_start("@parameter.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Previous inner parameter",
        },
        {
          "[A",
          function()
            ts.move.goto_previous_end("@parameter.inner")
          end,
          mode = { "n", "o", "x" },
          desc = "Previous inner parameter end",
        },
      }
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      mode = "topline",
      max_lines = 5,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
      vim.api.nvim_set_hl(0, "TreesitterContext", { link = "Normal" })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { link = "Underlined" })
    end,
    keys = {
      { "<leader>uc", "<cmd>TSContextToggle<cr>", desc = "Toggle treesitter context" },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {},
  },
}
