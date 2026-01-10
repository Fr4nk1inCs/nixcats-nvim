vim.g.autoformat = true

local M = {}

---@param bufnr? integer
M.get = function(bufnr)
  if bufnr == nil or vim.b[bufnr].autoformat == nil then
    return vim.g.autoformat
  else
    return vim.b[bufnr].autoformat
  end
end

---@param global_state boolean
---@param buffer_state boolean
local function notify(global_state, buffer_state)
  local function make_line(name, state)
    local tick = "[" .. (state and "x" or " ") .. "]"
    local status = state and "**Enabled**" or "**Disabled**"
    return "- " .. tick .. " " .. name .. ": " .. status
  end

  local content = (
    "# Autoformat Status"
    .. "\n"
    .. make_line("Global", global_state)
    .. "\n"
    .. make_line("Buffer", buffer_state)
  )

  Snacks.notify[buffer_state and "info" or "warn"](
    content,
    { title = "Autoformat " .. (buffer_state and "Enabled" or "Disabled") }
  )
end

---@param state boolean
---@param bufnr integer
---@param global boolean
M.set = function(state, bufnr, global)
  if global then
    vim.g.autoformat = state
    vim.tbl_map(function(buf)
      vim.b[buf].autoformat = nil
    end, vim.api.nvim_list_bufs())
  else
    vim.b[bufnr].autoformat = state
  end
  notify(vim.g.autoformat, state)
end

return M
