#!/bin/bash

current_session=$(tmux display-message -p '#{session_name}')

if [[ "$current_session" == "dotfiles" || "$current_session" == "notes" ]]; then
  ~/.config/tmux/last_session.sh
else
  tmux send-keys C-q
fi
