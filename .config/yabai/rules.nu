#!/usr/bin/env nu

use ~/.config/yabai/config.nu *
use ~/.config/yabai/utils.nu *

let config = (get-config)

# move all windows not defined in config
# disabled because causes some popup windows to change space on opening 
# yabai -m rule --add app="^.*$" space=trash

def build_yabai_rule [rule_spec space = null] {
  mut rule_args = []
  let params = (build_params $rule_spec "rule")

  print $"rule: ($params | str join ' ')"
  try { yabai -m rule --add ...$params }
}

for space in ($config.apps | transpose key value) {
  for app in $space.value {
    mut rule_spec = $app
    if ($app | describe) == "string" {
      $rule_spec = {app: $app}
    }
    $rule_spec = $rule_spec | insert space $space.key
    build_yabai_rule $rule_spec
  }
}

for app in $config.unmanaged_apps {
  if ($app | describe) == "string" {
    let rule_spec = {app: $app manage: "off"}
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
