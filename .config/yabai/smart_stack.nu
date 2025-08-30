#!/usr/bin/env nu

use config.nu

let left_split_apps = [
    "kitty"
    "Code"
]

let spaces_to_balance = ["dev_work_middle"]
let focused_window_id = $env.YABAI_WINDOW_ID

let current_space_label = (yabai -m query --spaces --space | from json | select label index)
if $current_space_label.label in $spaces_to_balance {
    print $"Current space is '($current_space_label)' not supported by smart stack. Exiting."
    exit 1
}

let focused_app = (yabai -m query --windows --window $focused_window_id | from json | get app)
let focused_app_props = (yabai -m query --windows --window $focused_window_id | from json | select stack-index is-visible space split-type)
let focused_app_space_id = (yabai -m query --windows --window $focused_window_id | from json | get space)

let current_display = (yabai -m query --windows --window | from json | get display)
let current_space_index = (yabai -m query --spaces --space | from json | get index)
let windows_array = (yabai -m query --windows --space $current_space_index --display $current_display | from json | where is-minimized == false and is-floating == false)

let number_of_windows = ($windows_array | length)
let window = (yabai -m query --windows --window | from json | get id)

let is_code_editor = $focused_app in $left_split_apps

if $number_of_windows > 2 {
  # we can also try to find first code_app_window
  let target_id = if $is_code_editor {
     ($windows_array | where split-child == "first_child" | last | get id)
  } else {
     ($windows_array | where split-child == "second_child" | first | get id)
  }

  yabai -m window $target_id --stack $focused_window_id 
} else {
  exit 1
}
