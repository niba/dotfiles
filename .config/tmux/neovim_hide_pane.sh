#!/bin/bash

# Function to toggle tmux pane borders based on pane count
toggle_pane_borders() {
	# Get the number of panes in the current window
	local pane_count=$(tmux list-panes | wc -l)

	# Check if nvim is running in any pane
	local nvim_running=$(tmux list-panes -F "#{pane_current_command}" | grep -q nvim && echo "yes")

	# Decide on border status based on pane count and if nvim is running
	if [[ $pane_count -eq 1 ]] || [[ $nvim_running == "yes" ]]; then
		tmux set-option pane-border-status off
	else
		tmux set-option pane-border-status top # or 'top', depending on your preference
	fi
}

toggle_pane_borders

# # Function to check if nvim is running in any pane of the current tmux window
# check_nvim() {
# 	local panes=$(tmux list-panes -F "#{pane_id}")
#
# 	for pane in $panes; do
# 		if tmux list-panes -F "#{pane_current_command}" | grep -q nvim; then
# 			echo "nvim"
# 			break
# 		fi
# 	done
# }
#
# # Function to toggle pane borders
# toggle_borders() {
# 	if [[ $(check_nvim) == "nvim" ]]; then
# 		tmux set-option pane-border-status off
# 	else
# 		tmux set-option pane-border-status top
# 	fi
# }
#
# toggle_borders
