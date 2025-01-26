#!/bin/bash

file=~/tmp/tmuxscrollback.sh
tmux capture-pane -pS -32768 >$file
tmux new-window -n mywindow "nvim '+ normal G $' $file"
