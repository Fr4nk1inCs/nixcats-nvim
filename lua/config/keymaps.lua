local map = vim.keymap.set

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<c-h>", "<c-w>h", { desc = "Go to left window", remap = true })
map("n", "<c-j>", "<c-w>j", { desc = "Go to lower window", remap = true })
map("n", "<c-k>", "<c-w>k", { desc = "Go to upper window", remap = true })
map("n", "<c-l>", "<c-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<c-up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<c-down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<c-left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<c-right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines
map("n", "<a-d>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move down" })
map("n", "<a-u>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move up" })
map("i", "<a-d>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<a-u>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<a-d>", ":<c-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move down" })
map("v", "<a-u>", ":<c-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move up" })

-- Buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete.delete()
end, { desc = "Delete buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete other buffers" })
map("n", "<leader>ba", function()
  Snacks.bufdelete.all()
end, { desc = "Delete all buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete buffer and window" })

-- clear search and stop snippets on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd([[noh]])
  if vim.snippet then
    vim.snippet.stop()
  end
  return "<esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- Keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Location list & quickfix list
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Diagnostics
local function diag_next(severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.goto_next({ severity = severity })
  end
end

local function diag_prev(severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.goto_prev({ severity = severity })
  end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diag_next(), { desc = "Next diagnostics" })
map("n", "[d", diag_prev(), { desc = "Previous diagnostics" })
map("n", "]e", diag_next("ERROR"), { desc = "Next error" })
map("n", "[e", diag_prev("ERROR"), { desc = "Previous error" })
map("n", "]w", diag_next("WARN"), { desc = "Next warning" })
map("n", "[w", diag_prev("WARN"), { desc = "Previous warning" })

-- Terminal
map({ "n", "i", "t" }, "<c-\\>", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle (default/current/numbered) terminal" })
map({ "n", "i" }, "<c-/>", "2<c-\\>", { desc = "Toggle terminal 2", remap = true })
map("t", "<c-/>", "<cmd>close<cr>", { desc = "Hide terminal" })
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter normal mode" })

-- git & lazygit
map("n", "<leader>gb", function()
  Snacks.picker.git_log_line()
end, { desc = "Git blame line" })
map({ "n", "x" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git browse (open)" })
map({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg("+", url)
    end,
    notify = false,
  })
end, { desc = "Git browse (copy)" })
if vim.fn.executable("lazygit") == 1 then
  map("n", "<leader>gg", function()
    Snacks.lazygit()
  end, { desc = "Lazygit" })
  map("n", "<leader>gf", function()
    Snacks.picker.git_log_file()
  end, { desc = "Git Current File History" })
  map("n", "<leader>gl", function()
    Snacks.picker.git_log()
  end, { desc = "Git log" })
end

-- windows
map("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

-- toggle options
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.diagnostics():map("<leader>ud")
