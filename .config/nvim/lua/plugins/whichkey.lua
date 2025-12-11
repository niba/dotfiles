return {
  {
    "folke/which-key.nvim",
    url = "https://github.com/niba/which-key.nvim",
    branch = "fix/localleader_popup",
    event = "VeryLazy",
    opts = {
      -- preset = "helix",
      keys = {
        scroll_down = "", -- binding to scroll down inside the popup
        scroll_up = "", -- binding to scroll up inside the popup
      },
      spec = {
        {
          mode = { "n", "v" },
          ["<leader><tab>"] = nil,
          { "<leader>gD", group = "diff" },
          { "<leader>gh", group = "hunks" },
          { "<leader>a", "", desc = "ai" },
          { "<leader>y", "", desc = "yazi" },
          { "<leader>m", "", desc = "mix" },
          -- { "<leader>ap", "", desc = "prompts" },
        },
      },
    },
  },
}
