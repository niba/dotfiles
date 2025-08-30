#!/usr/bin/env nu

use ~/.config/yabai/config.nu *

def main [app_name: string] {
    let config = (get-config)

   # Debug: Print the config structure
   print $"Config devs structure: ($config.devs)"
   print $"All spaces in config: ($config.devs | flatten)"

    # Get current focused space (replace with actual command for your system)
    let current_space_info = (yabai -m query --spaces --space | from json)
    let current_space = $current_space_info.label

    print $"Looking for app: ($app_name)"

    # Find which group contains the current space
    let matching_groups = ($config.devs | enumerate | where {|group| 
        $current_space in $group.item
    })
    print $"Matching space: ($matching_groups)"
    let current_group = if ($matching_groups | length) > 0 {
        $matching_groups | get item | first
    } else {
        []
    }

    print $"Current space: ($current_group)"
    # Function to search for app in given spaces
    def search_app_in_spaces [spaces: list, app: string] {
        let results = ($spaces | each {|space|
            # Query windows in this space (adjust command for your system)
            let windows = (yabai -m query --windows --space $space | from json)
            let found_window = ($windows | where {|w| ($w.app | str contains $app)})
            if ($found_window | length) > 0 {
                {space: $space, window: ($found_window | first)}
            } else {
                null
            }
        } | where {|result| $result != null})
                print $"Current space: ($results)"
        if ($results | length) > 0 {
            $results | first
        } else {
            null
        }
    }

    # Try to find app in current group first
    let app_location = if ($current_group | length) > 0 {
        print $"Searching in current group: ($current_group)"
        search_app_in_spaces $current_group $app_name
    } else {
       print "Current space not found in any group"
        null
    }

    # If not found in group, search all spaces
    let final_location = if ($app_location == null) {
        print "App not found in current group, searching all spaces..."
        let all_spaces = ($config.devs | flatten)
        search_app_in_spaces $all_spaces $app_name
    } else {
        $app_location
    }

    # Switch to the app if found
    if ($final_location != null) {
        print $"Found ($app_name) in space ($final_location.space)"
        # Switch to the space and focus the window
        yabai -m space --focus $final_location.space
        yabai -m window --focus $final_location.window.id
        print $"Switched to ($app_name)"
    } else {
        print $"App ($app_name) not found in any space"
    }
}
