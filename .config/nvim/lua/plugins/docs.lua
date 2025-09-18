return {
  {
    "iamcco/markdown-preview.nvim",
    enabled = vim.fn.executable("npm") == 1,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_combine_preview = 1

      local function load_then_exec(cmd)
        return function()
          vim.cmd.delcommand(cmd)
          require("lazy").load({ plugins = { "markdown-preview.nvim" } })
          vim.api.nvim_exec_autocmds("BufEnter", {}) -- commands appear only after BufEnter
          vim.cmd(cmd)
        end
      end

      ---Fixes "No command :MarkdownPreview"
      ---https://github.com/iamcco/markdown-preview.nvim/issues/585#issuecomment-1724859362
      for _, cmd in pairs({ "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" }) do
        vim.api.nvim_create_user_command(cmd, load_then_exec(cmd), {})
      end
    end,
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
    enabled = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "wurli/contextindent.nvim",
    enabled = false,
    opts = { pattern = "*" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "/Users/niba/Library/Mobile Documents/iCloud~md~obsidian/Documents",
        },
      },
      picker = {
        name = "snacks.pick",
      },
      completion = {
        blink = true,
        min_chars = 2,
      },
      checkbox = {
        order = { " ", "x" },
      },
    },
  },
  {
    "bullets-vim/bullets.vim",
    enabled = true,
  },
}
