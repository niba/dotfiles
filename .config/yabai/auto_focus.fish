#!/usr/bin/env fish

while true
    if yabai -m config focus_follows_mouse off
        echo "yabai command successful"
        sleep 60
    else
        echo "yabai command failed, waiting 60 seconds before retry..."
        sleep 60
    end
end
