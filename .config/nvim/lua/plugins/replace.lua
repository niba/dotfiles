vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("grug_far_keybindings", { clear = true }),
  pattern = { "grug-far" },
  callback = function()
    vim.keymap.set("n", "<localleader>m", function()
      local state = unpack(require("grug-far").toggle_flags({ "--fixed-strings" }))
      vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
    end, { buffer = true, desc = "Toggle fixed string" })
  end,
})

return {
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    keys = {
      {
        "<leader>sr",
        function()
          local mode_info = vim.api.nvim_get_mode()
          local grug = require("grug-far")
          if mode_info.mode == "v" then
            vim.cmd('normal! "vy')
            local yanked_text = vim.fn.getreg("v")
            yanked_text = yanked_text:gsub("\n", "")
            yanked_text = yanked_text:match("^%s*(.-)%s*$")

            require("grug-far").open({
              transient = true,
              prefills = { paths = vim.fn.expand("%"), search = yanked_text },
            })
          elseif mode_info.mode == "V" then
            require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") }, visualSelectionUsage = "operate-within-range" })
          else
            local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
            grug.open({
              transient = true,
              prefills = {
                filesFilter = ext and ext ~= "" and "*." .. ext or nil,
              },
            })
          end
        end,
        mode = { "n", "v" },
        desc = "Search and replace",
      },
    },
    opts = {
      openTargetWindow = {
        useScratchBuffer = true,
        preferredLocation = "prev",
      },
      helpLine = {
        enabled = false,
      },
      showCompactInputs = true,
      showInputsTopPadding = false,
      showInputsBottomPadding = false,
      keymaps = {
        qflist = { n = "<c-q>" },
        syncLocations = { n = "<c-s>" },
        historyOpen = { n = "<localleader>ho" },
        historyAdd = { n = "<localleader>ha" },

        replace = { n = "<localleader>r" },
        refresh = { n = "<localleader>n" },

        openLocation = { n = "<localleader>p" },
        openNextLocation = { n = "<c-f>" },
        openPrevLocation = { n = "<c-b>" },
        abort = { n = "<localleader>x" },

        toggleShowCommand = { n = "<localleader>i" },
        applyNext = { n = "<localleader>," },

        syncLine = { n = "<localleader>s" },
        syncFile = { n = "<localleader>f" },

        previewLocation = false,
        applyPrev = false,
        syncNext = false,
        syncPrev = false,
      },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>ce",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " Rip substitute",
      },
    },
    opts = {
      keymaps = {
        toggleFixedStrings = "<a-s>",
        toggleIgnoreCase = "<A-c>",
      },
      regexOptions = {
        startWithFixedStringsOn = true,
        startWithIgnoreCase = true,
      },
    },
  },
}
