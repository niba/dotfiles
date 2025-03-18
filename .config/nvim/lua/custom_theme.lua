local M = {}

-- Generate the enhanced Material Ocean color palette
M.get_colors = function()
  -- Base Material Ocean colors
  local base = {
    background = "#0F111A",
    foreground = "#babed8",
    cursor = "#FFCC00",
    comments = "#464B5D",
    selection = "#717CB4",
    guides = "#3B3F51",
    lineNumbers = "#3B3F51",
    red = "#f07178",
    orange = "#F78C6C",
    yellow = "#FFCB6B",
    green = "#C3E88D",
    cyan = "#89DDFF",
    blue = "#82AAFF",
    paleblue = "#B2CCD6",
    purple = "#C792EA",
    pink = "#ff9cac",
    white = "#EEFFFF",
    black = "#000000",
    sidebarBg = "#292D3E",
    sidebarFg = "#525975",
    statuslineFg = "#4B526D",
    inputBg = "#1A1C25",
  }

  -- Enhanced Material Ocean with multiple shades per color
  local material = {
    -- Background variations
    bg = base.background,
    bg_dark = "#0C0E15", -- Darker variant of background
    bg_dark1 = "#090B10", -- Even darker variant
    bg_float = base.background,
    bg_highlight = "#1F2233", -- Lighter variant for highlights
    bg_popup = base.background,
    bg_search = base.cursor,
    bg_sidebar = base.sidebarBg,
    bg_statusline = base.background,
    bg_visual = base.selection,
    black = base.black,

    -- Foreground variations
    fg = base.foreground,
    fg_dark = "#A7A9C0", -- Slightly darker foreground
    fg_float = base.foreground,
    fg_gutter = base.lineNumbers,
    fg_sidebar = base.sidebarFg,

    -- Red variations
    red = base.red, -- #f07178
    red1 = "#E53935", -- Deeper red
    red_dim = "#D04A4F", -- Dimmed red
    red_bright = "#FF8A90", -- Brighter red

    -- Orange variations
    orange = base.orange, -- #F78C6C
    orange1 = "#E5815D", -- Deeper orange
    orange_dim = "#D47A5F", -- Dimmed orange
    orange_bright = "#FFAA88", -- Brighter orange

    -- Yellow variations
    yellow = base.yellow, -- #FFCB6B
    yellow1 = "#F0B352", -- Deeper yellow
    yellow_dim = "#D9A255", -- Dimmed yellow
    yellow_bright = "#FFE08C", -- Brighter yellow

    -- Green variations
    green = base.green, -- #C3E88D
    green1 = "#A9D078", -- Deeper green
    green2 = "#8FB060", -- Even deeper green
    green_dim = "#A6C77A", -- Dimmed green
    green_bright = "#D4FFA3", -- Brighter green

    -- Cyan variations
    cyan = base.cyan, -- #89DDFF
    cyan1 = "#70C0DF", -- Deeper cyan
    cyan2 = "#59A8C9", -- Even deeper cyan
    cyan_dim = "#77BDD9", -- Dimmed cyan
    cyan_bright = "#A1F3FF", -- Brighter cyan

    -- Blue variations
    blue = base.blue, -- #82AAFF
    blue0 = "#5D82D6", -- Deeper blue
    blue1 = "#4976CF", -- Even deeper blue
    blue2 = "#3A67C0", -- Even deeper blue
    blue5 = base.cyan, -- Cyan-blue
    blue6 = base.paleblue, -- Pale blue
    blue7 = "#3D5382", -- Dark muted blue
    blue_dim = "#7096E0", -- Dimmed blue
    blue_bright = "#9DBDFF", -- Brighter blue

    -- Purple variations
    purple = base.purple, -- #C792EA
    purple1 = "#B07FD6", -- Deeper purple
    purple2 = "#9A6DC2", -- Even deeper purple
    purple_dim = "#A97CCA", -- Dimmed purple
    purple_bright = "#DFACFF", -- Brighter purple

    -- Pink variations
    pink = base.pink, -- #ff9cac
    pink1 = "#E5889A", -- Deeper pink
    pink2 = "#CC7788", -- Even deeper pink
    pink_dim = "#D98695", -- Dimmed pink
    pink_bright = "#FFBAC8", -- Brighter pink

    -- Special colors
    magenta = "#BB80B3", -- Material violet
    magenta2 = "#FF007C", -- Bright magenta
    teal = "#44B9B1", -- Teal variant

    -- UI element colors
    border = "#1A1C26",
    border_highlight = "#3E8FB0",
    comment = base.comments,
    dark3 = "#545C7E", -- From TokyoNight
    dark5 = "#737AA2", -- From TokyoNight

    -- Status colors
    error = "#FF5370",
    hint = "#44B9B1", -- Teal variant
    info = base.blue,
    warning = base.orange,

    -- Git colors
    git = {
      add = "#4A7272", -- Muted green for git add
      change = "#5A6E9E", -- Muted blue for git change
      delete = "#7A4E56", -- Muted red for git delete
      ignore = base.comments,
    },

    -- Diff colors
    diff = {
      add = "#1F2D2B", -- Darkened green for diff add
      change = "#172A3A", -- Darkened blue for diff change
      delete = "#2D2220", -- Darkened red for diff delete
      text = "#2E3C52", -- Darkened selection for diff text
    },

    -- Other colors
    none = "NONE",
    todo = base.blue,

    -- Terminal colors
    terminal = {
      black = base.black,
      black_bright = "#414868",
      blue = base.blue,
      blue_bright = "#9DBDFF",
      cyan = base.cyan,
      cyan_bright = "#A1F3FF",
      green = base.green,
      green_bright = "#D4FFA3",
      magenta = base.purple,
      magenta_bright = "#DFACFF",
      red = base.red,
      red_bright = "#FF8A90",
      white = base.foreground,
      white_bright = base.white,
      yellow = base.yellow,
      yellow_bright = "#FFE08C",
    },
    terminal_black = "#414868",

    -- Rainbow colors (for treesitter rainbow parentheses)
    rainbow = {
      base.blue,
      base.yellow,
      base.green,
      base.cyan,
      base.purple,
      "#BB80B3", -- Material violet
      base.orange,
      base.red,
    },
  }

  return material
end

return M
