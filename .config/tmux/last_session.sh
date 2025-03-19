#!/bin/bash

# tmux switch-client -t $(tmux list-sessions -F "#{session_name}:#{session_last_attached}" | grep -v "^\\(dotfiles\\|notes\\):" | sort -t: -k2 -nr | awk 'NR==2 {print $1}' | cut -d: -f1)
# Get current session name
current_session=$(tmux display-message -p '#{session_name}')

# Get sorted list of non-dotfiles/notes sessions
session_list=$(tmux list-sessions -F "#{session_name}:#{session_last_attached}" |
  grep -v "^\\(dotfiles\\|notes\\):" |
  sort -t: -k2 -nr)

# Determine which entry to select (1st or 2nd)
if [[ "$current_session" == "dotfiles" || "$current_session" == "notes" ]]; then
  # If current is dotfiles/notes, take the first entry
  line_num=1
else
  # Otherwise take the second entry
  line_num=2
fi

# Get the target session
target=$(echo "$session_list" | awk "NR==$line_num {print \$1}" | cut -d: -f1)

# Switch to the target session if one was found
if [[ -n "$target" ]]; then
  tmux switch-client -t "$target"
fi
