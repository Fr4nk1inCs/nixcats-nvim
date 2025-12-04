return {
  {
    "saghen/blink.cmp",

    dependencies = {
      {
        "xzbdmw/colorful-menu.nvim",
        opts = {},
      },
    },

    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        ["<c-space>"] = { "accept", "fallback" },
        ["<c-b>"] = { "scroll_documentation_up", "fallback" },
        ["<c-f>"] = { "scroll_documentation_down", "fallback" },
        ["<c-k>"] = { "cancel", "fallback" },
        ["<cr>"] = { "accept", "fallback" },
        ["<s-tab>"] = { "select_prev", "fallback" },
        ["<tab>"] = { "select_next", "fallback" },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "normal",
      },

      completion = {
        list = {
          selection = { preselect = false },
        },
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          border = "rounded",
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
            },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },
      },

      cmdline = {

        keymap = {
          ["<cr>"] = { "accept", "fallback" },
        },
        completion = {
          ghost_text = { enabled = false },
          menu = { auto_show = true },
          list = { selection = { preselect = false } },
        },
      },

      signature = {
        enabled = true,
        window = { border = "rounded" },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
}
