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
    opts = {
      openTargetWindow = {
        useScratchBuffer = true,
        preferredLocation = "prev",
      },
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
