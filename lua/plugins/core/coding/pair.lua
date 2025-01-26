return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      local rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      autopairs.add_rules({
        rule("$$", "$$", "tex"):with_pair(cond.not_after_regex("%%")),
        rule("$", "$", { "tex", "latex" }):with_pair(cond.not_after_regex("%%")):with_move(cond.none()),
        rule("$", "$", "typst"),
        rule("```", "```", "markdown"),
        rule("'", "'"):with_pair(cond.not_filetypes({ "rust", "vim" })),
      })
    end,
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertCharPre", -- Set the event to 'InsertCharPre' for better compatibility
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      act_as_tab = true,
      act_as_shift_tab = true,
      completion = true,
      tabouts = {
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "$", close = "}" },
      },
    },
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "lua", "latex", "verilog" },
        },
      },
    },
    config = function()
      vim.g.rainbow_delimiters = {
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
          latex = "rainbow-blocks",
          verilog = "rainbow-blocks",
          query = "rainbow-blocks",
        },
        highlight = {
          "TSRainbowRed",
          "TSRainbowYellow",
          "TSRainbowBlue",
          "TSRainbowOrange",
          "TSRainbowGreen",
          "TSRainbowViolet",
          "TSRainbowCyan",
        },
      }
    end,
  },
}
