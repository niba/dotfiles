-- https://github.com/nvim-neotest/neotest/issues/123
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neotest-output-panel",
  callback = function()
    vim.cmd("norm G")
  end,
})

return {
  {
    "nvim-neotest/neotest",
    ft = {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    dependencies = { "marilari88/neotest-vitest" },
    opts = {
      log_level = vim.log.levels.TRACE,
      -- discovery = {
      --   concurrent = 1,
      -- },
      output = {
        enabled = true,
        open_on_run = false,
      },
      output_panel = {
        open = "botright vsplit | vertical resize 80",
      },
      adapters = {
        ["neotest-vitest"] = {
          cwd = function(file_path)
            local src_pos = file_path:find("/src/")
            if src_pos then
              return file_path:sub(1, src_pos - 1) -- -1 to exclude the slash before "src"
            else
              return nil -- or you could return the original path if "src" is not found
            end
          end,
          filter_dir = function(name, rel_path, root)
            return name ~= "node_modules" and name ~= "dist" and name ~= "build" and name ~= "legacy"
          end,
          is_test_file = function(file_path)
            return string.match(file_path, "__tests__")
          end,
        },
      },
    },
  },
}
