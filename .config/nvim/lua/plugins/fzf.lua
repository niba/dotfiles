return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      defaults = {
        -- formatter = "path.filename_first",
        -- formatter = { "path.filename_first", 2 },
        formatter = "path.dirname_first",
        multiline = 1,
      },
      winopts = {

        preview = {
          -- layout = "vertical",
          horizontal = "right:40%",
        },
      },
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      keymap = {
        builtin = {
          true,
          ["<C-d>"] = "preview-page-down",
          ["<C-u>"] = "preview-page-up",
        },
      },
      buffers = {

        fzf_opts = {
          ["--tiebreak"] = "index",
          -- ["--scheme"] = "history",
          ["--keep-right"] = "",
        },
      },
      oldfiles = {
        fzf_opts = {
          ["--tiebreak"] = "end",
          ["--scheme"] = "path",
          ["--keep-right"] = "",
        },
        include_current_session = true,
      },
      files = {
        -- path_shorten = 2,
        fzf_opts = {
          ["--tiebreak"] = "end",
          ["--scheme"] = "path",
          ["--keep-right"] = "",
        },
      },
    },
  },
}
