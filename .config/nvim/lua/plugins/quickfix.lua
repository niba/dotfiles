local force_trouble = false

local win_config = {}

---@param loclist? boolean
local get_qfid = function(loclist)
  if loclist then
    return vim.fn.getloclist(0, { id = 0 }).id
  end
  return vim.fn.getqflist({ id = 0 }).id
end

---@param winid? integer
local is_loclist = function(winid)
  return vim.fn.win_gettype(winid) == "loclist"
end

-- :q, :cclose
vim.api.nvim_create_autocmd("WinClosed", {
  callback = function(args)
    if vim.bo[args.buf].ft ~= "qf" then
      return
    end
    local qfwinid = tonumber(args.match) --[[@as integer]]
    local loclist = is_loclist(qfwinid)
    local qfid = get_qfid(loclist)
    win_config[qfid] = {
      loclist = loclist,
      height = vim.api.nvim_win_get_height(qfwinid),
      view = vim.api.nvim_win_call(qfwinid, vim.fn.winsaveview),
    }
    for _, wconf in pairs(win_config) do
      if loclist == wconf.loclist then
        wconf.height = win_config[qfid].height
      end
    end
  end,
})

local prevent_auto_restore = false

-- :copen; :cnewer, :colder
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "quickfix",
  callback = function()
    if prevent_auto_restore then
      return
    end
    local qfwinid = vim.fn.win_getid()
    local qfid = get_qfid(is_loclist())
    local wconf = win_config[qfid]
    if not wconf then
      vim.api.nvim_win_set_height(qfwinid, 20)
      return
    end
    -- NOTE: Restore `view`
    -- vim.schedule(function()
    --   vim.api.nvim_win_call(qfwinid, function()
    --     vim.fn.winrestview(wconf.view)
    --   end)
    -- end)
    -- NOTE: Restore `height`
    -- Skip if `:copen <count>`
    if not vim.fn.histget("cmd", -1):find("copen? ?%d+") then
      vim.api.nvim_win_set_height(qfwinid, wconf.height)
    end
  end,
})

---@param opts quicker.OpenOpts
local quicker_toggle = function(opts)
  local wconf = win_config[get_qfid(opts.loclist)] or {}

  prevent_auto_restore = true
  require("quicker").toggle(vim.tbl_extend("keep", opts, {
    focus = true,
    view = wconf.view,
    height = wconf.height,
    max_height = 24,
    open_cmd_mods = { split = "botright" },
  }))
  prevent_auto_restore = false
end

if force_trouble then
  -- Open always in trouble
  vim.api.nvim_create_autocmd("BufRead", {
    callback = function(ev)
      if vim.bo[ev.buf].buftype == "quickfix" then
        vim.schedule(function()
          vim.cmd([[cclose]])
          vim.cmd([[Trouble qflist open]])
        end)
      end
    end,
  })
end

return {
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      on_qf = function()
        vim.wo.signcolumn = "yes:1"
      end,
      keys = {
        {
          "<localleader>t",
          function()
            require("quicker").toggle_expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Toggle quickfix context",
        },
        {
          "<localleader>r",
          function()
            require("quicker").refresh()
          end,
          desc = "Refresh quickfix ",
        },
      },
    },
    keys = {
      {
        "<leader>l",
        function()
          quicker_toggle({})
        end,
        desc = "Toggle quickfix",
      },
      {
        "<leader>L",
        function()
          quicker_toggle({ loclist = true })
        end,
        desc = "Toggle loclist",
      },
    },
  },
  {
    "kevinhwang91/nvim-bqf",
    event = "FileType qf",
    config = function(_, opts)
      require("bqf").setup({
        preview = {
          auto_preview = false,
        },
        func_map = {
          tab = "",
          tabb = "",
          tabc = "",
          split = "",
          prevhist = "{",
          nexthist = "}",
        },
      })
    end,
  },
}
