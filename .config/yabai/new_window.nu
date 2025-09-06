def main [] {
    let windows = yabai -m query --windows | from json
    
    let current_window_id = $env.YABAI_WINDOW_ID | into int
    let current_window = $windows | where id == $current_window_id
    if ($current_window | is-empty) {
        print $"new window is empty"
        return
    }

    print $"new window info ($current_window)"
    
    let current_window = $current_window | first
    let same_app_windows = $windows | where app == $current_window.app 
    
    let has_above_window = $same_app_windows | any {|window| $window.sub-layer == "above"}
    
    if $has_above_window {
        yabai -m window $current_window_id --sub-layer above
    }
}
