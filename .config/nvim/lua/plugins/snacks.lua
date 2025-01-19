return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = { enabled = false },
      picker = {
        formatters = {
          file = {
            filename_first = true, -- display filename before the file path
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
