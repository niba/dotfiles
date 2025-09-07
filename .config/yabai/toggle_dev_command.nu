#!/usr/bin/env nu

use ~/.config/yabai/config.nu *

def main [] {
    let config = (get-config)
    let all_spaces_info = (yabai -m query --spaces | from json | select label display)
    let visible_spaces = (yabai -m query --spaces | from json | where is-visible == true | get label)
    let focused_app = (yabai -m query --windows --window | from json | get app)

    print $"Currently visibled spaces: ($visible_spaces)"
    
    # Check if we're currently in the first dev config
    let first_config = $config.devs | get 0
    let is_first_config = ($first_config | any {|space| $space in $visible_spaces})

    let target_config = if $is_first_config { 
        $config.devs | get 1 
    } else { 
        $config.devs | get 0 
    }
    
    $target_config | each {|space| 
        let space_display = ($all_spaces_info | where label == $space | get display | get 0)
        try { yabai -m display $space_display --space $space }
    }
    print $"Switched to: ($target_config)"

    # uncomment if we want to focus the same app
    # nu ~/.config/yabai/focus_app_command.nu $focused_app
}




