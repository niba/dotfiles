#!/bin/bash

# Get the current number of spaces
current_space_count=$(yabai -m query --spaces | jq 'length')

# Calculate the number of spaces to add or remove
space_difference=$((8 - current_space_count))

# If there are less than 7 spaces, create the necessary number of spaces
if [ $space_difference -gt 0 ]; then
	for i in $(seq 1 $space_difference); do
		yabai -m space --create
	done
fi

# If there are more than 7 spaces, remove the excess spaces
if [ $space_difference -lt 0 ]; then
	for i in $(seq 1 ${space_difference#-}); do
		yabai -m space $(yabai -m query --spaces | jq '.[-1].index') --destroy
	done
fi

# Label spaces
yabai -m space 1 --label code
yabai -m space 2 --label terminal
yabai -m space 3 --label productivity
yabai -m space 4 --label other
yabai -m space 5 --label browser
yabai -m space 6 --label helper
yabai -m space 7 --label no_idea

# if [ $space_difference -ne 1 ]; then

yabai -m space code --display 1
yabai -m space other --display 2
yabai -m space browser --display 3

yabai -m space terminal --display 1
yabai -m space productivity --display 1

yabai -m space helper --display 3
yabai -m space no_idea --display 3

# Arrange them on multiple displays

# yabai -m space --focus code
# sleep 2
# yabai -m space --display 1
#
# yabai -m space --focus terminal
# sleep 2
# yabai -m space --display 1
#
# yabai -m space --focus productivity
# sleep 2
# yabai -m space --display 1
#
# yabai -m space --focus other
# sleep 2
# yabai -m space --display 2
#
# yabai -m space --focus browser
# sleep 2
# yabai -m space --display 3
# yabai -m space --focus helper
# sleep 2
# yabai -m space --display 3
# yabai -m space --focus no_idea
# sleep 2
# yabai -m space --display 3

#yabai -m space --focus 5
#yabai -m space --display 2
#yabai -m space --focus 3
#yabai -m space --display 3
#yabai -m space --focus 2
#yabai -m space --display 1
#yabai -m space --focus 4
#yabai -m space --display 3
#yabai -m space --focus 6
#yabai -m space --display 1

# Focus main spaces on each display
yabai -m space --focus code
yabai -m space --focus browser
yabai -m space --focus other
# fi

# Arrange application

#window_id=$(yabai -m query --windows | jq '.[] | select(.app == "Google Chrome") | .id')

#if [ -n "$window_id" ]; then
#yabai -m window $window_id --space $space_id
#else
#echo "Window for Chrome not found"
#fi
