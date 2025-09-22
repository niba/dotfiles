return {
  {
    "catppuccin/nvim",
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    opts = {
      color_overrides = {
        macchiato = {
          rosewater = "#efc9c2",
          flamingo = "#ebb2b2",
          pink = "#f2a7de",
          mauve = "#C792EA",
          red = "#ea7183",
          maroon = "#ea838c",
          peach = "#f39967",
          yellow = "#eaca89",
          green = "#96d382",
          teal = "#78cec1",
          sky = "#91d7e3",
          sapphire = "#68bae0",
          blue = "#73a8f2",
          lavender = "#939df5",
          text = "#b5c1f1",
          subtext1 = "#a6b0d8",
          subtext0 = "#959ec2",

          overlay2 = "#848cad",
          overlay1 = "#717997",
          overlay0 = "#63677f",
          surface2 = "#505469",
          surface1 = "#3e4255",
          surface0 = "#2c2f40",

          base = "#151925",
          mantle = "#141620",
          crust = "#0e0f16",
        },
      },
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      custom_highlights = function(C, O)
        local darken = require("catppuccin.utils.colors").darken

        return {
          ["@field"] = { fg = C.text },
          ["@property"] = { fg = C.text },
          ["@definition"] = { fg = C.maroon },

          Folded = { fg = C.blue, bg = C.surface0 },
          DiffAdd = { bg = darken(C.green, 0.15, C.base) },
          DiffDelete = { bg = darken(C.red, 0.10, C.base) },
          DiffChange = { bg = darken(C.blue, 0.15, C.base) },
          DiffText = { bg = darken(C.blue, 0.15, C.base) },

          LineNr = { fg = C.overlay0 },

          -- ["MiniDiffSignChange"] = { fg = C.yellow },
          -- ["MiniDiffSignAdd"] = { fg = C.green },
          -- ["MiniDiffSignDelete"] = { fg = C.maroon },
          -- ["MiniDiffSignUntracked"] = { fg = C.green },
          MiniSnippetsFinal = {
            bg = C.surface1,
            sp = C.green,
            underline = true,
          },
          MiniSnippetsCurrent = {
            bg = C.surface1,
            sp = C.yellow,
            underline = true,
          },
          MiniSnippetsVisited = {
            bg = C.surface1,
            sp = C.teal,
            underline = true,
          },
          MiniSnippetsUnvisited = {
            bg = C.surface1,
            sp = C.blue,
            underline = true,
          },
          MiniSnippetsCurrentReplace = {
            bg = C.surface1,
            sp = C.maroon,
            underline = true,
          },
          NoiceCompletionItemKindSnippet = {},
          GrugFarResultsMatchAdded = { link = "DiffAdd" },
          GrugFarResultsMatchRemoved = { link = "DiffDelete" },
          TreesitterContextBottom = { style = { "underline", "bold" }, sp = C.mauve },

          ["normal.c"] = { bg = C.green },
          ["visual.c"] = { bg = C.green },
          ["inactive.c"] = { bg = C.green },
          ["insert.c"] = { bg = C.green },
          c = { bg = C.green },

          LspReferenceText = { bg = C.surface0 },
          LspReferenceRead = { bg = C.surface0 },
          LspReferenceWrite = { bg = C.surface0 },
          -- ["@diff.delta"] = { bg = "#5e492f" },
          -- MiniDiffOverChange = { bg = "#5e492f" },
          -- MiniDiffOverContext = { bg = "#332500" },
          BlinkCmpMenu = { fg = C.text, bg = C.base },
          BlinkCmpMenuBorder = { fg = C.overlay0, bg = C.base },
          BlinkCmpMenuSelection = { bg = C.surface0 },
          BlinkCmpLabel = { fg = C.text },
          BlinkCmpLabelDeprecated = { fg = C.overlay0, style = { "strikethrough" } },
          BlinkCmpDocBorder = { fg = C.overlay0, bg = C.base },
          BlinkCmpDoc = { fg = C.text, bg = C.base },
        }
      end,
      integrations = {
        alpha = true,
        cmp = true,
        diffview = true,
        flash = true,
        gitsigns = true,
        snacks = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = true,
        blink_cmp = true,

        nvim_surround = true,
        octo = true,
        aerial = true,
        harpoon = false,

        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        noice = true,
        neogit = true,
        notify = true,
        neotree = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        which_key = true,
      },
    },
  },

  {
    "marko-cerovac/material.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    name = "material",
    config = function()
      require("material").setup({})
    end,
  },

  {
    "rose-pine/neovim",
    lazy = false,
    enabled = false,
    priority = 1000,
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({})
    end,
  },

  {
    "projekt0n/github-nvim-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = false,
    name = "github-theme",
    config = function()
      require("github-theme").setup({
        -- ...
      })
    end,
  },

  {
    "navarasu/onedark.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    name = "onedark",
    config = function()
      require("onedark").setup({
        style = "cool",
      })
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    enabled = false,
    priority = 1000, -- Ensure it loads first
  },
  {
    "yorumicolors/yorumi.nvim",
    enabled = false,
    priority = 1000,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    name = "kanagawa",
    config = function()
      require("kanagawa").setup()
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    enabled = false,
    config = function()
      require("monokai-pro").setup({})
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon",
    },
  },
  {
    "EdenEast/nightfox.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "tokyonight",
      colorscheme = vim.g.vscode and "" or "catppuccin",
    },
  },
}
