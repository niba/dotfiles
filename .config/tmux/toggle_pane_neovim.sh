#!/bin/bash

neovim_pane=$(tmux list-panes -a -F "#{pane_id} #{pane_current_command}" | grep -E "(n?vim)" | head -n 1 | awk '{print $1}')

neovim_pane=${neovim_pane#%}
# echo "$neovim_pane"
# If a Neovim pane was found, zoom it
if [ -n "$neovim_pane" ]; then
  is_zoomed=$(tmux display-message -p '#{window_zoomed_flag}')

  tmux select-pane -t "$neovim_pane"
  tmux resize-pane -Z -t "$neovim_pane"
  if [ "$is_zoomed" -eq 1 ]; then
    tmux select-pane -t 2
  fi
fi

exit 0
