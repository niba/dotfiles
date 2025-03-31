vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("grug_far_keybindings", { clear = true }),
  pattern = { "grug-far" },
  callback = function()
    vim.keymap.set("n", "<localleader>w", function()
      local state = unpack(require("grug-far").toggle_flags({ "--fixed-strings" }))
      vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
    end, { buffer = true, desc = "Toggle fixed string" })
  end,
})

return {
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      keymaps = {
        openNextLocation = { n = "<tab>" },
        openPrevLocation = { n = "<c-tab>" },
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
