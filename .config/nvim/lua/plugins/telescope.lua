if true then
  return {}
end

local focus_preview = function(prompt_bufnr)
  local action_state = require("telescope.actions.state")

  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win
  local previewer = picker.previewer
  local winid = previewer.state.winid
  local bufnr = previewer.state.bufnr
  vim.keymap.set("n", "<C-w>", function()
    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
  end, { buffer = bufnr })
  vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
  -- api.nvim_set_current_win(winid)
end

-- filename match has priority over filepath match in results that are close to each other (sorted by last used)
local function tiebreak(distance_threshold)
  return function(a, b, prompt)
    local function filename_contains_prompt(entry)
      if not entry or not entry.filename then
        return false
      end
      local filename
      if type(entry.filename) == "string" then
        filename = vim.fn.fnamemodify(entry.filename, ":t")
      else
        filename = entry.filename
      end
      prompt = prompt or ""
      return (filename:lower():find(prompt:lower(), 1, true) ~= nil)
    end

    local a_contains = filename_contains_prompt(a)
    local b_contains = filename_contains_prompt(b)

    local distance = math.abs(a.index - b.index)

    -- if files are not far apart in history then filename has priority
    if distance < distance_threshold then
      if a_contains and not b_contains then
        return true
      elseif b_contains and not a_contains then
        return false
      end
    end

    return a.index < b.index
  end
end

local find_files_picker = {
  name = "telescope",
  commands = {
    files = "find_files",
    live_grep = "live_grep",
  },
  -- this will return a function that calls telescope.
  -- cwd will default to lazyvim.util.get_root
  -- for `files`, git_files or find_files will be chosen depending on .git
  ---@param builtin string
  ---@param opts? lazyvim.util.pick.Opts
  open = function(builtin, opts)
    opts = opts or {}
    opts.follow = opts.follow ~= false

    if opts.internal_cwd == nil then
      -- it only works on first call, that's why we are storing path in internal value
      opts.internal_cwd = LazyVim.root({ buf = opts.buf })
    end

    local function toggle_root_dir()
      local action_state = require("telescope.actions.state")
      local line = action_state.get_current_line()

      if opts.root == false then
        opts.root = nil
        opts.cwd = opts.internal_cwd
      else
        opts.root = false
        opts.cwd = nil
      end

      LazyVim.pick.open(
        builtin,
        vim.tbl_deep_extend("force", {}, opts or {}, {
          default_text = line,
        })
      )
    end
    ---@diagnostic disable-next-line: inject-field
    opts.attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      map("i", "<a-c>", toggle_root_dir, { desc = "Toggle root directory" })
      -- map("c", "<C-c>", actions.close, { desc = "Close in selection" })

      vim.keymap.set("x", "<C-c>", function()
        actions.close(prompt_bufnr)
      end, { buffer = prompt_bufnr })
      return true
    end

    vim.print(vim.inspect(opts))
    require("telescope.builtin")[builtin](opts)
  end,
}

LazyVim.pick.register(find_files_picker)

local function flash_telescope(prompt_bufnr)
  require("flash").jump({
    -- we want to reverse labeling because the most interesting items are on the bottom
    labeler = function(matches, state)
      local labels = state:labels()
      local num_matches = #matches
      local num_labels = #labels

      for i = num_matches, 1, -1 do
        local match = matches[i]
        local label_index = (num_matches - i) % num_labels
        match.label = labels[label_index + 1]
      end
    end,
    highlight = {
      matches = false,
      backdrop = false,
    },
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local actions = require("telescope.actions")
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
      actions.select_default(prompt_bufnr)
    end,
  })
end

