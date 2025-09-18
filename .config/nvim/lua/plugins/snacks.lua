local snacks_extras = require("extras.snacks")

return {
  {
    "workbuffers.nvim",
    -- enabled = testing,
    enabled = false,
    dev = true,
    lazy = false,
    config = true,
    keys = {
      {
        "<leader>,",
        function()
          require("workbuffers").list({
            current = false,
            -- layout = custom_vscode,
          })
        end,
        desc = "Buffers",
      },
    },
  },
  {
    "otavioschwanck/arrow.nvim",
    opts = {
      show_icons = true,
      leader_key = "<leader>mf", -- Recommended to be a single key
      buffer_leader_key = "<leader>mm", -- Per Buffer Mappings
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          actions = require("trouble.sources.snacks").actions,
          win = {
            input = { keys = { ["<c-t>"] = { "trouble_open", mode = { "n", "i" } } } },
          },
        },
      })
    end,
  },
  {
    "folke/snacks.nvim",
    dev = true,
    opts = {
      scope = {
        enabled = false,
      },
      styles = {
        max_scratch = {
          width = 150,
          height = 60,
          bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
          minimal = false,
          noautocmd = false,
          zindex = 20,
          wo = { winhighlight = "NormalFloat:Normal" },
          border = "rounded",
          title_pos = "center",
          footer_pos = "center",
        },
      },
      debug = {
        explorer = true,
      },
      scratch = {
        win = {
          style = "max_scratch",
        },
      },
      scroll = { enabled = false },
      picker = {
        auto_close = false,
        layouts = {
          vscode = {
            layout = {
              backdrop = false,
              row = 1,
              width = 0.4,
              min_width = 80,
              height = 0.4,
              border = "rounded",
              box = "vertical",
              {
                win = "input",
                height = 1,
                border = "bottom",
                title = "{title} {live} {flags}",
                title_pos = "center",
              },
              { win = "list", border = "hpad" },
              { win = "preview", title = "{preview}", border = "rounded" },
            },
          },
        },
        actions = {
          flash = snacks_extras.flash_on_picker,
          -- auto truncate length of item
          calculate_file_truncate_width = function(self)
            local width = self.list.win:size().width
            self.opts.formatters.file.truncate = width - 6
          end,
          toggle_live_insert = function(picker)
            picker:action("toggle_live")
            picker:focus("input")
          end,
        },
        sorter = snacks_extras.zf_sorter,
        formatters = {
          file = {
            filename_first = true,
          },
        },
        sources = {
          smart = {
            ignored = false,
            hidden = true,
          },
          files = {
            exclude = { ".git", "node_modules", "dist", "build" },
            ignored = false,
            hidden = true,
          },
          grep = {
            exclude = { ".git", "node_modules", "dist", "build" },
            ignored = false,
            hidden = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<c-g>"] = { "toggle_live_insert", mode = { "i", "n" } },
              ["<a-m>"] = { "toggle_modified", mode = { "i", "n" } },
              ["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
            },
          },
          list = {
            on_buf = function(self)
              self:execute("calculate_file_truncate_width")
            end,
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<c-g>"] = { "toggle_live_insert", mode = { "i", "n" } },
              ["<a-m>"] = { "toggle_modified", mode = { "i", "n" } },
              -- doesnt work, report a bug
              ["<a-r>"] = { "toggle_regex", mode = { "i", "n" } },
            },
          },
          preview = {
            on_buf = function(self)
              self:execute("calculate_file_truncate_width")
            end,
            on_close = function(self)
              self:execute("calculate_file_truncate_width")
            end,
          },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- disabling it from options doesnt work
      Snacks.picker.sources.grep.regex = false
    end,
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart find",
      },
      {
        "<leader>gd",
        false,
      },
      -- {
      --   "<leader>,",
      --   function()
      --     Snacks.picker.buffers({
      --       current = false,
      --       layout = custom_vscode,
      --     })
      --   end,
      --   desc = "Buffers - auto flash",
      -- },
      {
        "<leader>/",
        function()
          Snacks.picker.grep_word({
            exclude = { "*.md" },
          })
        end,
        mode = { "x" },
        desc = "Grep word",
      },
      {
        "<leader>gB",
        function()
          Snacks.picker.git_log_line()
        end,
        mode = { "n" },
        desc = "Git Blame Line",
      },
      {
        "<leader>gO",
        function()
          Snacks.gitbrowse()
        end,
        mode = { "n", "x" },
        desc = "Git Browse (open)",
      },
      {
        "<leader>r",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume picker",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Open undo history",
      },
      {
        "<leader>sP",
        function()
          Snacks.picker.files({ rtp = true, pattern = "file:md$ " })
        end,
        desc = "Lazy plugins",
      },
    },
  },
}
