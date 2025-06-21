return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "recommended",
        inlayHints = {
          callArgumentNames = "partial",
          functionReturnTypes = true,
          pytestParameters = true,
          variableTypes = true,
        },
      },
    },
  },
}
