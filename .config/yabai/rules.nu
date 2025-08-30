#!/usr/bin/env nu

use ~/.config/yabai/config.nu *
let config = (get-config)

# Helper function to build yabai rule command
def build_yabai_rule [rule_spec, space = null] {
   mut rule_args = []
    let stringify_keys = ["app", "title", "role", "subrole"]
    
    if ($rule_spec | describe) == "string" {
        $rule_args = $rule_args ++ [$"app=($rule_spec)"]
    } else {
        # Build string from record
        for key in ($rule_spec | columns) {
            let value = $rule_spec | get $key
            if $key in $stringify_keys {
                $rule_args = $rule_args ++ [$"($key)=($value)"]
            } else {
                $rule_args = $rule_args ++ [$"($key)=($value)"]
            }
        }
    }
    
    if $space != null {
        $rule_args = $rule_args ++ [$"space=($space)"]
    }
    
    print $"rule: ($rule_args | str join ' ')"
    try { yabai -m rule --add ...$rule_args }
}

# Apply space rules
for space in ($config.apps | transpose key value) {
    for app in $space.value {
        build_yabai_rule $app $space.key
    }
}

# Apply unmanaged rules
for app in $config.unmanaged_apps {
    if ($app | describe) == "string" {
        # Create a record with manage=off for consistency
        let rule_spec = { app: $app, manage: "off" }
        build_yabai_rule $rule_spec
    } else {
        # For objects, check if manage is already specified
        mut rule_spec = $app
        if not ("manage" in ($app | columns)) {
            $rule_spec = $rule_spec | insert manage "off"
        }
        build_yabai_rule $rule_spec
    }
}
