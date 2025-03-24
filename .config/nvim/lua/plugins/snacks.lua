local snacks_extras = require("extras.snacks")

return {
  {
    "workbuffers.nvim",
    -- enabled = testing,
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
    "folke/snacks.nvim",
    dev = true,
    opts = {
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
        explorer = true, -- show explorer debug info
      },
      scratch = {
        win = {
          style = "max_scratch",
        },
      },
      scroll = { enabled = false },
      picker = {
        auto_close = false,
        actions = {
          flash = snacks_extras.flash_on_picker,
        },
        sorter = snacks_extras.zf_sorter,
        grep = {
          regex = false,
        },
        formatters = {
          file = {
            filename_first = true,
            truncate = 100,
          },
        },
        win = {
          input = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<a-m>"] = { "toggle_modified", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<a-m>"] = { "toggle_modified", mode = { "i", "n" } },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart find",
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
