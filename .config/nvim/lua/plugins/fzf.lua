return {
  {
    "dmtrKovalenko/fff.nvim",
    -- "madmaxieee/fff.nvim",
    lazy = false,
    enabled = false,
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
    -- or if you are using nixos
    -- build = "nix run .#release",
    opts = {
      debug = {
        enabled = true,
        show_scores = true,
      },
    },
    keys = {
      {
        "<leader>z",
        "<cmd> FFFSnacks <cr>",
        desc = "Smart find",
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    opts = {
      fzf_opts = {
        ["--scheme"] = "path",
      },
    },
  },
  {
    "elanmed/fzf-lua-frecency.nvim",
    enabled = false,
    dependencies = { "ibhagwan/fzf-lua" },
    config = true,
  },
}
