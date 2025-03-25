local create_mapping = function(key, handler)
  return {
    key,
    function()
      require("smart-splits")[handler]()
    end,
    mode = { "n", "v" },
    desc = "which_key_ignore",
  }
end

return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    enabled = true,
    keys = {
      create_mapping("<C-n>", "move_cursor_left"),
      create_mapping("<C-e>", "move_cursor_down"),
      create_mapping(Utils.special_keys.C_i, "move_cursor_up"),
      create_mapping("<C-o>", "move_cursor_right"),

      create_mapping("<C-M-n>", "resize_left"),
      create_mapping("<C-M-e>", "resize_down"),
      create_mapping("<C-M-i>", "resize_up"),
      create_mapping("<C-M-o>", "resize_right"),

      create_mapping("<C-h>", "move_cursor_left"),
      create_mapping("<C-j>", "move_cursor_down"),
      create_mapping("<C-k>", "move_cursor_up"),
      create_mapping("<C-l>", "move_cursor_right"),

      create_mapping("<C-M-h>", "resize_left"),
      create_mapping("<C-M-j>", "resize_down"),
      create_mapping("<C-M-k>", "resize_up"),
      create_mapping("<C-M-l>", "resize_right"),

      create_mapping("<C-p>", "move_cursor_previous"),
    },
    opts = {
      at_edge = "stop",
    },
  },
}
