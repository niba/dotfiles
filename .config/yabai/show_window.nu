#!/usr/bin/env nu

# Ensure target window is always visible by managing window layers
# This script raises the target window's layer to "above" while resetting other windows
# back to their normal layers to prevent layer conflicts. Handles both floating and 
# tiled windows appropriately by setting them to "normal" or "below" sub-layers respectively.

def main [] {
  let windows = yabai -m query --windows app,id,title,space,is-floating,sub-layer,scratchpad,pid,has-focus | from json
  let window_id = $env.YABAI_WINDOW_ID

  let above_windows = $windows | where sub-layer == "above" and scratchpad == ""

  for window in $above_windows {
    if $window.is-floating {
      yabai -m window $window.id --sub-layer normal
    } else {
      yabai -m window $window.id --sub-layer below
    }
  }

  let normal_windows = $windows | where sub-layer == "normal" and scratchpad == ""

  for window in $normal_windows {
    yabai -m window $window.id --sub-layer below
  }

  def focus_all_app_windows [] {
    let target_pid = $env.YABAI_PROCESS_ID
    let target_windows = $windows | where pid == ($target_pid | into int)

    for window in $target_windows {
      yabai -m window $window.id --sub-layer above
    }
  }

  def focus_first_app_window [] {
    let target_pid = $env.YABAI_PROCESS_ID
    let target_window = $windows | where pid == ($target_pid | into int) and has-focus == true | first

    if ($target_window | is-not-empty) {
      yabai -m window $target_window.id --sub-layer above
    }
  }

  yabai -m window $window_id --sub-layer normal
}
