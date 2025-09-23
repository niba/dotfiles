#!/bin/bash

# Function to toggle tmux pane borders based on pane count and copy-mode
toggle_pane_borders() {
  local in_copy_mode=$(tmux display-message -p "#{pane_in_mode}" | grep -q 1 && echo "yes")

  if [[ $in_copy_mode == "yes" ]]; then
    tmux set-option pane-border-status top
    return
  fi

  # Get the number of panes in the current window
  local pane_count=$(tmux list-panes | wc -l)

  local nvim_running=$(tmux list-panes -F "#{pane_current_command}" | grep -q nvim && echo "yes")

  if [[ $nvim_running != "yes" ]]; then
    tmux set-option pane-border-status top
    return
  fi

  # Decide on border status based on pane count and if nvim is running
  if [[ $pane_count -eq 1 ]] || [[ $nvim_running == "yes" ]]; then
    tmux set-option pane-border-status off
  else
    tmux set-option pane-border-status top
  fi
}

toggle_pane_borders
