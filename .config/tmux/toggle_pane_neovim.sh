#!/bin/bash

neovim_pane=$(tmux list-panes -F "#{pane_index} #{pane_current_command}" | grep -E "(n?vim)" | head -n 1 | awk '{print $1}')

last_used_pane=$(tmux list-panes -F "#{pane_index} #{pane_active} #{pane_current_command} #{pane_last_activity}" |
  grep -v "nvim" | # Exclude the current active pane
  sort -k3 -nr |   # Sort by activity time (column 3) in reverse numerical order
  head -n 1 |      # Take the most recent one
  awk '{print $1}')

# If a Neovim pane was found, zoom it
if [ -n "$neovim_pane" ]; then
  if [ -z "$last_used_pane" ]; then
    tmux split-window -v -p 30
    last_used_pane=$(tmux display-message -p '#{pane_index}')
    tmux resize-pane -Z -t "$neovim_pane"
  fi

  is_zoomed=$(tmux display-message -p '#{window_zoomed_flag}')

  tmux select-pane -t "$neovim_pane"
  tmux resize-pane -Z -t "$neovim_pane"
  if [ "$is_zoomed" -eq 1 ]; then
    tmux select-pane -t "$last_used_pane"
  fi
fi

exit 0
