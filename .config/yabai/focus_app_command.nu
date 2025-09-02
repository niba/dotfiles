#!/usr/bin/env nu

use ~/.config/yabai/config.nu *

def main [app_name: string] {
    let config = (get-config)

    print $"Looking for app: ($app_name)"
    # print $"Config devs structure: ($config.devs)"
    # print $"All spaces in config: ($config.devs | flatten)"

    let current_space_info = (yabai -m query --spaces --space | from json)
    let current_space = $current_space_info.label

    let spaces = yabai -m query --spaces index,label,is-visible | from json
    let windows = yabai -m query --windows app,id,title,space | from json

    let space_lookup = $spaces | reduce -f {} {|space, acc| 
      $acc | insert ($space.index | into string) {index: $space.index, label: $space.label}
    }

    let enriched_windows = $windows | each {|window|
      let space_record = $space_lookup | get ($window.space | into string)
      $window | update space $space_record
    }

    def find_window [
      app_pattern: string,
      --title: string,
      --spaces: list<string>
    ] {
      $enriched_windows | where {|window|
        let app_matches = ($window.app =~ $app_pattern)

        let title_matches = if ($title | is-empty) { 
          true 
        } else { 
          ($window.title =~ $title) 
        }

        let space_matches = if ($spaces | is-empty) { 
          true 
        } else { 
          ($window.space.label in $spaces) 
        }

        $app_matches and $title_matches and $space_matches
      } | get 0?
    }

    def find_visible_group_and_space [] {
      let group_with_visible = $config.devs | enumerate | where {|group_item|
          let group_labels = $group_item.item
          $spaces | any {|space| 
              ($space.label in $group_labels) and $space.is-visible
          }
      } | first
      
      if ($group_with_visible | is-empty) {
          null
      } else {
          $config.devs | get $group_with_visible.index
      }
    }

    print $"Windows for app: ($enriched_windows)"
    let dev_spaces = find_visible_group_and_space
    let matching_window = find_window $app_name --spaces $dev_spaces

    if ($matching_window | is-not-empty) {
      yabai -m window --focus $matching_window.id
      return
    }

    let matching_windows = find_window $app_name --spaces $dev_spaces
    if ($matching_window | is-not-empty) {
      yabai -m window --focus $matching_window.id
      return
    }

    ^open -a $"($app_name)"
}
