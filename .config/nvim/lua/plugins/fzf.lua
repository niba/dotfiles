return {
  {
    "dmtrKovalenko/fff.nvim",
    enabled = false,
    build = "cargo build --release",
    -- or if you are using nixos
    -- build = "nix run .#release",
    opts = {
      -- pass here all the options
    },
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
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
