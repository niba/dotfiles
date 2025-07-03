#!/bin/bash

restore_layout() {
  local apps=(
    "Arc:General"
    "kitty:Dev"
    "Cursor:Dev"
    "Code:Dev"
    "Microsoft Teams:Chats"
    "Discord:Chats"
    "Messenger:Chats"
  )

  for app_workspace in "${apps[@]}"; do
    local app="${app_workspace%:*}"
    local workspace="${app_workspace#*:}"
    echo "Processing app: $app -> workspace: $workspace"

    # Get all windows for debugging
    echo "All windows for $app:"
    aerospace list-windows --all --json | jq -r ".[] | select(.\"app-name\" == \"$app\")"

    # Get the window ID
    local window_id=$(aerospace list-windows --all --json | jq -r ".[] | select(.\"app-name\" == \"$app\") | .\"window-id\"" | head -1)

    echo "Found window-id: '$window_id'"

    if [ -n "$window_id" ] && [ "$window_id" != "null" ]; then
      echo "Moving window $window_id to workspace $workspace..."
      aerospace move-node-to-workspace --window-id "$window_id" "$workspace"
      local exit_code=$?
      echo "Move command exit code: $exit_code"
    else
      echo "No window found for app: $app"
    fi

    echo "---"
  done
}

restore_layout
