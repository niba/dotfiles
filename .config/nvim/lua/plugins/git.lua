local function inactive_diff()
  local dv = require("diffview.lib")

  local tabs = vim.api.nvim_list_tabpages()

  for _, tabpage in ipairs(tabs) do
    for _, view in ipairs(dv.views) do
      if view.tabpage == tabpage then
        return tabpage
      end
    end
  end

  return nil
end

local function toggle_diff()
  local dv = require("diffview.lib")

  local current_diff = dv.get_current_view()

  if current_diff ~= nil then
    vim.cmd("DiffviewClose")
  else
    local inactive_diff_tab = inactive_diff()

    if inactive_diff_tab ~= nil then
      vim.api.nvim_set_current_tabpage(inactive_diff_tab)
    else
      vim.cmd("DiffviewOpen")
    end
  end
end

return {
  {
    "pwntester/octo.nvim",
    opts = {
      use_local_fs = true,
      reviews = {
        auto_show_threads = false,
      },
      -- query to get requested review prs, make binding later
      -- Octo search is:pr review-requested:@me
    },
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- optional
    },
    keys = {
      {
        "<leader>gd",
        function()
          toggle_diff()
        end,
        desc = "Open diffview",
      },
      -- { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
      { "<leader>gDo", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
      { "<leader>gDc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
      { "<leader>gDr", "<cmd>DiffviewRefresh<cr>", desc = "Refresh diffview" },
      { "<leader>gDf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      -- { "<leader>gDf", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
      { "<leader>gDb", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
    },
    opts = function(_, opts)
      local actions = require("diffview.actions")

      local default_panel_keymaps = {

        {
          "n",
          "j",
          actions.next_entry,
          { desc = "Bring the cursor to the next file entry" },
        },
        {
          "n",
          "<down>",
          actions.next_entry,
          { desc = "Bring the cursor to the next file entry" },
        },
        {
          "n",
          "k",
          actions.prev_entry,
          { desc = "Bring the cursor to the previous file entry" },
        },
        {
          "n",
          "<up>",
          actions.prev_entry,
          { desc = "Bring the cursor to the previous file entry" },
        },
        {
          "n",
          "<cr>",
          actions.focus_entry,
          { desc = "Open the diff for the selected entry" },
        },
        {
          "n",
          "o",
          actions.select_entry,
          { desc = "Open the diff for the selected entry" },
        },
        {
          "n",
          "l",
          actions.select_entry,
          { desc = "Open the diff for the selected entry" },
        },
        -- { "n", "<c-b>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
        -- { "n", "<c-f>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
        { "n", "zo", actions.open_fold, { desc = "Expand fold" } },
        { "n", "zc", actions.close_fold, { desc = "Collapse fold" } },
        { "n", "h", actions.close_fold, { desc = "Collapse fold" } },
        { "n", "za", actions.toggle_fold, { desc = "Toggle fold" } },
        { "n", "zR", actions.open_all_folds, { desc = "Expand all folds" } },
        { "n", "zM", actions.close_all_folds, { desc = "Collapse all folds" } },
        { "n", "<Tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
        { "n", "<Tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
        { "n", "<S-Tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
        { "n", "[x", actions.prev_conflict, { desc = "Go to the previous conflict" } },
        { "n", "]x", actions.next_conflict, { desc = "Go to the next conflict" } },
        { "n", "<c-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
        { "n", "<c-d>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
      }

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
        keymaps = {
          disable_defaults = true,
          file_panel = vim.list_extend(default_panel_keymaps, {
            {
              "n",
              "gf",
              actions.goto_file_edit,
              { desc = "Open the file" },
            },
            { "n", "g?", actions.help("file_panel"), { desc = "Open the help panel" } },
            { "n", "L", actions.open_commit_log, { desc = "Open the commit log panel" } },
            {
              "n",
              "a",
              actions.toggle_stage_entry,
              { desc = "Stage / unstage the selected entry" },
            },
            { "n", "A", actions.stage_all, { desc = "Stage all entries" } },
            { "n", "U", actions.unstage_all, { desc = "Unstage all entries" } },
            {
              "n",
              "X",
              actions.restore_entry,
              { desc = "Restore entry to the state on the left side" },
            },

            { "n", "<leader>gO", actions.conflict_choose_all("ours"), { desc = "Whole file OURS" } },
            { "n", "<leader>gT", actions.conflict_choose_all("theirs"), { desc = "Whole file THEIRS" } },
            { "n", "<leader>gB", actions.conflict_choose_all("base"), { desc = "Whole file BASE" } },
            { "n", "<leader>gA", actions.conflict_choose_all("all"), { desc = "Whole file BOTH" } },
            { "n", "<leader>gX", actions.conflict_choose_all("none"), { desc = "Whole file DELETE" } },
            { "n", "gl", actions.cycle_layout, { desc = "Cycle available layouts" } },
            { "n", "<leader>E", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel" } },
            {
              "n",
              "i",
              actions.listing_style,
              { desc = "Toggle between 'list' and 'tree' views" },
            },
          }),
          file_history_panel = vim.list_extend(default_panel_keymaps, {
            { "n", "g!", actions.options, { desc = "Open the option panel" } },
            {
              "n",
              "y",
              actions.copy_hash,
              { desc = "Copy the commit hash of the entry under the cursor" },
            },
            { "n", "L", actions.open_commit_log, { desc = "Show commit details" } },
            {
              "n",
              "X",
              actions.restore_entry,
              { desc = "Restore file to the state from the selected entry" },
            },

            { "n", "g?", actions.help("file_history_panel"), { desc = "Open the help panel" } },
          }),
          view = {
            -- { "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel." } },
            {
              "n",
              "[x",
              actions.prev_conflict,
              { desc = "In the merge-tool: jump to the previous conflict" },
            },
            {
              "n",
              "]x",
              actions.next_conflict,
              { desc = "In the merge-tool: jump to the next conflict" },
            },
            { "n", "<Tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
            { "n", "<S-Tab>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
            {
              "n",
              "gf",
              actions.goto_file_edit,
              { desc = "Open the file" },
            },
            { "n", "gl", actions.cycle_layout, { desc = "Cycle available layouts" } },
            { "n", "<leader>E", actions.focus_files, { desc = "Bring focus to the file panel" } },
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel" } },
            { "n", "<leader>go", actions.conflict_choose("ours"), { desc = "Chunk OURS" } },
            { "n", "<leader>gt", actions.conflict_choose("theirs"), { desc = "Chunk THEIRS" } },
            { "n", "<leader>gb", actions.conflict_choose("base"), { desc = "Chunk BASE" } },
            { "n", "<leader>ga", actions.conflict_choose("all"), { desc = "Chunk BOTH" } },
            { "n", "<leader>gx", actions.conflict_choose("none"), { desc = "Chunk DELETE" } },
            { "n", "<leader>gO", actions.conflict_choose_all("ours"), { desc = "Whole file OURS" } },
            { "n", "<leader>gT", actions.conflict_choose_all("theirs"), { desc = "Whole file THEIRS" } },
            { "n", "<leader>gB", actions.conflict_choose_all("base"), { desc = "Whole file BASE" } },
            { "n", "<leader>gA", actions.conflict_choose_all("all"), { desc = "Whole file BOTH" } },
            { "n", "<leader>gX", actions.conflict_choose_all("none"), { desc = "Whole file DELETE" } },
          },
          diff1 = {
            -- Mappings in single window diff layouts
            { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
          },
          diff2 = {
            -- Mappings in 2-way diff layouts
            { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
          },
          diff3 = {
            -- Mappings in 3-way diff layouts
            {
              { "n", "x" },
              "2do",
              actions.diffget("ours"),
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              { "n", "x" },
              "3do",
              actions.diffget("theirs"),
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            { "n", "g?", actions.help({ "view", "diff3" }), { desc = "Open the help panel" } },
          },
          diff4 = {
            -- Mappings in 4-way diff layouts
            {
              { "n", "x" },
              "1do",
              actions.diffget("base"),
              { desc = "Obtain the diff hunk from the BASE version of the file" },
            },
            {
              { "n", "x" },
              "2do",
              actions.diffget("ours"),
              { desc = "Obtain the diff hunk from the OURS version of the file" },
            },
            {
              { "n", "x" },
              "3do",
              actions.diffget("theirs"),
              { desc = "Obtain the diff hunk from the THEIRS version of the file" },
            },
            { "n", "g?", actions.help({ "view", "diff4" }), { desc = "Open the help panel" } },
          },
          option_panel = {
            { "n", "<tab>", actions.select_entry, { desc = "Change the current option" } },
            { "n", "q", actions.close, { desc = "Close the panel" } },
            { "n", "g?", actions.help("option_panel"), { desc = "Open the help panel" } },
          },
          help_panel = {
            { "n", "q", actions.close, { desc = "Close help menu" } },
            { "n", "<esc>", actions.close, { desc = "Close help menu" } },
          },
        },
        hooks = {
          diff_buf_win_enter = function()
            -- Change local options in diff buffers
            vim.opt_local.foldenable = false
            -- vim.opt_local.list = false
            -- vim.opt_local.colorcolumn = { 80 }
          end,
          diff_buf_read = function()
            vim.api.nvim_input("gg]czz")
          end,
          -- view_opened = function(view)
          --   print(
          --     ("A new %s was opened on tab page %d!")
          --       :format(view.class:name(), view.tabpage)
          --   )
          -- end,
        },
        -- keymaps = {
        --   view = {
        --     {
        --       "n",
        --       "<leader>co",
        --       actions.conflict_choose("ours"),
        --       { desc = "Choose the OURS version of a conflict" },
        --     },
        --     {
        --       "n",
        --       "<leader>ct",
        --       actions.conflict_choose("theirs"),
        --       { desc = "Choose the THEIRS version of a conflict" },
        --     },
        --     {
        --       "n",
        --       "<leader>cb",
        --       actions.conflict_choose("base"),
        --       { desc = "Choose the BASE version of a conflict" },
        --     },
        --     {
        --       "n",
        --       "<leader>ca",
        --       actions.conflict_choose("all"),
        --       { desc = "Choose all the versions of a conflict" },
        --     },
        --     { "n", "dx", actions.conflict_choose("none"), { desc = "Delete the conflict region" } },
        --     {
        --       "n",
        --       "<leader>cO",
        --       actions.conflict_choose_all("ours"),
        --       { desc = "Choose the OURS version of a conflict for the whole file" },
        --     },
        --     {
        --       "n",
        --       "<leader>cT",
        --       actions.conflict_choose_all("theirs"),
        --       { desc = "Choose the THEIRS version of a conflict for the whole file" },
        --     },
        --     {
        --       "n",
        --       "<leader>cB",
        --       actions.conflict_choose_all("base"),
        --       { desc = "Choose the BASE version of a conflict for the whole file" },
        --     },
        --     {
        --       "n",
        --       "<leader>cA",
        --       actions.conflict_choose_all("all"),
        --       { desc = "Choose all the versions of a conflict for the whole file" },
        --     },
        --     {
        --       "n",
        --       "dX",
        --       actions.conflict_choose_all("none"),
        --       { desc = "Delete the conflict region for the whole file" },
        --     },
        --   },
        -- },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      attach_to_untracked = true,
      trouble = true,
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        -- custom mappings
        map("n", "<leader>gha", function()
          gs.setqflist("all")
        end, "All changed files")
        map("n", "<leader>gb", function()
          gs.blame()
        end, "Blame Buffer")
        -- lazy mappings
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function()
          gs.nav_hunk("last")
        end, "Last Hunk")
        map("n", "[H", function()
          gs.nav_hunk("first")
        end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")
        map("n", "<leader>ghB", function()
          gs.blame()
        end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis("~")
        end, "Diff This ~")
        map("n", "<leader>hi", gs.preview_hunk_inline)
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
    },
    config = true,
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Open neogit" },
    },
  },
}

-- code to override octo octo/reviews/file-entry.lua
-- activate the diff between right and left panels
-- function FileEntry:show_diff()
--     local view = vim.fn.winsaveview()
--     for _, bufid in ipairs { self.left_bufid, self.right_bufid } do
--     vim.api.nvim_buf_call(bufid, function()
--     pcall(vim.cmd, [[filetype detect]])
--     pcall(vim.cmd, [[doau BufEnter]])
--     pcall(vim.cmd, [[diffthis]])
--     -- Scroll to trigger the scrollbind and sync the windows. This works more
--     -- consistently than calling `:syncbind`.
--     pcall(vim.cmd, [[exec "normal! \<c-y>"]])
--     vim.api.nvim_buf_set_option(bufid, "foldenable", false)
--     vim.api.nvim_buf_set_option(bufid, "foldmethod", "manual")
--     vim.api.nvim_buf_call(bufid, function()
--     vim.cmd "normal! zR"
--   end)
-- end)
-- end
--   vim.fn.winrestview(view)
-- end
