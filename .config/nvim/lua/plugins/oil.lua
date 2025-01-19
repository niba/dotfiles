-- function OilDir()
-- return require("oil").get_current_dir()
-- end
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   callback = function(ev)
--     if vim.bo[ev.buf].filetype == "oil" and vim.api.nvim_get_current_buf() == ev.buf then
--       vim.api.nvim_set_option_value("winbar", "%{%v:lua.OilDir()%}", { scope = "local", win = 0 })
--     end
--   end,
-- })
-- oil fix relative path
vim.api.nvim_create_augroup("OilRelPathFix", {})
vim.api.nvim_create_autocmd("BufLeave", {
  group = "OilRelPathFix",
  pattern = "oil:///*",
  callback = function()
    vim.cmd("cd .")
  end,
})
local detail = false

return {
  {
    "stevearc/oil.nvim",
    enabled = true,
    opts = {
      skip_confirm_for_simple_edits = true,
      lsp_file_methods = {
        timeout_ms = 10000,
        autosave_changes = true,
      },
      keymaps = {
        ["<localleader>s"] = {
          callback = function()
            local oil = require("oil")
            local prefills = { paths = oil.get_current_dir() }

            local grug_far = require("grug-far")
            -- instance check
            if not grug_far.has_instance("explorer") then
              grug_far.open({
                instanceName = "explorer",
                prefills = prefills,
                staticTitle = "Find and Replace from Explorer",
              })
            else
              grug_far.open_instance("explorer")
              -- updating the prefills without clearing the search and other fields
              grug_far.update_instance_prefills("explorer", prefills, false)
            end
          end,
          desc = "oil: Search in directory",
        },
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
        ["q"] = "actions.close",
        ["<bs>"] = function()
          -- don't allow to go outside project
          local function ensure_trailing_slash(path)
            if path:sub(-1) ~= "/" then
              return path .. "/"
            end
            return path
          end

          local oil_path = ensure_trailing_slash(require("oil").get_current_dir())

          if oil_path ~= ensure_trailing_slash(LazyVim.root.cwd()) then
            require("oil.actions").parent.callback()
          end
        end,
        ["`"] = false,
        ["~"] = false,
        ["<C-c>"] = false,
        ["<C-x>"] = "actions.close",
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = "actions.refresh",
        ["<C-s>"] = false,
        ["<C-y>"] = "actions.yank_entry",
        ["<S-l>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
      },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>fe",
        function()
          require("oil").open()
        end,
        desc = "Open file explorer",
      },
      {
        "<c-s>",
        function()
          if vim.bo.filetype == "oil" then
            require("oil").save({ confirm = true })
          else
            -- return "<c-s>"
            vim.cmd("w")
          end
        end,
        desc = "Save file changes",
        -- expr = true,
      },
      {
        "<leader>fE",
        function()
          require("oil").open(vim.loop.cwd())
        end,
        desc = "Open file explorer (cwd)",
      },
      { "<leader>e", "<leader>fe", desc = "Open file explorer", remap = true },
      -- vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
    },
  },
}
