const default_string_keys = ["app" "title" "grid"]

const yabai_commands_desc = {
  rule: {
    string_keys: $default_string_keys
    arguments: []
  }
  window: {
    string_keys: $default_string_keys
    arguments: ["grid" "space" "scratchpad"]
  }
}

export def build_params [spec cmd_type: string] {
  mut cmd_args = []

  let string_keys = $yabai_commands_desc | get $cmd_type | get string_keys
  let arguments = $yabai_commands_desc | get $cmd_type | get arguments

  for key in ($spec | columns) {
    let value = $spec | get $key

    let should_stringify = $key in $string_keys
    let is_argument = $key in $arguments

    if $is_argument {
      if $should_stringify {
        $cmd_args = $cmd_args ++ [$"--($key)" $"\"($value)\""]
      } else {
        $cmd_args = $cmd_args ++ [$"--($key)" $value]
      }
    } else {
      if $should_stringify {
        $cmd_args = $cmd_args ++ [$"($key)=\"($value)\""]
      } else {
        $cmd_args = $cmd_args ++ [$"($key)=($value)"]
      }
    }
  }

  return $cmd_args
}
