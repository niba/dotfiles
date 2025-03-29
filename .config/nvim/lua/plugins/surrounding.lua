return {
  {
    "xzbdmw/clasp.nvim",
    config = function()
      require("clasp").setup({
        pairs = { ["{"] = "}", ['"'] = '"', ["'"] = "'", ["("] = ")", ["["] = "]", ["<"] = ">" },
        keep_insert_mode = true,
      })
      vim.keymap.set({ "n", "i" }, "<m-o>", function()
        require("clasp").wrap("next")
      end)

      vim.keymap.set({ "n", "i" }, "<m-n>", function()
        require("clasp").wrap("prev")
      end)
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    enabled = true,
    opts = {
      keymaps = {
        insert = false,
        insert_line = false,
        normal = "r",
        normal_line = "R",

        normal_cur = "rr",
        normal_cur_line = "Rr",

        visual = "r",
        visual_line = "R",

        delete = "dr",
        change = "cr",
        change_line = "cR",
      },
      -- move_cursor = "sticky",
      aliases = {
        ["("] = ")",
        ["["] = "]",
        ["<"] = ">",
        ["b"] = false,
      },
      surrounds = {
        ["("] = false,
        ["["] = false,
        ["<"] = false,
        b = {
          add = function()
            local config = require("nvim-surround.config")
            local result = config.get_input("Enter the block prefix: ")
            if result then
              return { { result .. "{" }, { "}" } }
            end
          end,
          find = function()
            local config = require("nvim-surround.config")
            return config.get_selection({
              query = {
                capture = "@block.outer",
                type = "textobjects",
              },
            })
          end,
          delete = "^(.-{)().-(})()$",
          change = {
            target = "^(.-{)().-(})()$",
            replacement = function()
              local config = require("nvim-surround.config")
              local result = config.get_input("Enter the block prefix: ")
              if result then
                return { { result .. "{" }, { "}" } }
              end
            end,
          },
        },
        g = {
          add = function()
            local config = require("nvim-surround.config")
            local result = config.get_input("Enter the generic name: ")
            if result then
              return { { result .. "<" }, { ">" } }
            end
          end,
          find = function()
            local config = require("nvim-surround.config")
            return config.get_selection({ node = "generic_type" })
          end,
          delete = "^(.-<)().-(>)()$",
          change = {
            target = "^(.-<)().-(>)()$",
            replacement = function()
              local config = require("nvim-surround.config")
              local result = config.get_input("Enter the generic name: ")
              if result then
                return { { result .. "<" }, { ">" } }
              end
            end,
          },
        },
      },
    },
  },
}
