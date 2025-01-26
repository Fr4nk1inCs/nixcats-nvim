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
