return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      picker = {
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
            truncate = 100,
          },
        },
      },
      win = {
        input = {
          keys = {
            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
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
      {
        "<leader>sZ",
        function()
          local results = require("chezmoi.commands").list()
          local chezmoi = require("chezmoi.commands")

          local finder_items = {}
          for index, item in ipairs(results) do
            table.insert(finder_items, {
              formatted = item,
              text = item,
              file = "~/" .. item,
              -- item = item,
              idx = index,
            })
          end

          vim.print(vim.inspect(results))
          Snacks.picker.pick({
            source = "select",
            main = { current = true },
            items = finder_items,
            actions = {
              confirm = function(picker, item)
                chezmoi.edit({
                  targets = { item.file },
                  args = { "--watch" },
                })
                picker:close()
              end,
            },
          })
          Snacks.picker.resume()
        end,
        desc = "Chezmoi files",
      },
    },
  },
}
