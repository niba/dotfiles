#!/usr/bin/env python3

import json
import subprocess
import sys
from typing import Dict, List, Any

def run_command(command: List[str]) -> str:
    """Run a shell command and return its output."""
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running command {' '.join(command)}: {e}", file=sys.stderr)
        return ""

def run_command_ignore_error(command: List[str]) -> bool:
    """Run a shell command, ignoring errors (equivalent to 'try' in nushell)."""
    try:
        subprocess.run(command, capture_output=True, text=True, check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def get_config() -> Dict[str, Any]:
    """Get configuration - you'll need to implement this based on your config.nu."""
    # This is a placeholder - you'll need to implement the actual config loading
    # based on what your config.nu does
    try:
        # If you have a way to call nushell to get the config:
        result = subprocess.run(['nu', '-c', 'use config.nu; config get-config'], 
                              capture_output=True, text=True, check=True)
        return json.loads(result.stdout)
    except:
        # Fallback - define your config structure here
        return {
            "displays": ["main", "secondary"],
            "spaces": {
                "main": ["web", "code", "terminal"],
                "secondary": ["chat", "music"]
            }
        }

def main():
    config = get_config()
    
    # Label displays
    for display_index, display_label in enumerate(config["displays"], 1):
        print(f"Labeling display ({display_index}) as ({display_label})")
        run_command_ignore_error(["yabai", "-m", "display", str(display_index), "--label", display_label])
    
    # Calculate total spaces needed
    total_spaces_needed = sum(len(spaces) for spaces in config["spaces"].values())
    
    # Get current space count
    spaces_json = run_command(["yabai", "-m", "query", "--spaces"])
    current_spaces = json.loads(spaces_json) if spaces_json else []
    current_space_count = len(current_spaces)
    
    space_difference = total_spaces_needed - current_space_count
    
    # Create necessary spaces
    if space_difference > 0:
        for i in range(1, space_difference + 1):
            run_command_ignore_error(["yabai", "-m", "space", "--create"])
    
    # Remove excess spaces
    if space_difference < 0:
        spaces_to_remove = abs(space_difference)
        for i in range(1, spaces_to_remove + 1):
            spaces_json = run_command(["yabai", "-m", "query", "--spaces"])
            if spaces_json:
                spaces = json.loads(spaces_json)
                if spaces:
                    last_space_index = spaces[-1]["index"]
                    run_command_ignore_error(["yabai", "-m", "space", str(last_space_index), "--destroy"])
    
    # Assign spaces to displays
    space_assignments = []
    for display_label, spaces in config["spaces"].items():
        for space in spaces:
            space_assignments.append({
                "display_label": display_label,
                "space_label": space
            })
    
    for space_index, assignment in enumerate(space_assignments, 1):
        display_label = assignment["display_label"]
        space_label = assignment["space_label"]
        
        print(f"Assigning space [{space_index}]: {space_label} -> {display_label}")
        run_command_ignore_error(["yabai", "-m", "space", str(space_index), "--label", space_label])
        run_command_ignore_error(["yabai", "-m", "space", space_label, "--display", display_label])

if __name__ == "__main__":
    main()
