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
elseif system == "wsl" then
  forwardSearch = {
    executable = "/mnt/c/Users/fushen/AppData/Local/SumatraPDF/SumatraPDF.exe",
    args = {
      "-reuse-instance",
      "%p",
      "-forward-search",
      "%f",
      "%l",
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

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "bibtex", "latex" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              build = {
                executable = "latexmk",
                args = {
                  "-pdf",
                  -- "-xelatex",
                  "-interaction=nonstopmode",
                  "-synctex=1",
                  "%f",
                },
                onSave = true,
                forwardSearchAfter = system ~= "wsl",
              },
              chktex = {
                onOpenAndSave = true,
                onEdit = true,
              },
              forwardSearch = forwardSearch,
            },
          },
        },
      },
    },
  },
}
