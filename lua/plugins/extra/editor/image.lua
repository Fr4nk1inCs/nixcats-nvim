return {
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      image = {
        enabled = true,

        math = {
          typst = {
            tpl = [[
              #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
              #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
              #show math.equation: set text(font: "Libertinus Math")
              #set text(size: 12pt, fill: rgb("${color}"))
              ${header}
              ${content}]],
          },
        },
      },
    },
  },
}
