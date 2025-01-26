#!/bin/bash

# Ensure the environment variable YABAI_WINDOW_ID is set
if [[ -z "$YABAI_WINDOW_ID" ]]; then
  echo "YABAI_WINDOW_ID is not set."
  exit 1
fi

window_data=$(yabai -m query --windows --window "$YABAI_WINDOW_ID")
# Check if the window with specified conditions exists
window_count=$(yabai -m query --windows | jq --arg ID "$YABAI_WINDOW_ID" '.[] | select(.app == "Arc" and .["split-child"] == "second_child" and .id == ($ID | tonumber)) | length')
floating=$(echo "$window_data" | jq '.["is-floating"]')

echo "window count $window_count"
echo "floating window $floating"

# Handle floating / extensions windows on arc
if [[ "$floating" == "true" ]]; then
  yabai -m window "$YABAI_WINDOW_ID" --toggle float
  exit 0
fi

# If any matching window is found, execute the yabai command
if [[ $window_count -gt 0 ]]; then
  yabai -m window "$YABAI_WINDOW_ID" --space other
else
  echo "No matching window found."
fi
