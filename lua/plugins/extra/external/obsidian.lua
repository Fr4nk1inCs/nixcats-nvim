local system = Utils.get_system()

local prefix_path = ({
  mac = vim.fn.expand("~/OneDrive"),
  wsl = "/mnt/c/Users/fushen/OneDrive",
  linux = vim.fn.expand("~/OneDrive"),
})[system]

local vaults = {
  "profession",
  "life",
}

local workspaces = {}
local trigger_events = {}
for _, vault in ipairs(vaults) do
  local path = vim.fs.joinpath(prefix_path, vault)
  if vim.fn.isdirectory(path) == 1 then
    table.insert(workspaces, {
      name = vault,
      path = path,
    })
    table.insert(trigger_events, "BufReadPre " .. path .. "/*.md")
  end
end

if #workspaces == 0 then
  return {}
end

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    events = trigger_events,
    cmd = { "ObsidianWorkspace" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ibhagwan/fzf-lua",
    },
    opts = {
      workspaces = workspaces,
      notes_subdir = "concepts",

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '202502281401-my-new-note', and therefore the file name '202502281401-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date("%Y%m%d%H%M")) .. "-" .. suffix
      end,

      templates = {
        folder = "__meta/templates",
      },

      picker = {
        name = "fzf-lua",
      },

      attachments = {
        img_folder = "__meta/attachments",
      },

      ui = {
        enable = false,
      },

      -- see below for full list of options 👇
    },
  },
}
