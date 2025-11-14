local system = Utils.get_system()

local forwardSearch = {}

if system == "mac" then
  forwardSearch = {
    executable = (nixCats("skim") or "") .. "/Applications/Skim.app/Contents/SharedSupport/displayline",
    args = {
      "-g",
      "-r",
      "%l",
      "%p",
      "%f",
    },
  }
elseif system == "linux" then
  forwardSearch = {
    executable = "zathura",
    args = {
      "--synctex-forward",
      "%l:1:%f",
      "%p",
    },
  }
end

local use_xelatex = vim.env.USE_XELATEX or false
local build_args = {
  "-pdf",
  "-interaction=nonstopmode",
  "-synctex=1",
  "%f",
}
if use_xelatex then
  table.insert(build_args, 2, "-xelatex")
end

return {
  settings = {
    texlab = {
      build = {
        executable = "latexmk",
        args = build_args,
        onSave = true,
        forwardSearchAfter = true,
      },
      chktex = {
        onOpenAndSave = true,
        onEdit = true,
      },
      forwardSearch = forwardSearch,
    },
  },
}
