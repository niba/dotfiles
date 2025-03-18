#!/bin/bash

tmux switch-client -t $(tmux list-sessions -F "#{session_name}:#{session_last_attached}" | grep -v "^\\(dotfiles\\|notes\\):" | sort -t: -k2 -nr | awk 'NR==2 {print $1}' | cut -d: -f1)
