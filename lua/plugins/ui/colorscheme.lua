---@param hex string
---@return number, number, number
local function hex2rgb(hex)
  local r = tonumber(hex:sub(2, 3), 16)
  local g = tonumber(hex:sub(4, 5), 16)
  local b = tonumber(hex:sub(6, 7), 16)
  return r, g, b
end

---@param r number
---@param g number
---@param b number
---@return string
local function rgb2hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function lighten(hex, percent)
  percent = 1 - percent
  local r, g, b = hex2rgb(hex)
  r = math.floor(r + (255 - r) * percent)
  g = math.floor(g + (255 - g) * percent)
  b = math.floor(b + (255 - b) * percent)
  return rgb2hex(r, g, b)
end

return {
  "RRethy/base16-nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("base16-nord-light")
    -- Fix the light theme diff colors
    -- Tracking issue: https://github.com/RRethy/base16-nvim/issues/119
    local colors = require("base16-colorscheme").colors

    local diff_add_bg = lighten(colors.base0B, 0.6)
    local diff_delete_bg = lighten(colors.base08, 0.6)
    local diff_change_bg = lighten(colors.base0A, 0.8)
    local diff_text_bg = lighten(colors.base0B, 0.7)

    --- @type table<string, vim.api.keyset.highlight>
    local highlights = {
      DiffAdd = { fg = nil, bg = diff_add_bg, ctermfg = nil, ctermbg = colors.cterm00 },
      DiffChange = {
        fg = nil,
        bg = diff_change_bg,
        ctermfg = nil,
        ctermbg = colors.cterm00,
      },
      DiffDelete = {
        fg = nil,
        bg = diff_delete_bg,
        ctermfg = nil,
        ctermbg = colors.cterm00,
      },
      DiffText = {
        fg = nil,
        bg = diff_text_bg,
        bold = true,
        ctermfg = nil,
        ctermbg = colors.cterm01,
      },
      DiffAdded = {
        fg = colors.base0B,
        bg = colors.base00,
        ctermfg = colors.cterm0B,
        ctermbg = colors.cterm00,
      },
      DiffFile = {
        fg = colors.base08,
        bg = colors.base00,
        ctermfg = colors.cterm08,
        ctermbg = colors.cterm00,
      },
      DiffNewFile = {
        fg = colors.base0B,
        bg = colors.base00,
        ctermfg = colors.cterm0B,
        ctermbg = colors.cterm00,
      },
      DiffLine = {
        fg = colors.base0D,
        bg = colors.base00,
        ctermfg = colors.cterm0D,
        ctermbg = colors.cterm00,
      },
      DiffRemoved = {
        fg = colors.base08,
        bg = colors.base00,
        ctermfg = colors.cterm08,
        ctermbg = colors.cterm00,
      },
    }

    for group, opts in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end,
}
