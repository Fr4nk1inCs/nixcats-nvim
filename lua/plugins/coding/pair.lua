return {
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
    "saghen/blink.pairs",
    version = require("nixCatsUtils").lazyAdd("*"),
    dependencies = require("nixCatsUtils").lazyAdd("saghen/blink.download"),
    opts = {
      mappings = {
        enabled = true,
      },
      highlights = {
        enabled = true,
        -- requires require('vim._extui').enable({}), otherwise has no effect
        -- cmdline = false,
        groups = {
          "rainbowcol1",
          "rainbowcol2",
          "rainbowcol3",
          "rainbowcol4",
          "rainbowcol5",
          "rainbowcol6",
          "rainbowcol7",
        },
        matchparen = { enabled = true, group = "MatchParen" },
      },
    },
  },
}
