local Util = require("lazyvim.util")
local theme = require("lualine.themes.catppuccin")

local function swap_section_colors(lualine_theme, section, custom_bg)
  -- Define all modes to process
  local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }

  for _, mode in ipairs(modes) do
    if lualine_theme[mode] and lualine_theme[mode][section] then
      -- Swap bg to fg and set custom bg
      lualine_theme[mode][section].fg = lualine_theme[mode][section].bg
      lualine_theme[mode][section].bg = custom_bg
    end
  end

  return lualine_theme
end

theme = swap_section_colors(theme, "a", "#151925")
theme.normal.a.fg = "#73a8f2"
theme.normal.b.fg = "#73a8f2"
-- theme.normal.z.fg = "#73a8f2"

local function getPath(self)
  local current_file = Util.lualine.pretty_path({
    length = 9,
    relative = "cwd",
  })(self)

  if vim.bo.filetype == "oil" then
    local oil_path = require("oil").get_current_dir()
    local cwd = vim.fn.getcwd()
    current_file = vim.fn.fnamemodify(oil_path, ":." .. cwd .. ":~:.")
  end

  return current_file
end

return {
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      ignored_next_char = "%w",

      check_ts = true,
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      npairs.setup(opts)

      npairs.get_rule('"')[1]:with_pair(cond.not_before_regex("%w")):with_pair(cond.not_after_regex("%w"))
    end,
  },
  {
    "jake-stewart/auto-cmdheight.nvim",
    lazy = false,
    opts = {
      max_lines = 5,
      duration = 2,
      remove_on_key = true,
      clear_always = false,
    },
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    -- opts = {
    --   filesystem = {
    --     hijack_netrw_behavior = "disabled",
    --   },
    -- },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = theme,
        globalstatus = true,
        section_separators = { left = " ", right = "" },
        component_separators = { left = " ", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "lazy", "alpha", "starter", "Trouble", "CodeCompanion", "snacks_layout_box" },

          winbar = {
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
            "dap-repl",
            "dapui_console",

            "snacks_layout_box",
            "snacks_picker_input",
            "checkhealth",
            "dashboard",
            "neo-tree",
            "noice",
            "Outline",
            "toggleterm",
            "tsplayground",
            "CodeCompanion",
            -- "oil",
          },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              return str:sub(1, 1)
            end,
            separator = { left = " ", right = "" },
          },
        },
        lualine_b = { { "branch", separator = { left = " ", right = "" } } },

        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = LazyVim.config.icons.diagnostics.Error,
              warn = LazyVim.config.icons.diagnostics.Warn,
              info = LazyVim.config.icons.diagnostics.Info,
              hint = LazyVim.config.icons.diagnostics.Hint,
            },
          },
        },
        lualine_x = {},
        lualine_y = {
          { "progress", separator = { left = " ", right = "" } },
          { "location" },
        },
        lualine_z = {
          {
            function()
              return "󱉭 " .. vim.fs.basename(vim.uv.cwd())
            end,
            separator = { left = "", right = " " },
          },
          -- LazyVim.lualine.root_dir({ cwd = true }),
          -- function()
          --   local data = LazyVim.lualine.root_dir({ cwd = true })
          --   -- data.separator = { left = " ", right = "" }
          --   print(vim.inspect(data))
          --   return data
          -- end,
        },
      },
      winbar = {
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            getPath,
          },
        },
      },
      inactive_winbar = {
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            getPath,
          },
        },
      },
    },
  },
}
