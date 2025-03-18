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
          -- mauve = "#b889f4",
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
          --
          -- overlay2 = "#939ab7",
          -- overlay1 = "#8087a2",
          -- overlay0 = "#6e738d",
          -- surface2 = "#5b6078",
          -- surface1 = "#494d64",
          -- surface0 = "#363a4f",

          -- base = "#1a1c2a",
          -- base = "#131621",
          base = "#151925",
          mantle = "#141620",
          crust = "#0e0f16",
        },
        --
        --
        --
        -- AI generated
        -- macchiato = {
        --
        --   -- Background colors
        --   base = "#0F111A", -- Main background (already matches)
        --   mantle = "#0F111A", -- Secondary background
        --   crust = "#0F111A", -- Tertiary background
        --
        --   -- Text colors
        --   text = "#babed8", -- Primary text color from Material Ocean
        --   subtext1 = "#8F93A2", -- Dimmed text color derived from Material Ocean
        --   subtext0 = "#717CB4", -- Selection color from Material Ocean
        --   overlay2 = "#525975", -- Sidebar foreground from Material Ocean
        --   overlay1 = "#4B526D", -- Statusbar foreground from Material Ocean
        --   overlay0 = "#3B3F51", -- Guides color from Material Ocean
        --   surface2 = "#3B3F51", -- Line numbers from Material Ocean
        --   surface1 = "#292D3E", -- Sidebar background from Material Ocean
        --   surface0 = "#1A1C25", -- Input background from Material Ocean
        --
        --   -- Syntax highlighting colors
        --   rosewater = "#B2CCD6", -- Material paleblue
        --   flamingo = "#ff9cac", -- Material pink
        --   pink = "#ff9cac", -- Material pink
        --   mauve = "#C792EA", -- Material purple (already matches)
        --   red = "#f07178", -- Material red (already matches in maroon)
        --   maroon = "#f07178", -- Material red (already matches)
        --   peach = "#F78C6C", -- Material orange
        --   yellow = "#FFCB6B", -- Material yellow (already matches)
        --   green = "#C3E88D", -- Material green (already matches)
        --   teal = "#89DDFF", -- Material cyan
        --   sky = "#89DDFF", -- Material cyan
        --   sapphire = "#82AAFF", -- Material blue
        --   blue = "#82AAFF", -- Material blue
        --   lavender = "#C792EA", -- Material purple
        -- },

        -- CUSTOM
        -- macchiato = {
        --   rosewater = "#f5e0dc",
        --   flamingo = "#f2cdcd",
        --   pink = "#f5c2e7",
        --   mauve = "#c792ea",
        --   red = "#f38ba8",
        --   maroon = "#f07178",
        --   peach = "#fab387",
        --   yellow = "#ffcb6b",
        --   green = "#c3e88d",
        --   teal = "#94e2d5",
        --   sky = "#89dceb",
        --   sapphire = "#74c7ec",
        --   blue = "#89b4fa",
        --   lavender = "#fea6ba",
        --   text = "#b5c1f1",
        --   subtext1 = "#a6b0d8",
        --   subtext0 = "#959ec2",
        --   overlay2 = "#848cad",
        --   overlay1 = "#717997",
        --   overlay0 = "#63677f",
        --   surface2 = "#505469",
        --   surface1 = "#3e4255",
        --   surface0 = "#2c2f40",
        --   -- text = "#cdd6f4",
        --   -- subtext1 = "#bac2de",
        --   -- subtext0 = "#a6adc8",
        --   -- overlay2 = "#9399b2",
        --   -- overlay1 = "#7f849c",
        --   -- overlay0 = "#6c7086",
        --   -- surface2 = "#585b70",
        --   -- surface1 = "#45475a",
        --   -- surface0 = "#313244",
        --   base = "#0f111a",
        --   mantle = "#181825",
        --   crust = "#11111b",
        -- },
        -- CUSTOM 2
        -- defaultAccent: '#80CBC4',
        -- background: '#0F111A',
        -- backgroundAlt: '#0F111A',
        -- contrastBorder: '#0F111A',
        -- comments: '#464B5D',
        -- caret: '#FFCC00',
        -- findHighlight: '#FFCC00',
        -- foreground: '#babed8',
        -- focusBorder: '#FFFFFF',
        -- guides: '#3B3F51',
        -- lineNumbers: '#3B3F5180',
        -- invisibles: '#80869E50',
        -- lineHighlight: '#000000',
        -- selection: '#717CB45',
        -- shadow: '#00000030',
        -- inputBackground: '#1A1C25',
        -- inputForeground: '#EEFFFF',
        -- inputBorder: '#FFFFFF10',
        -- scrollbars: '#8F93A220',
        -- scrollbarsHover: '#8F93A210',
        -- statusbarForeground: '#4B526D',
        -- sidebarBackground: '#292D3E',
        -- sidebarForeground: '#525975',
        -- listHoverForeground: '#FFFFFF',
        -- listHoverBackground: '#292D3E',
        -- tabActiveForeground: '#FFFFFF',
        -- inactiveSelectionBackground: '#00000030',
        -- findMatchBackground: '#000000',
        -- findMatchHighlightBackground: '#00000050',
        -- findMatchHighlightBorder: '#ffffff30',
        -- macchiato = {
        --   rosewater = "#f5e0dc",
        --   flamingo = "#f2cdcd",
        --   pink = "#f5c2e7",
        --   mauve = "#c792ea",
        --   red = "#f38ba8",
        --   maroon = "#f07178",
        --   peach = "#fab387",
        --   yellow = "#ffcb6b",
        --   green = "#c3e88d",
        --   teal = "#94e2d5",
        --   sky = "#89dceb",
        --   sapphire = "#74c7ec",
        --   blue = "#89b4fa",
        --   lavender = "#fea6ba",
        --   text = "#b5c1f1",
        --   subtext1 = "#a6b0d8",
        --   subtext0 = "#959ec2",
        --   overlay2 = "#848cad",
        --   overlay1 = "#717997",
        --   overlay0 = "#63677f",
        --   surface2 = "#505469",
        --   surface1 = "#3e4255",
        --   -- surface1 = "#434A6D",
        --   surface0 = "#2c2f40",
        --   -- text = "#cdd6f4",
        --   -- subtext1 = "#bac2de",
        --   -- subtext0 = "#a6adc8",
        --   -- overlay2 = "#9399b2",
        --   -- overlay1 = "#7f849c",
        --   -- overlay0 = "#6c7086",
        --   -- surface2 = "#585b70",
        --   -- surface1 = "#45475a",
        --   -- surface0 = "#313244",
        --   base = "#131621",
        --   mantle = "#181825",
        --   crust = "#11111b",
        -- },
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

          -- Visual = { bg = C.surface2, style = { "bold" } },
          -- VisualNOS = { bg = C.surface2, style = { "bold" } },

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
    opts = {
      style = "moon",
      -- transparent = false,
      -- terminal_colors = true,
      -- styles = {
      --   comments = { italic = true },
      --   keywords = { italic = true },
      --   functions = {},
      --   variables = {},
      --   sidebars = "dark",
      --   floats = "dark",
      -- },
      -- sidebars = { "qf", "help", "terminal", "packer", "nvim-tree", "telescope", "explorer" },
      -- day_brightness = 0.3,
      -- hide_inactive_statusline = false,
      -- dim_inactive = false,
      -- lualine_bold = false,
      -- on_colors = function(c)
      --   local colors = get_colors()
      --
      --   for key, value in pairs(colors) do
      --     c[key] = value
      --   end
      -- end,
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
      -- kind_filter = {
      --   ts = false,
      --   js = false,
      --   typescript = false,
      --   javascript = false,
      -- },
    },
  },
}
