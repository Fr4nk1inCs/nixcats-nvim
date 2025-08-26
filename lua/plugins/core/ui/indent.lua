return {
  {
    "saghen/blink.indent",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    ---@module "blink.indent"
    ---@type blink.indent.Config
    opts = {
      static = {
        char = "▏",
      },
      scope = {
        enabled = true,
        char = "▏",
        highlights = {
          "TSRainbowRed",
          "TSRainbowYellow",
          "TSRainbowBlue",
          "TSRainbowOrange",
          "TSRainbowGreen",
          "TSRainbowViolet",
          "TSRainbowCyan",
        },
        underline = {
          enabled = true,
        },
      },
    },
    config = function(_, opts)
      local scope_hls = opts.scope.highlights

      vim.tbl_map(function(hl)
        local color = vim.api.nvim_get_hl(0, { name = hl }).fg
        vim.api.nvim_set_hl(0, hl .. "Underline", { underline = true, sp = color })
      end, scope_hls)

      opts.scope.underline.highlights = vim.tbl_map(function(hl)
        return hl .. "Underline"
      end, scope_hls)

      require("blink.indent").setup(opts)
    end,
  },
}
