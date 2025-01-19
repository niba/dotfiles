vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("my-grug-far-custom-keybinds", { clear = true }),
  pattern = { "grug-far" },
  callback = function()
    vim.keymap.set("n", "<localleader>w", function()
      local state = unpack(require("grug-far").toggle_flags({ "--fixed-strings" }))
      vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
    end, { buffer = true })
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
    {
      "echasnovski/mini.move",
      event = "VeryLazy",
      keys = {
        {
          "<M-left>",
          [[<Cmd>lua MiniMove.move_selection('left')<CR>]],
          mode = { "x" },
          desc = "Move selected left",
        },
        {
          "<M-right>",
          [[<Cmd>lua MiniMove.move_selection('right')<CR>]],
          mode = { "x" },
          desc = "Move selected right",
        },
        {
          "<M-down>",
          [[<Cmd>lua MiniMove.move_selection('down')<CR>]],
          mode = { "x" },
          desc = "Move selected down",
        },
        {
          "<M-up>",
          [[<Cmd>lua MiniMove.move_selection('up')<CR>]],
          mode = { "x" },
          desc = "Move selected up",
        },
        {
          "<M-left>",
          [[<Cmd>lua MiniMove.move_line('left')<CR>]],
          mode = { "n" },
          desc = "Move line left",
        },
        {
          "<M-right>",
          [[<Cmd>lua MiniMove.move_line('right')<CR>]],
          mode = { "n" },
          desc = "Move line right",
        },
        {
          "<M-down>",
          [[<Cmd>lua MiniMove.move_line('down')<CR>]],
          mode = { "n" },
          desc = "Move line down",
        },
        {
          "<M-up>",
          [[<Cmd>lua MiniMove.move_line('up')<CR>]],
          mode = { "n" },
          desc = "Move line up",
        },
      },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>fs",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
    opts = {
      keymaps = {
        toggleFixedStrings = "<a-s>",
        toggleIgnoreCase = "<A-c>",
      },
    },
  },
  {
    "folke/persistence.nvim",
    keys = {
      {
        "<leader>ql",
        function()
          require("persistence").load()
        end,
        desc = "Restore Session",
      },
      {
        "<leader>qr",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "Restore Last Session",
      },
    },
  },
}