return {
  -- {
  --   "ibhagwan/fzf-lua",
  --   opts = {
  --     defaults = {
  --       -- cwd_prompt_shorten_len = 5,
  --       formatter = "path.filename_first",
  --
  --       path_shorten = 15,
  --     },
  --     files = {
  --
  --       -- fzf_opts = { ["--with-nth"] = "9.." },
  --       -- cwd_prompt_shorten_len = 5,
  --     },
  --     winopts = {
  --       preview = {
  --         vertical = "down:60%",
  --         layout = "vertical",
  --       },
  --     },
  --   },
  -- },
  {
    "nvim-telescope/telescope.nvim",
    enabled = false,
    dependencies = { "tsakirist/telescope-lazy.nvim" },
    keys = {
      { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>sP", "<cmd>Telescope lazy<cr>", desc = "Lazy plugins" },
      { "<leader>r", "<cmd>Telescope resume<cr>", desc = "Resume picker" },
      -- {
      --   "<leader>fp",
      --   function()
      --     local custom_buffers = require("core/buffers")
      --     custom_buffers.persist_buffers2({})
      --   end,
      --   desc = "test buffers",
      -- },
      {
        "<leader>fb",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
          })
        end,
        desc = "Buffers",
      },
      {
        "<leader>,",
        function()
          require("telescope.builtin").buffers({
            sort_mru = true,
            sort_lastused = true,
            ignore_current_buffer = true,
            -- tiebreak = function(current_entry, existing_entry, _)
            --   -- This ensures that when you are filtering, it's also sorted by last opened time.
            --   -- https://github.com/nvim-telescope/telescope.nvim/issues/2539#issuecomment-1562510095
            --   return current_entry.index < existing_entry.index
            -- end,
          })
        end,
        desc = "Recent buffers",
      },
    },
    opts = {
      pickers = {
        find_files = {
          tiebreak = tiebreak(10000),
        },
        buffers = {
          tiebreak = tiebreak(10),
        },
        live_grep = {
          layout_strategy = "vertical",
          additional_args = { "--fixed-strings" },
        },
        help_tags = {
          mappings = {
            i = {
              ["<C-cr>"] = require("telescope.actions").select_default,
              ["<cr>"] = require("telescope.actions").select_vertical,
            },
            n = {
              ["<C-cr>"] = require("telescope.actions").select_default,
              ["<cr>"] = require("telescope.actions").select_vertical,
            },
          },
        },
      },
      defaults = {
        preview = {
          filesize_limit = 1,
          timeout = 100,
        },
        layout_strategy = "flex",
        path_display = {
          filename_first = {
            reverse_directories = true,
          },
          -- shorten = { len = 1, exclude = { -1, -2, -3, -4, -5, -6, -7 } },
        },
        mappings = {
          i = {
            ["<C-b>"] = function(...)
              return require("telescope.actions").delete_buffer(...)
            end,
            ["<C-w>"] = focus_preview,
            ["<C-x>"] = require("telescope.actions").close,
            ["<C-c>"] = false,
          },
          n = {
            -- ["<Esc>"] = false,
            -- some issues with flash mode
            ["<C-c>"] = require("telescope.actions").close,
            ["<C-x>"] = require("telescope.actions").close,
            ["q"] = require("telescope.actions").close,
            ["<C-b>"] = function(...)
              return require("telescope.actions").delete_buffer(...)
            end,
            ["<C-w>"] = focus_preview,
          },
        },
      },
    },
  },
  -- flash integration
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      if not LazyVim.has("flash.nvim") then
        return
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { ["<c-s>"] = flash_telescope }, i = { ["<c-s>"] = flash_telescope } },
      })
    end,
  },
  {
    "benfowler/telescope-luasnip.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
      },
    },
    keys = {
      {
        "<leader>sf",
        "<cmd>Telescope luasnip<cr>",
        desc = "Open snippets",
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("luasnip")
    end,
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      {
        "<leader>su",
        "<cmd>Telescope undo<cr>",
        desc = "Open undo history",
      },
    },
    opts = {
      -- don't use `defaults = { }` here, do this in the main telescope spec
      extensions = {
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
        -- no other extensions here, they can have their own spec too
      },
    },
    config = function(_, opts)
      -- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
      -- configs for us. We won't use data, as everything is in it's own namespace (telescope
      -- defaults, as well as each extension).
      require("telescope").setup(opts)
      require("telescope").load_extension("undo")
      require("telescope").load_extension("luasnip")
    end,
  },
}
