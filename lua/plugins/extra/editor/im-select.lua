local system = require("utils").get_system()

local opts = {
  default_command = "",
  default_im_select = "",
}

local download = function(url, name)
  ---@diagnostic disable-next-line: param-type-mismatch
  local path = vim.fs.joinpath(vim.fn.stdpath("data"), "im-select")
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end

  path = vim.fs.joinpath(path, name)
  if vim.fn.filereadable(path) == 0 then
    vim.notify("Downloading " .. name, vim.log.levels.INFO, { title = "im-select.lua" })
    vim.system({ "curl", "-L", url, "-o", path }, {}, function()
      if vim.fn.filereadable(path) == 0 then
        vim.notify("Failed to download " .. name, vim.log.levels.ERROR, { title = "im-select.lua" })
      else
        vim.system({ "chmod", "+x", path })
        vim.notify("Downloaded " .. name, vim.log.levels.INFO, { title = "im-select.lua" })
      end
    end)
  end

  return path
end

if system == "mac" then
  local arch = vim.uv.os_uname().machine
  local url = "https://github.com/laishulu/macism/releases/latest/download/macism-" .. arch
  opts.default_command = download(url, "macism")
  opts.default_im_select = "com.apple.keylayout.ABC"
elseif system == "linux" then
  opts.default_command = "fcitx5-remote"
  opts.default_im_select = "keyboard-us"
elseif system == "wsl" then
  opts.default_command = download(
    "https://raw.githubusercontent.com/daipeihust/im-select/master/win-mspy/out/x64/im-select-mspy.exe",
    "im-select-mspy.exe"
  )
  opts.default_im_select = "英语模式"
end

return {
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    opts = opts,
  },
}
