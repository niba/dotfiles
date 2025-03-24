local M = {}

M.create_mappings = function()
  vim.keymap.set("n", "<C-q>", function()
    local in_tmux = os.getenv("TMUX") ~= nil
    if in_tmux then
      local current_session = vim.fn.system("tmux display-message -p '#S'"):gsub("\n", "")
      local session_name = current_session:match("^(%S+)")

      if session_name == "dotfiles" or session_name == "notes" or session_name == "NVIM_POPUP" then
        vim.cmd("!~/.config/tmux/close_session.sh")
        return
      end
    end

    return "<C-q>"
  end, { desc = "Quicke detach from special sessions" })
end

return M
