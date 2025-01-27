return {
  {
    "mistricky/codesnap.nvim",
    build = require("nixCatsUtils").lazyAdd("make", nil),
    opts = {
      save_path = "~/Pictures",
      has_breadcrumbs = true,
      bg_theme = "sea",
      code_font_family = "Maple Mono NF CN",
      watermark = "",
      bg_padding = 20,
    },
  },
}
