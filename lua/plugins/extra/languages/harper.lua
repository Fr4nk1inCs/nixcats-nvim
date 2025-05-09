return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        harper_ls = {
          settings = {
            ["harper-ls"] = {
              userDictPath = "~/.cache/harper/user-dictionary.dict",
              fileDictPath = "~/.cache/harper/file-dictionary.dict",
              linters = {
                SentenceCapitalization = false,
                SpellCheck = false,
              },
            },
          },
        },
      },
    },
  },
}
