#!/usr/bin/env nu

# Remove existing signals
print "Removing existing debug signals..."
yabai -m signal --list | lines | each {|line| 
    if ($line | str contains "label:debug_") {
        try {
            let label = ($line | parse "label:{label}" | get label.0)
            yabai -m signal --remove $label
        } catch { }
    }
}

# Add all debug signals - much cleaner now!
print "Adding debug signals..."

# Window signals
yabai -m signal --add label=debug_window_created event=window_created action='nu ~/.config/yabai/debug_utils.nu window_created'
yabai -m signal --add label=debug_window_destroyed event=window_destroyed action='nu ~/.config/yabai/debug_utils.nu window_destroyed'
yabai -m signal --add label=debug_window_focused event=window_focused action='nu ~/.config/yabai/debug_utils.nu window_focused'
yabai -m signal --add label=debug_window_moved event=window_moved action='nu ~/.config/yabai/debug_utils.nu window_moved'
yabai -m signal --add label=debug_window_resized event=window_resized action='nu ~/.config/yabai/debug_utils.nu window_resized'
yabai -m signal --add label=debug_window_minimized event=window_minimized action='nu ~/.config/yabai/debug_utils.nu window_minimized'
yabai -m signal --add label=debug_window_deminimized event=window_deminimized action='nu ~/.config/yabai/debug_utils.nu window_deminimized'
yabai -m signal --add label=debug_window_title_changed event=window_title_changed action='nu ~/.config/yabai/debug_utils.nu window_title_changed'

# Space signals
yabai -m signal --add label=debug_space_created event=space_created action='nu ~/.config/yabai/debug_utils.nu space_created'
yabai -m signal --add label=debug_space_destroyed event=space_destroyed action='nu ~/.config/yabai/debug_utils.nu space_destroyed'
yabai -m signal --add label=debug_space_changed event=space_changed action='nu ~/.config/yabai/debug_utils.nu space_changed'

# Display signals
yabai -m signal --add label=debug_display_added event=display_added action='nu ~/.config/yabai/debug_utils.nu display_added'
yabai -m signal --add label=debug_display_removed event=display_removed action='nu ~/.config/yabai/debug_utils.nu display_removed'
yabai -m signal --add label=debug_display_moved event=display_moved action='nu ~/.config/yabai/debug_utils.nu display_moved'
yabai -m signal --add label=debug_display_resized event=display_resized action='nu ~/.config/yabai/debug_utils.nu display_resized'
yabai -m signal --add label=debug_display_changed event=display_changed action='nu ~/.config/yabai/debug_utils.nu display_changed'

# Application signals
yabai -m signal --add label=debug_application_launched event=application_launched action='nu ~/.config/yabai/debug_utils.nu application_launched'
yabai -m signal --add label=debug_application_terminated event=application_terminated action='nu ~/.config/yabai/debug_utils.nu application_terminated'
yabai -m signal --add label=debug_application_front_switched event=application_front_switched action='nu ~/.config/yabai/debug_utils.nu application_front_switched'
yabai -m signal --add label=debug_application_activated event=application_activated action='nu ~/.config/yabai/debug_utils.nu application_activated'
yabai -m signal --add label=debug_application_deactivated event=application_deactivated action='nu ~/.config/yabai/debug_utils.nu application_deactivated'
yabai -m signal --add label=debug_application_visible event=application_visible action='nu ~/.config/yabai/debug_utils.nu application_visible'
yabai -m signal --add label=debug_application_hidden event=application_hidden action='nu ~/.config/yabai/debug_utils.nu application_hidden'

# Mission Control signals
yabai -m signal --add label=debug_mission_control_enter event=mission_control_enter action='nu ~/.config/yabai/debug_utils.nu mission_control_enter'
yabai -m signal --add label=debug_mission_control_exit event=mission_control_exit action='nu ~/.config/yabai/debug_utils.nu mission_control_exit'

# System signals
yabai -m signal --add label=debug_dock_did_restart event=dock_did_restart action='nu ~/.config/yabai/debug_utils.nu dock_did_restart'
yabai -m signal --add label=debug_menu_bar_hidden_changed event=menu_bar_hidden_changed action='nu ~/.config/yabai/debug_utils.nu menu_bar_hidden_changed'
yabai -m signal --add label=debug_dock_did_change_pref event=dock_did_change_pref action='nu ~/.config/yabai/debug_utils.nu dock_did_change_pref'
yabai -m signal --add label=debug_system_woke event=system_woke action='nu ~/.config/yabai/debug_utils.nu system_woke'

print "Debug signals added!"
print "To remove all debug signals later, run: nu ~/.config/yabai/debug.nu --cleanup"

# Cleanup option
if ($env.argv? | default [] | any {|arg| $arg == "--cleanup"}) {
    print "Removing debug signals..."
    yabai -m signal --list | lines | each {|line| 
        if ($line | str contains "label:debug_") {
            try {
                let label = ($line | parse "label:{label}" | get label.0)
                yabai -m signal --remove $label
            } catch { }
        }
    }
    print "All debug signals removed!"
}
