#!/usr/bin/env nu

# Get app info by querying yabai directly
def get-app-info [window_id: string] {
    if ($window_id | is-empty) or ($window_id == "") {
        return "No Window ID"
    }
    
    try {
        let window = (yabai -m query --windows --window $window_id | from json)
        return $"($window.app) [WID:($window.id)/PID:($window.pid)]"
    } catch {
        return $"Unknown [WID:($window_id)]"
    }
}

# Get process info by querying system directly
def get-process-info [process_id: string] {
    if ($process_id | is-empty) or ($process_id == "") {
        return "No Process ID"
    }
    
    try {
        # Try to get app name from ps command
        let app_name = (ps | where pid == ($process_id | into int) | get name | first)
        return $"($app_name) [PID:($process_id)]"
    } catch {
        return $"Unknown [PID:($process_id)]"
    }
}

# Get current time formatted
def get-time [] {
    date now | format date "%H:%M:%S.%3f"
}

# Main function with pattern matching
def main [event: string] {
    let time = (get-time)
    
    match $event {
        # Window events
        "window_created" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_created: ($app)"
        }
        
        "window_destroyed" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_destroyed: ($app)"
        }
        
        "window_focused" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_focused: ($app)"
        }
        
        "window_moved" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_moved: ($app)"
        }
        
        "window_resized" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_resized: ($app)"
        }
        
        "window_minimized" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_minimized: ($app)"
        }
        
        "window_deminimized" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_deminimized: ($app)"
        }
        
        "window_title_changed" => {
            let window_id = ($env.YABAI_WINDOW_ID? | default "")
            let app = (get-app-info $window_id)
            print $"[($time)] window_title_changed: ($app)"
        }
        
        # Space events
        "space_created" => {
            let space_id = ($env.YABAI_SPACE_ID? | default "N/A")
            print $"[($time)] space_created: SPACE_ID=($space_id)"
        }
        
        "space_destroyed" => {
            let space_id = ($env.YABAI_SPACE_ID? | default "N/A")
            print $"[($time)] space_destroyed: SPACE_ID=($space_id)"
        }
        
        "space_changed" => {
            let space_id = ($env.YABAI_SPACE_ID? | default "N/A")
            let recent_space_id = ($env.YABAI_RECENT_SPACE_ID? | default "N/A")
            print $"[($time)] space_changed: SPACE_ID=($space_id) RECENT_SPACE_ID=($recent_space_id)"
        }
        
        # Display events
        "display_added" => {
            let display_id = ($env.YABAI_DISPLAY_ID? | default "N/A")
            print $"[($time)] display_added: DISPLAY_ID=($display_id)"
        }
        
        "display_removed" => {
            let display_id = ($env.YABAI_DISPLAY_ID? | default "N/A")
            print $"[($time)] display_removed: DISPLAY_ID=($display_id)"
        }
        
        "display_moved" => {
            let display_id = ($env.YABAI_DISPLAY_ID? | default "N/A")
            print $"[($time)] display_moved: DISPLAY_ID=($display_id)"
        }
        
        "display_resized" => {
            let display_id = ($env.YABAI_DISPLAY_ID? | default "N/A")
            print $"[($time)] display_resized: DISPLAY_ID=($display_id)"
        }
        
        "display_changed" => {
            let display_id = ($env.YABAI_DISPLAY_ID? | default "N/A")
            let recent_display_id = ($env.YABAI_RECENT_DISPLAY_ID? | default "N/A")
            print $"[($time)] display_changed: DISPLAY_ID=($display_id) RECENT_DISPLAY_ID=($recent_display_id)"
        }
        
        # Application events
        "application_launched" => {
            let process_id = ($env.YABAI_PROCESS_ID? | default "")
            let app = (get-process-info $process_id)
            print $"[($time)] application_launched: ($app)"
        }
        
        "application_terminated" => {
            let process_id = ($env.YABAI_PROCESS_ID? | default "")
            let app = (get-process-info $process_id)
            print $"[($time)] application_terminated: ($app)"
        }
        
        "application_front_switched" => {
            let process_id = ($env.YABAI_PROCESS_ID? | default "")
            let app = (get-process-info $process_id)
            let recent_pid = ($env.YABAI_RECENT_PROCESS_ID? | default "N/A")
            print $"[($time)] application_front_switched: ($app) RECENT_PID=($recent_pid)"
        }
        
        "application_activated" => {
            let process_id = ($env.YABAI_PROCESS_ID? | default "")
            let app = (get-process-info $process_id)
            print $"[($time)] application_activated: ($app)"
        }
        
        "application_deactivated" => {
            let process_id = ($env.YABAI_PROCESS_ID? | default "")
            let app = (get-process-info $process_id)
            print $"[($time)] application_deactivated: ($app)"
        }
        
        "application_visible" => {
            let process_id = ($env.YABAI_PROCESS_ID? | default "")
            let app = (get-process-info $process_id)
            print $"[($time)] application_visible: ($app)"
        }
        
        "application_hidden" => {
            let process_id = ($env.YABAI_PROCESS_ID? | default "")
            let app = (get-process-info $process_id)
            print $"[($time)] application_hidden: ($app)"
        }
        
        # Mission Control events
        "mission_control_enter" => {
            print $"[($time)] mission_control_enter"
        }
        
        "mission_control_exit" => {
            print $"[($time)] mission_control_exit"
        }
        
        # System events
        "dock_did_restart" => {
            print $"[($time)] dock_did_restart"
        }
        
        "menu_bar_hidden_changed" => {
            print $"[($time)] menu_bar_hidden_changed"
        }
        
        "dock_did_change_pref" => {
            print $"[($time)] dock_did_change_pref"
        }
        
        "system_woke" => {
            print $"[($time)] system_woke"
        }
        
        _ => {
            print $"[($time)] unknown_event: ($event)"
        }
    }
}
