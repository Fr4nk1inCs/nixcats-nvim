---@type LazyPluginSpec[]
return {
  {
    "mistricky/codesnap.nvim",
    enabled = false,
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
