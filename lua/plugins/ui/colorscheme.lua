return {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("base16-colorscheme").with_config({
      blink = false,
    })

    require("base16-colorscheme").setup({
      base00 = "#e5e9f0",
      base01 = "#c2d0e7",
      base02 = "#b8c5db",
      base03 = "#7b8aa3",
      base04 = "#60728c",
      base05 = "#2e3440",
      base06 = "#3b4252",
      base07 = "#29838d",
      base08 = "#99324b",
      base09 = "#ac4426",
      base0A = "#9a7500",
      base0B = "#4f894c",
      base0C = "#398eac",
      base0D = "#3b6ea8",
      base0E = "#97365b",
      base0F = "#5272af",
    })
  end,
}
