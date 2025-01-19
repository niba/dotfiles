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
          mauve = "#b889f4",
          red = "#ea7183",
          maroon = "#ea838c",
          peach = "#f39967",
          yellow = "#eaca89",
          green = "#96d382",
          teal = "#78cec1",
          sky = "#91d7e3",
          sapphire = "#68bae0",
          blue = "#739df2",
          -- lavender = "#a0a8f6",
          -- lavender = "#a4acf7",
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
          -- overlay2 = "#939ab7",
          -- overlay1 = "#8087a2",
          -- overlay0 = "#6e738d",
          -- surface2 = "#5b6078",
          -- surface1 = "#494d64",
          -- surface0 = "#363a4f",

          base = "#1a1c2a",
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
        return {
          ["@field"] = { fg = C.text },
          ["@property"] = { fg = C.text },
          ["@definition"] = { fg = C.maroon },

          ["MiniDiffSignChange"] = { fg = C.yellow },
          ["MiniDiffSignAdd"] = { fg = C.green },
          ["MiniDiffSignDelete"] = { fg = C.maroon },
          ["MiniDiffSignUntracked"] = { fg = C.green },
          GrugFarResultsMatchAdded = { link = "DiffAdd" },
          GrugFarResultsMatchRemoved = { link = "DiffDelete" },
          -- GrugFarResultsMatchAdded = { fg = C.green, bg = "#5e492f" },
          -- GrugFarResultsMatchRemoved = { fg = C.maroon, bg = "#5e492f" },
          Visual = { bg = C.surface2, style = { "bold" } },
          VisualNOS = { bg = C.surface2, style = { "bold" } },
          LspReferenceText = { bg = C.surface0 },
          LspReferenceRead = { bg = C.surface0 },
          LspReferenceWrite = { bg = C.surface0 },
          ["@diff.delta"] = { bg = "#5e492f" },
          MiniDiffOverChange = { bg = "#5e492f" },
          MiniDiffOverContext = { bg = "#332500" },
          BlinkCmpMenu = { fg = C.text, bg = C.base },
          BlinkCmpMenuBorder = { fg = C.overlay0, bg = C.base },
          BlinkCmpMenuSelection = { bg = C.surface0 },
          BlinkCmpLabel = { fg = C.text },
          BlinkCmpLabelDeprecated = { fg = C.overlay0, style = { "strikethrough" } },
          BlinkCmpDocBorder = { fg = C.overlay0, bg = C.base },
          BlinkCmpDoc = { fg = C.text, bg = C.base },
          -- MiniDiffOverContext = { bg = "#0b263d" },
          -- ["@variable"] = { fg = C.maroon, style = O.styles.variables or {} },
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
    enabled = true,
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
    enabled = true,
    priority = 1000,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    enabled = true,
    name = "kanagawa",
    config = function()
      require("kanagawa").setup({
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
            PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            -- Save an hlgroup with dark background and dimmed foreground
            -- so that you can use it where your still want darker windows.
            -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

            -- Popular plugins that open floats will link to NormalFloat by default;
            -- set their background accordingly if you wish to keep them dark and borderless
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          }
        end,
      })
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
    opts = { style = "moon" },
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
      -- kind_filter = {
      --   ts = false,
      --   js = false,
      --   typescript = false,
      --   javascript = false,
      -- },
    },
  },
}
