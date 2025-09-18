#!/usr/bin/env nu

# Fix Raycast behavior to prevent unwanted space switching
# When Raycast AI chat is opened on a non-visible space, it automatically switches to that space.
# This script moves the Raycast window to the current focused space instead, maintaining
# the user's current workspace context while ensuring Raycast remains accessible.

def show_raycast [] {
  skhd --key "cmd + ctrl + alt + shift - space"
}

def main [] {
  let windows = yabai -m query --windows app,id,title,space,is-floating,is-minimized,sub-layer,scratchpad,pid,has-focus | from json
  let spaces = yabai -m query --spaces is-visible,index,has-focus | from json

  let raycast_windows = $windows | where app == "Raycast"
  if ($raycast_windows | is-empty) {
    show_raycast
    return
  }

  let raycast_window = $raycast_windows | first

  if $raycast_window.is-minimized {
    show_raycast
    return
  }
  let raycast_space_index = $raycast_window.space

  let raycast_spaces = $spaces | where index == $raycast_space_index

  if ($raycast_spaces | is-empty) {
    show_raycast
    return
  }

  let raycast_space = $raycast_spaces | first

  # if not $raycast_space.is-visible {
  if not $raycast_space.has-focus {
    let focused_spaces = $spaces | where has-focus == true

    if not ($focused_spaces | is-empty) {
      let focused_space = $focused_spaces | first
      try {
        yabai -m window $raycast_window.id --space $focused_space.index
      }
    }
  }

  show_raycast
}
