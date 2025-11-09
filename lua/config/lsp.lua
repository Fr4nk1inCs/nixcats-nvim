local fzf_goto = function(command)
  return function()
    require("fzf-lua")[command]({ jump1 = true, ignore_current_line = true })
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
    vim.keymap.set({ "n", "v" }, "grc", vim.lsp.codelens.run, { desc = "Run codelens" })
    vim.keymap.set({ "n", "v" }, "grc", vim.lsp.codelens.refresh, { desc = "Refresh codelens" })
    vim.keymap.set("n", "gd", fzf_goto("lsp_definitions"), { desc = "Goto definition" })
    vim.keymap.set("n", "grr", fzf_goto("lsp_references"), { desc = "References" })
    vim.keymap.set("n", "gri", fzf_goto("lsp_implementations"), { desc = "Goto implementation" })
    vim.keymap.set("n", "gry", fzf_goto("lsp_typedefs"), { desc = "Goto t[y]pe definition" })
    vim.keymap.set("n", "gO", require("fzf-lua").lsp_document_symbols, { desc = "Document symbol" })
    vim.keymap.set("n", "gwO", require("fzf-lua").lsp_live_workspace_symbols, { desc = "Workspace symbol" })

    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

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
        "<c-a>",
        vim.lsp.inline_completion.get,
        { desc = "LSP: accept inline completion", buffer = bufnr }
      )
      vim.keymap.set(
        "i",
        "<c-a>",
        vim.lsp.inline_completion.get,
        { desc = "LSP: accept inline completion", buffer = bufnr }
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
  virtual_text = { source = "if_many", spacing = 4 },
})

-- Formatting
vim.g.autoformat = true

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(event)
    if vim.g.autoformat == nil then
      vim.g.autoformat = true
    end
    local format = false
    if vim.b[event.buf].autoformat == nil then
      format = vim.g.autoformat
    else
      format = vim.b[event.buf].autoformat
    end
    if format then
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

local function toggle_format(bufonly)
  return Snacks.toggle({
    name = "autoformat (" .. (bufonly and "buffer" or "global") .. ")",
    get = function()
      local buf = vim.api.nvim_get_current_buf()
      if not bufonly or vim.b[buf].autoformat == nil then
        return vim.g.autoformat
      end
      return vim.b[buf].autoformat
    end,
    set = function(state)
      local buf = vim.api.nvim_get_current_buf()
      if bufonly then
        vim.b[buf].autoformat = state
      else
        vim.g.autoformat = state
        vim.b[buf].autoformat = nil
      end

      local global = vim.g.autoformat
      local buffer = state

      local lines = {
        "# Autoformat Status",
        "- [" .. (global and "x" or " ") .. "] Global: " .. (global and "**Enabled**" or "**Disabled**"),
        "- [" .. (buffer and "x" or " ") .. "] Buffer: " .. (buffer and "**Enabled**" or "**Disabled**"),
      }

      Snacks.notify[buffer and "info" or "warn"](
        table.concat(lines, "\n"),
        { title = "Autoformat " .. (buffer and "Enabled" or "Disabled") }
      )
    end,
  })
end

toggle_format(false):map("<leader>uF")
toggle_format(true):map("<leader>uf")
