#!/usr/bin/env nu

use ~/.config/yabai/config.nu *
use ~/.config/yabai/utils.nu *

def main [] {
  let config = (get-config)

  let current_window_id = $env.YABAI_WINDOW_ID | into int

  let windows = yabai -m query --windows app,id,title,subrole,scratchpad,space,is-floating,sub-layer,scratchpad,pid | from json

  let current_window = $windows | where id == $current_window_id
  if ($current_window | is-empty) {
    return
  }

  let current_window = $current_window | first

  if ($current_window.app != "Arc" or $current_window.subrole != "AXSystemDialog" or $current_window.scratchpad != "") {
    return
  }

  let space = $config.special.arc_pip | get space
  let others = $config.special.arc_pip | reject space
  let params = (build_params $others "window")

  yabai -m window $current_window.id --space $space
  yabai -m window $current_window.id ...$params

  # let pip_windows = $windows | where app == $current_window.app and subrole == "AXSystemDialog" and scratchpad == ""
  #
  # for window in $pip_windows {
  #   # todo: take from config
  #   yabai -m window $window.id --scratchpad videos --grid "4:4:2:0:2:2" --space mac
  # }
}
