#!/usr/bin/env nu

use config.nu

let config = (config get-config)

$config.displays | enumerate | each {|item|
    let display_index = ($item.index + 1)
    let display_label = $item.item
    print $"Labeling display ($display_index) as ($display_label)"
    try {
        yabai -m display $display_index --label $display_label
    }
}

let total_spaces_needed = ($config.spaces | values | each {|spaces| $spaces | length} | math sum)

let current_space_count = (yabai -m query --spaces | from json | length)
let space_difference = ($total_spaces_needed - $current_space_count)

# create the necessary number of spaces
if $space_difference > 0 {
    1..$space_difference | each {|i| yabai -m space --create}
}

# remove the excess spaces
if $space_difference < 0 {
    print $"spaces to remove ($space_difference)"
    let spaces_to_remove = ($space_difference | math abs)
    1..$spaces_to_remove | each {|i| 
        let all_spaces = (yabai -m query --spaces | from json)
        let displays_with_counts = ($all_spaces | group-by display | items {|display_id, spaces| 
            {display_id: $display_id, count: ($spaces | length), spaces: $spaces}
        })
        
        # Find a display with more than one space and remove its last space
        let display_to_remove_from = ($displays_with_counts | where count > 1 | first)
        if ($display_to_remove_from | is-not-empty) {
            let space_to_remove = ($display_to_remove_from.spaces | last)
            print $"Removing space ($space_to_remove.index) from display ($display_to_remove_from.display_id)"
            yabai -m space $space_to_remove.index --destroy
            sleep 30ms
        }

    }
}

let displays = (yabai -m query --displays | from json)
let spaces = (yabai -m query --spaces id,label,index | from json)

$displays | each {|display|
    let display_index = $display.index
    let temp_label = $"tmp_space_($display_index)"
    yabai -m space --create $display_index --label $temp_label
    sleep 50ms
}

let empty_label_indexes = (yabai -m query --spaces | from json 
  | where ($it.label | is-empty) or ($it.label == null) 
  | get index)

let config_items = ($config.spaces 
    | items {|display_label, spaces|
        $spaces | each {|space| {display_label: $display_label, space_label: $space}}
    } 
    | flatten)

$config_items
    | enumerate
    | each {|item|
        let space_index = ($empty_label_indexes | get $item.index)

        let display_label = $item.item.display_label
        let space_label = $item.item.space_label
        print $"Assigning space [($space_index)]: ($space_label) -> ($display_label)" 
        try { yabai -m space $space_index --label $space_label }
        sleep 10ms
    }

$config_items
    | enumerate
    | each {|item|
        let display_label = $item.item.display_label
        let space_label = $item.item.space_label
        try { yabai -m space $space_label --display $display_label }
        sleep 10ms
    }


mut iteration_count = 0
let max_iterations = 20 

# space can change index after removing other space so we need to query before each operation
loop {
    $iteration_count += 1

    if $iteration_count > $max_iterations {
        break
    }

    let all_spaces = (yabai -m query --spaces | from json)
    let tmp_spaces = ($all_spaces | where ($it.label | str starts-with "tmp_space"))

    if ($tmp_spaces | is-empty) {
        break
    } else {
        let tmp_space = ($tmp_spaces | first)
        try { yabai -m space $tmp_space.index --destroy }
        sleep 20ms
    }
}
