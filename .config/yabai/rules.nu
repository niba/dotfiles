#!/usr/bin/env nu

use ~/.config/yabai/config.nu *
let config = (get-config)

# move all windows not defined in config
# disabled because causes some popup windows to change space on opening 
# yabai -m rule --add app="^.*$" space=trash

def build_yabai_rule [rule_spec, space = null] {
   mut rule_args = []
    let stringify_keys = ["app", "title", "role", "subrole"]
    
    if ($rule_spec | describe) == "string" {
        $rule_args = $rule_args ++ [$"app=($rule_spec)"]
    } else {
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

for space in ($config.apps | transpose key value) {
    for app in $space.value {
        build_yabai_rule $app $space.key
    }
}

for app in $config.unmanaged_apps {
    if ($app | describe) == "string" {
        let rule_spec = { app: $app, manage: "off" }
        build_yabai_rule $rule_spec
    } else {
        mut rule_spec = $app
        if not ("manage" in ($app | columns)) {
            $rule_spec = $rule_spec | insert manage "off"
        }
        build_yabai_rule $rule_spec
    }
}

for app in $config.rules {
  build_yabai_rule $app
}

