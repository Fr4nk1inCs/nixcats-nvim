---@class pick.Opts
---@field cwd string?
---@field root boolean?
---@field buf number?
---@field [string] any

---@param command? string
---@param opts? pick.Opts
local function pick(command, opts)
  return function()
    command = command ~= "auto" and command or "files"
    opts = opts or {}
    opts = vim.deepcopy(opts)

    if command == "buffers" then
      opts.sort_mru = true
      opts.sort_lastused = true
    end

    if not opts.cwd and opts.root ~= false then
      opts.cwd = Utils.root({ buf = opts.buf })
    end

    require("fzf-lua")[command](opts)
  end
end

return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    event = "VeryLazy",
    opts = function(_, opts)
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      -- Trouble
      config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open

      -- Toggle root dir / cwd
      config.defaults.actions.files["ctrl-r"] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.buf = ctx.__CTX.bufnr

        o.cwd = o.root and Utils.root({ buf = o.buf }) or nil
        require("fzf-lua")[ctx.__INFO.cmd](o)
      end
      config.defaults.actions.files["alt-c"] = config.defaults.actions.files["ctrl-r"]
      config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return {
        "default-title",
        fzf_colors = true,
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        winopts = {
          width = 0.8,
          height = 0.8,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or "codeaction",
          },
        },
      }
    end,
    config = function(_, opts)
      if opts[1] == "default-title" then
        -- use the same prompt for all pickers for profile `default-title` and
        -- profiles that use `default-title` as base profile
        local function fix(t)
          t.prompt = t.prompt ~= nil and " " or nil
          for _, v in pairs(t) do
            if type(v) == "table" then
              fix(v)
            end
          end
          return t
        end
        opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
        opts[1] = nil
      end
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
    keys = {
      {
        "<c-j>",
        "<c-j>",
        ft = "fzf",
        mode = "t",
        nowait = true,
      },
      {
        "<c-k>",
        "<c-k>",
        ft = "fzf",
        mode = "t",
        nowait = true,
      },

      { "<leader>,", pick("buffers"), desc = "Switch Buffer" },
      { "<leader>/", pick("live_grep"), desc = "Grep (root)" },
      { "<leader>:", pick("command_history"), desc = "Command history" },
      { "<leader><space>", pick("files"), desc = "Find files (root)" },
      -- find
      { "<leader>fb", pick("buffers"), desc = "Buffers" },
      { "<leader>ff", pick("files"), desc = "Find files (root)" },
      { "<leader>fF", pick("files", { root = false }), desc = "Find files (cwd)" },
      { "<leader>fg", pick("git_files"), desc = "Find files (git-files)" },
      { "<leader>fr", pick("oldfiles"), desc = "Recent" },
      { "<leader>fR", pick("oldfiles", { root = false }), desc = "Recent (all)" },
      -- git
      { "<leader>gc", pick("git_commits"), desc = "Commits" },
      { "<leader>gs", pick("git_status"), desc = "Status" },
      -- search
      { '<leader>s"', pick("registers"), desc = "Registers" },
      { "<leader>sa", pick("autocmds"), desc = "Auto commands" },
      { "<leader>sb", pick("grep_curbuf"), desc = "Buffer" },
      { "<leader>sc", pick("command_history"), desc = "Command history" },
      { "<leader>sC", pick("commands"), desc = "Commands" },
      { "<leader>sd", pick("diagnostics_document"), desc = "Document diagnostics" },
      { "<leader>sD", pick("diagnostics_workspace"), desc = "Workspace diagnostics" },
      { "<leader>sg", pick("live_grep"), desc = "Grep (root)" },
      { "<leader>sG", pick("live_grep", { root = false }), desc = "Grep (cwd)" },
      { "<leader>sh", pick("help_tags"), desc = "Help pages" },
      { "<leader>sH", pick("highlights"), desc = "Search highlight groups" },
      { "<leader>sj", pick("jumps"), desc = "Jumplist" },
      { "<leader>sk", pick("keymaps"), desc = "Keymaps" },
      { "<leader>sl", pick("loclist"), desc = "Location list" },
      { "<leader>sM", pick("man_pages"), desc = "Man pages" },
      { "<leader>sm", pick("marks"), desc = "Jump to mark" },
      { "<leader>sR", pick("resume"), desc = "Resume" },
      { "<leader>sq", pick("quickfix"), desc = "Quickfix List" },
      { "<leader>sw", pick("grep_cword"), desc = "Word (root)" },
      { "<leader>sW", pick("grep_cword", { root = false }), desc = "Word (cwd)" },
      { "<leader>sw", pick("grep_visual"), desc = "Selection (root)", mode = "v" },
      { "<leader>sW", pick("grep_visual", { root = false }), desc = "Selection (cwd)", mode = "v" },
      { "<leader>uC", pick("colorschemes"), desc = "Colorscheme with preview" },
    },
  },
  {
    "folke/todo-comments.nvim",
    keys = {
      {
        "<leader>st",
        function()
          require("todo-comments.fzf").todo()
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}
