#!/usr/bin/env bash

kitten @ action close_other_os_windows

kitten @ launch --dont-take-focus --type os-window --os-window-title "job" --title "job"
kitten @ launch --dont-take-focus --type os-window --os-window-title "personal" --title "personal"

kitten @ send-text --match "title:\"job\"" "tmux -L job a || tmux -L job\n"
kitten @ send-text --match "title:\"personal\"" "tmux -L personal a || tmux -L personal\n"

kitten @ focus-window --match "not title:\"job\" and not title:\"personal\""

kitten @ close-window
