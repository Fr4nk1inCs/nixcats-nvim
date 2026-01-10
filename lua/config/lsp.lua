local fzf_goto = function(command)
  return function()
    require("fzf-lua")[command]({ jump1 = true, ignore_current_line = true })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
    vim.keymap.set({ "n", "v" }, "grc", vim.lsp.codelens.run, { buffer = bufnr, desc = "Run codelens" })
    vim.keymap.set({ "n", "v" }, "grc", vim.lsp.codelens.refresh, { buffer = bufnr, desc = "Refresh codelens" })
    vim.keymap.set("n", "gd", fzf_goto("lsp_definitions"), { buffer = bufnr, desc = "Goto definition" })
    vim.keymap.set("n", "grr", fzf_goto("lsp_references"), { buffer = bufnr, desc = "References" })
    vim.keymap.set("n", "gri", fzf_goto("lsp_implementations"), { buffer = bufnr, desc = "Goto implementation" })
    vim.keymap.set("n", "grt", fzf_goto("lsp_typedefs"), { buffer = bufnr, desc = "Goto type definition" })
    vim.keymap.set("n", "gO", require("fzf-lua").lsp_document_symbols, { buffer = bufnr, desc = "Document symbol" })
    vim.keymap.set(
      "n",
      "gwO",
      require("fzf-lua").lsp_live_workspace_symbols,
      { buffer = bufnr, desc = "Workspace symbol" }
    )

    if client.server_capabilities.foldingRangeProvider then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = "expr"
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh()
      vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        buffer = args.buf,
        callback = vim.lsp.codelens.refresh,
      })
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
      vim.keymap.set(
        "i",
        "<c-tab>",
        vim.lsp.inline_completion.get,
        { desc = "LSP: accept inline completion", buffer = bufnr }
      )
      vim.keymap.set(
        "i",
        "<c-.>",
        vim.lsp.inline_completion.select,
        { desc = "LSP: switch inline completion", buffer = bufnr }
      )
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", { command = "setl foldexpr<" })

vim.diagnostic.config({
  float = { border = "rounded" },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  --- This config is also used in lua/config/keymaps.lua for diagnostic keymaps
  virtual_text = { source = "if_many", spacing = 4 },
})

-- Formatting
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspAutoformat", { clear = true }),
  callback = function(event)
    if Utils.autofmt.get(event.buf) and not vim.b[event.buf].custom_autofmt then
      vim.lsp.buf.format({ bufnr = event.buf, timeout_ms = 5000 })
    end
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  vim.lsp.buf.format({
    async = true,
    bufnr = vim.api.nvim_get_current_buf(),
  })
end, {
  desc = "Format (Async)",
})

---@param is_global boolean
local function toggle_autofmt(is_global)
  return Snacks.toggle({
    name = "autoformat (" .. (is_global and "global" or "buffer") .. ")",
    get = function()
      if is_global then
        return Utils.autofmt.get()
      else
        return Utils.autofmt.get(vim.api.nvim_get_current_buf())
      end
    end,
    set = function(state)
      local buf = vim.api.nvim_get_current_buf()
      return Utils.autofmt.set(state, buf, is_global)
    end,
  })
end

toggle_autofmt(true):map("<leader>uF")
toggle_autofmt(false):map("<leader>uf")
