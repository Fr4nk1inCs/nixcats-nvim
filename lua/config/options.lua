vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.markdown_recommended_style = 0

vim.opt.autowrite = true
vim.opt.colorcolumn = { "80", "120" }
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2
vim.opt.confirm = true -- Confirm to save before exiting modified buffer
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true -- Enable highlight of current line
vim.opt.expandtab = true -- Space instead of tabs
vim.opt.fileencodings = { "ucs-bom", "utf-8", "GB18030", "gbk" }
vim.opt.fillchars = {
  fold = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.foldenable = true
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldtext = ""
vim.opt.formatexpr = "v:lua.vim.lsp.formatexpr({ timeout_ms = 3000 })"
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit" -- Preview incremental substitute
vim.opt.incsearch = true
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 3 -- Global statusline
vim.opt.linebreak = true -- Wrap lines at convenient points
vim.opt.list = true -- Show some invisible characters
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.number = true -- Line number
vim.opt.pumblend = 0 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "globals",
  "help",
  "localoptions",
  "skiprtp",
  "tabpages",
  "winsize",
}
vim.opt.shiftround = true
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.showmode = false
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = "yes" -- Always show the signcolumn
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smoothscroll = true
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.undolevels = 100000
vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in virtual block mode
vim.opt.whichwrap = "<,>,h,l,[,]"
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false -- Disable line wrap
vim.opt.smoothscroll = true

vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.spelloptions:append("noplainbuffer")

vim.o.exrc = true
vim.o.modeline = true

if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
end
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    -- Install Neovim on host (Windows) to use faster global clipboard
    copy = {
      ["+"] = {
        "/mnt/c/Program Files/Neovim/bin/win32yank.exe",
        "-i",
        "--crlf",
      },
      ["*"] = {
        "/mnt/c/Program Files/Neovim/bin/win32yank.exe",
        "-i",
        "--crlf",
      },
    },
    paste = {
      ["+"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-o", "--lf" },
      ["*"] = { "/mnt/c/Program Files/Neovim/bin/win32yank.exe", "-o", "--lf" },
    },
    cache_enabled = 0,
  }
end

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

if vim.g.neovide then
  vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait1000-blinkoff500-blinkon500-Cursor/lCursor"

  vim.g.neovide_transparency = 0.9
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 7.0
  vim.g.neovide_floating_blur_amount_y = 7.0

  vim.g.neovide_show_border = true

  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_cursor_animation_length = 0.13
  vim.g.neovide_cursor_trail_size = 0.5

  vim.g.neovide_cursor_smooth_blink = true

  vim.g.neovide_hide_mouse_when_typing = true

  vim.g.neovide_remember_window_size = true

  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
  vim.g.neovide_input_ime = true
end
