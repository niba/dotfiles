return {
  {
    "echasnovski/mini.surround",
    enabled = false,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    enabled = true,
    opts = {
      -- old keymaps
      -- keymaps = {
      --   normal = "gsa",
      --   normal_cur = "gsas",
      --   normal_line = "gsA",
      --   normal_cur_line = "gsAs",
      --   visual = "gsa",
      --   visual_line = "gsA",
      --   delete = "gsd",
      --   change = "gsr",
      --   change_line = "gsR",
      -- },

      keymaps = {
        insert = false,
        insert_line = false,
        normal = "r",
        normal_line = "rr",
        normal_cur_line = "R",
        normal_cur = "rR",

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
