local Util = require("lazyvim.util")

local function showGrappleTags()
  if package.loaded["grapple"] == nil then
    return
  end

  local ok, grapple = pcall(require, "grapple")
  if not ok then
    return
  end

  local tags, err = grapple.tags()
  if not tags then
    return err
  end

  local current = grapple.find({ buffer = 0 })
  local output = { "󰛢" }

  local max_entries = 7
  local function map_index(i)
    local mapping = { 4, 5, 6, 0, 7, 8, 9 }
    return mapping[(i - 1) % 7 + 1]
  end

  local entries_amount = math.min(max_entries, #tags)
  for i = 1, entries_amount do
    local tag = tags[i]

    local filename = tag.path:match("^.+/(.+)$")
    local display_base = tag.name ~= nil and tag.name ~= "" and "[" .. tag.name .. "]" or filename
    local display = string.format("%d.%s", map_index(i), display_base)

    if current and current.path == tag.path then
      table.insert(output, "%#lualine_a_normal# " .. display .. " %*")
    else
      table.insert(output, "%#lualine_a_inactive# " .. display .. " %*")
    end
  end

  return table.concat(output)
end

local function getPath(self)
  -- Assuming the component gets the current path something like this
  local current_file = Util.lualine.pretty_path({
    length = 9,
    relative = "cwd",
  })(self)

  -- return current_file
  -- If this is an oil buffer, use the API to get the current path

  -- vim.api.nvim_echo({ { "filetype" .. vim.inspect(vim.bo.filetype) .. vim.inspect(current_file) } }, true, {})
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
  { "echasnovski/mini.pairs", enabled = false }, -- NEEDS TO BE DISABLED nvim-autopairs is better with matching odd quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    enabled = true,
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
      -- npairs.get_rule("`")[1]:with_pair(cond.not_before_regex("%w")):with_pair(cond.not_after_regex("%w"))
      -- npairs.add_rule(Rule("`", "`"):with_pair(cond.not_before_regex("%w")):with_pair(cond.not_after_regex("%w")))
    end,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    opts = function()
      return {}
    end,
    keys = function()
      return {} -- Disable all bufferline keymaps
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "lazy", "alpha", "starter", "Trouble", "CodeCompanion" },

          winbar = {
            "dapui_scopes",
            "dapui_breakpoints",
            "dapui_stacks",
            "dapui_watches",
            "dap-repl",
            "dapui_console",

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
        lualine_a = { "mode" },
        lualine_b = { "branch" },

        lualine_c = {
          LazyVim.lualine.root_dir(),
          {
            "diagnostics",
            symbols = {
              error = LazyVim.config.icons.diagnostics.Error,
              warn = LazyVim.config.icons.diagnostics.Warn,
              info = LazyVim.config.icons.diagnostics.Info,
              hint = LazyVim.config.icons.diagnostics.Hint,
            },
          },
          {
            showGrappleTags,
          },
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
