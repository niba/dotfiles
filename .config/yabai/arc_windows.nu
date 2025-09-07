#!/usr/bin/env nu

use ~/.config/yabai/config.nu *

def main [] {
  let config = (get-config)

  let arc_windows = yabai -m query --windows | from json
  | where app == "Arc"
  | where is-floating == false
  | where role == "AXWindow"
  | where subrole == "AXStandardWindow"
  | where title != ""
  | sort-by id

  # Check if we have a window ID and if it's Arc
  if ($env.YABAI_WINDOW_ID? | is-not-empty) {
    let current_window_id = $env.YABAI_WINDOW_ID | into int
    let current_window = $arc_windows
    | where id == $current_window_id

    if ($current_window | is-empty) {
      return
    }

    let current_window = $current_window | first
    if $current_window.app != "Arc" {
      return
    }
  }

  if ($arc_windows | is-empty) {
    return
  }

  $arc_windows | take 2 | enumerate | each {|item|
    let space = ($config.special.arc_windows | get $item.index)
    print $"Moving ($item) to space ($space)"
    yabai -m window $item.item.id --space ($space)
  }
}
