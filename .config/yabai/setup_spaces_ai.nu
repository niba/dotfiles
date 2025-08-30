#!/usr/bin/env nu

# List of apps that should go to the left split
let left_split_apps = [
    "kitty"
    "Code"
]

# Get DEV space ID
def get_dev_space_id [] {
    yabai -m query --spaces 
    | from json 
    | where label == "dev_work_middle" 
    | get index?.0? 
    | default null
}

# Check if app should be in left split
def is_left_split_app [app: string] {
    $app in $left_split_apps
}

# Main setup function
def main [] {
    let dev_space_id = (get_dev_space_id)
    
    if $dev_space_id == null {
        print "DEV space not found"
        return
    }
    
    # Get all windows in DEV space
    let windows = (
        yabai -m query --windows --space $dev_space_id 
        | from json 
        | where is-floating == false and is-minimized == false
    )
    
    if ($windows | is-empty) {
        print "No windows in DEV space"
        return
    }
    
    # Separate windows into left and right
    let left_windows = ($windows | where {|w| is_left_split_app $w.app})
    let right_windows = ($windows | where {|w| not (is_left_split_app $w.app)})
    
    # Process left windows
    if not ($left_windows | is-empty) {
        let first_left = ($left_windows | first)
        
        # Ensure first window is on the left
        yabai -m window $first_left.id --ratio abs:0.5
        
        # Stack remaining left windows
        $left_windows 
        | skip 1 
        | each {|w| 
            yabai -m window $w.id --stack $first_left.id
        }
    }
    
    # Process right windows
    if not ($right_windows | is-empty) {
        let first_right = ($right_windows | first)
        
        # Stack remaining right windows
        $right_windows 
        | skip 1 
        | each {|w| 
            yabai -m window $w.id --stack $first_right.id
        }
    }
    
    print $"DEV space organized: ($left_windows | length) left, ($right_windows | length) right"
}

