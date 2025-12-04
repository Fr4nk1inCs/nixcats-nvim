return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = {
      ignore = {
        filetypes = {
          "alpha",
          "dashboard",
          "lazy",
          "mason",
          "NvimTree",
          "neo-tree",
          "Outline",
          "toggleterm",
          "Trouble",
        },
      },
      render = function(props)
        local devicons = require("nvim-web-devicons")

        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        local ft_icon, ft_color = devicons.get_icon_color(filename)

        local function get_git_diff()
          local icons = { removed = " ", changed = " ", added = " " }
          local signs = vim.b[props.buf].gitsigns_status_dict
          local labels = {}
          if signs == nil then
            return labels
          end
          for name, icon in pairs(icons) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { " " .. icon .. signs[name], group = "Diff" .. name })
            end
          end
          if #labels > 0 then
            table.insert(labels, 1, { " │" })
          end
          return labels
        end

        local function get_diagnostic_label()
          local icons = { error = " ", warn = " ", info = " ", hint = " " }
          local label = {}

          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { " " .. icon .. n, group = "DiagnosticSign" .. severity })
            end
          end
          if #label > 0 then
            table.insert(label, 1, { " │" })
          end
          return label
        end

        local modified = vim.bo[props.buf].modified

        return {
          { ft_icon and (ft_icon .. " ") or "", guifg = ft_color, guibg = "None" },
          { (modified and "•" or "") .. filename, gui = modified and "bold,italic" or "bold" },
          { get_diagnostic_label() },
          { get_git_diff() },
        }
      end,
    },
  },
}
