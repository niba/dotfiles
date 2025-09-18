local diff = require("extras.diff")

return {
  {
    "akinsho/git-conflict.nvim",
    opts = {
      default_mappings = {
        ours = "<localleader>o",
        theirs = "<localleader>t",
        none = "<localleader>x",
        both = "<localleader>b",
        next = "<localleader>n",
        prev = "<localleader>p",
      },
    },
    config = true,
  },
  {
    -- we use gitsigns only for blame
    "lewis6991/gitsigns.nvim",
    enabled = true,
    opts = {
      current_line_blame_opts = {
        delay = 0,
      },
      signs_staged_enable = false,
      signcolumn = false,
      on_attach = function(buffer) end,
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      vim.schedule(function()
        Snacks.toggle({
          name = "Git blame line",
          get = function()
            return require("gitsigns.config").config.current_line_blame
          end,
          set = function(state)
            require("gitsigns").toggle_current_line_blame(state)

            if state then
              require("tiny-inline-diagnostic").disable()
            else
              require("tiny-inline-diagnostic").enable()
            end
          end,
        }):map("<leader>gb")
      end)
    end,
  },
  {
    "pwntester/octo.nvim",
    opts = {
      use_local_fs = true,
      reviews = {
        auto_show_threads = true,
      },
      picker = "snacks",
    },
    config = function(_, opts)
      require("octo").setup(opts)

      vim.treesitter.language.register("markdown", "octo")
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      -- DiffViewOpen origin/master...HEAD --imply-local
      {
        "<leader>gd",
        function()
          diff.toggle_diff()
        end,
        desc = "Open diffview",
      },
      { "<leader>gDo", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
      { "<leader>gDc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
      { "<leader>gDr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh diffview" },
      { "<leader>gDf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gDb", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
      { "<leader>gDr", "<Esc><Cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = { "v" }, desc = "Range history" },
      { "<leader>gDl", "<Cmd>.DiffviewFileHistory --follow<CR>", desc = "Line history" },
    },
    opts = function(_, opts)
      local actions = require("diffview.actions")
      local default_config = require("diffview.config")

      return {
        enhanced_diff_hl = true,
        watch_index = true,
        file_history_panel = {
          log_options = { -- See |diffview-config-log_options|
            git = {
              single_file = {
                diff_merges = "off",
              },
              multi_file = {
                diff_merges = "off",
              },
            },
            hg = {
              single_file = {},
              multi_file = {},
            },
          },
        },
        win_config = {},
        default_args = {
          DiffviewOpen = { "--imply-local" },
        },
        view = {
          merge_tool = {
            layout = "diff2_vertical",
          },
        },
        hooks = {
          diff_buf_win_enter = function(bufnr, winid, ctx)
            -- vim.opt_local.foldenable = false
            vim.opt_local.relativenumber = false
            vim.opt_local.number = true

            -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
            -- the right.
            -- if ctx.layout_name:match("^diff2") then
            --   if ctx.symbol == "a" then
            --     vim.opt_local.winhl = table.concat({
            --       "DiffAdd:DiffviewDiffAddAsDelete",
            --       "DiffDelete:DiffviewDiffDelete",
            --       "DiffChange:DiffAddAsDelete",
            --       "DiffText:DiffDeleteText",
            --     }, ",")
            --   elseif ctx.symbol == "b" then
            --     vim.opt_local.winhl = table.concat({
            --       "DiffDelete:DiffviewDiffDelete",
            --       "DiffChange:DiffAdd",
            --       "DiffText:DiffAddText",
            --     }, ",")
            --   end
            -- end
          end,
          diff_buf_read = function()
            vim.api.nvim_input("gg]czz")
          end,
        },
        keymaps = {
          disable_defaults = true,
          view = {
            { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
            { "n", "[F", actions.select_first_entry, { desc = "Open the diff for the first file" } },
            { "n", "]F", actions.select_last_entry, { desc = "Open the diff for the last file" } },
            { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },

            { "n", "<localleader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<localleader>f", actions.toggle_files, { desc = "Toggle the file panel." } },
            { "n", "<localleader>l", actions.cycle_layout, { desc = "Cycle through available layouts." } },

            { "n", "[x", actions.prev_conflict, { desc = "In the merge-tool: jump to the previous conflict" } },
            { "n", "]x", actions.next_conflict, { desc = "In the merge-tool: jump to the next conflict" } },

            { "n", "<localleader>o", actions.conflict_choose("ours"), { desc = "Choose the OURS version of a conflict" } },
            { "n", "<localleader>t", actions.conflict_choose("theirs"), { desc = "Choose the THEIRS version of a conflict" } },
            { "n", "<localleader>b", actions.conflict_choose("base"), { desc = "Choose the BASE version of a conflict" } },
            { "n", "<localleader>a", actions.conflict_choose("all"), { desc = "Choose all the versions of a conflict" } },

            { "n", "<localleader>O", actions.conflict_choose_all("ours"), { desc = "Choose the OURS version of a conflict for the whole file" } },
            {
              "n",
              "<localleader>T",
              actions.conflict_choose_all("theirs"),
              { desc = "Choose the THEIRS version of a conflict for the whole file" },
            },
            { "n", "<localleader>B", actions.conflict_choose_all("base"), { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<localleader>A", actions.conflict_choose_all("all"), { desc = "Choose all the versions of a conflict for the whole file" } },

            { "n", "<localleader>D", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
            { "n", "<localleader>D", actions.conflict_choose_all("none"), { desc = "Delete the conflict region for the whole file" } },

            {
              "n",
              "<localleader>p",
              function()
                vim.cmd("norm! [c")
              end,
              { desc = "Prev change" },
            },
            {
              "n",
              "<localleader>n",
              function()
                vim.cmd("norm! ]c")
              end,
              { desc = "Next change" },
            },
            unpack(actions.compat.fold_cmds),
          },
          file_panel = {
            { "n", "j", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<up>", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "o", actions.select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "l", actions.select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open the diff for the selected entry" } },

            { "n", "-", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
            { "n", "<localleader>s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },

            { "n", "<localleader>as", actions.stage_all, { desc = "Stage all entries" } },
            { "n", "<localleader>au", actions.unstage_all, { desc = "Unstage all entries" } },
            { "n", "<localleader>ax", actions.restore_entry, { desc = "Restore entry to the state on the left side" } },
            { "n", "<localleader>l", actions.open_commit_log, { desc = "Open the commit log panel" } },

            { "n", "zo", actions.open_fold, { desc = "Expand fold" } },
            { "n", "h", actions.close_fold, { desc = "Collapse fold" } },
            { "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
            { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
            { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
            { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
            { "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-d>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
            { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
            { "n", "[F", actions.select_first_entry, { desc = "Open the diff for the first file" } },
            { "n", "]F", actions.select_last_entry, { desc = "Open the diff for the last file" } },
            { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },

            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },

            { "n", "<localleader>l", actions.listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
            {
              "n",
              "<localleader>v",
              actions.toggle_flatten_dirs,
              { desc = "Flatten empty subdirectories in tree listing style" },
            },
            { "n", "<localleader>r", actions.refresh_files, { desc = "Update stats and entries in the file list" } },
            { "n", "<localleader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<localleader>f", actions.toggle_files, { desc = "Toggle the file panel" } },
            { "n", "<localleader>l", actions.cycle_layout, { desc = "Cycle available layouts" } },
            { "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
            { "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
            { "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },

            { "n", "<localleader>O", actions.conflict_choose_all("ours"), { desc = "Choose the OURS version of a conflict for the whole file" } },
            {
              "n",
              "<localleader>T",
              actions.conflict_choose_all("theirs"),
              { desc = "Choose the THEIRS version of a conflict for the whole file" },
            },
            { "n", "<localleader>B", actions.conflict_choose_all("base"), { desc = "Choose the BASE version of a conflict for the whole file" } },
            { "n", "<localleader>A", actions.conflict_choose_all("all"), { desc = "Choose all the versions of a conflict for the whole file" } },
            { "n", "<localleader>D", actions.conflict_choose_all("none"), { desc = "Delete the conflict region for the whole file" } },
            {
              "n",
              "[c",
              actions.view_windo(function(layout_name, sym)
                if sym == "b" then
                  vim.cmd("norm! [c")
                end
              end),
              { desc = "Prev change" },
            },
            {
              "n",
              "]c",
              actions.view_windo(function(layout_name, sym)
                if sym == "b" then
                  vim.cmd("norm! ]c")
                end
              end),
              { desc = "Next change" },
            },
            {
              "n",
              "<localleader>p",
              actions.view_windo(function(layout_name, sym)
                if sym == "b" then
                  vim.cmd("norm! [c")
                end
              end),
              { desc = "Prev change" },
            },
            {
              "n",
              "<localleader>n",
              actions.view_windo(function(layout_name, sym)
                if sym == "b" then
                  vim.cmd("norm! ]c")
                end
              end),
              { desc = "Next change" },
            },
          },
          file_history_panel = {
            { "n", "<localleader>?", actions.options, { desc = "Open the option panel" } },
            { "n", "<C-A-d>", actions.open_in_diffview, { desc = "Open the entry under the cursor in a diffview" } },
            { "n", "y", actions.copy_hash, { desc = "Copy the commit hash of the entry under the cursor" } },
            { "n", "<localleader>h", actions.open_commit_log, { desc = "Show commit details" } },
            {
              "n",
              "<localleader>x",
              actions.restore_entry,
              { desc = "Restore file to the state from the selected entry" },
            },

            { "n", "zo", actions.open_fold, { desc = "Expand fold" } },
            { "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
            { "n", "h", actions.close_fold, { desc = "Collapse fold" } },
            { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
            { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
            { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
            { "n", "j", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "<down>", actions.next_entry, { desc = "Bring the cursor to the next file entry" } },
            { "n", "k", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<up>", actions.prev_entry, { desc = "Bring the cursor to the previous file entry" } },
            { "n", "<cr>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "o", actions.select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "l", actions.select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "<2-LeftMouse>", actions.select_entry, { desc = "Open the diff for the selected entry" } },
            { "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
            { "n", "<c-d>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
            { "n", "<tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
            { "n", "[F", actions.select_first_entry, { desc = "Open the diff for the first file" } },
            { "n", "]F", actions.select_last_entry, { desc = "Open the diff for the last file" } },
            { "n", "gf", actions.goto_file_edit, { desc = "Open the file in the previous tabpage" } },
            { "n", "<C-w><C-f>", actions.goto_file_split, { desc = "Open the file in a new split" } },
            { "n", "<C-w>gf", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },

            { "n", "<localleader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<localleader>f", actions.toggle_files, { desc = "Toggle the file panel" } },
            { "n", "<localleader>l", actions.cycle_layout, { desc = "Cycle available layouts" } },
            { "n", "g?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
            {
              "n",
              "[c",
              actions.view_windo(function(layout_name, sym)
                if sym == "b" then
                  vim.cmd("norm! [c")
                end
              end),
            },
            {
              "n",
              "<localleader>p",
              actions.view_windo(function(layout_name, sym)
                if sym == "b" then
                  vim.cmd("norm! ]c")
                end
              end),
            },
            {
              "n",
              "<localleader>n",
              actions.view_windo(function(layout_name, sym)
                if sym == "b" then
                  vim.cmd("norm! ]c")
                end
              end),
            },
          },
          diff1 = default_config.defaults.keymaps.diff1,
          diff2 = default_config.defaults.keymaps.diff2,
          diff3 = default_config.defaults.keymaps.diff3,
          diff4 = default_config.defaults.keymaps.diff4,
          option_panel = default_config.defaults.keymaps.option_panel,
          help_panel = default_config.defaults.keymaps.help_panel,
        },
      }
    end,
  },
}
