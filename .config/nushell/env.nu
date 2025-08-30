# env.nu
#
# Installed by:
# version = "0.106.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.
#
$env.CARAPACE_BRIDGES = "inshellisense,carapace,zsh,fish,bash" 

$env.config.keybindings = [
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "do {
          $env.SHELL = /bin/bash
          commandline edit --insert (
            history
            | get command
            | reverse
            | uniq
            | str join (char -i 0)
            | fzf --scheme=history 
                --read0
                --layout=reverse
                --height=40%
                --bind 'ctrl-/:change-preview-window(right,70%|right)'
                --preview='echo -n {} | nu --stdin -c \'nu-highlight\''
                # Run without existing commandline query for now to test composability
                # -q (commandline)
            | decode utf-8
            | str trim
          )
        }"
      }
    ]
  }
]
$env.config.menus ++= [{
      name: completion_menu
      only_buffer_difference: false
      marker: "| "
      type: {
          layout: ide
          border: false
      }
      style: {
          text: white
          selected_text: white
          description_text: yellow
          match_text: { attr: u }
          selected_match_text: { attr: ur }
      }
}, {
    name: history_menu
    only_buffer_difference: true
    marker: "| "
    type: {
      layout: list
      page_size: 10
    }
    style: {
      text: white
      selected_text: white_reverse
    }
  }]
$env.config.completions.use_ls_colors = false
$env.config.use_kitty_protocol = true
# if ( '~/.inshellisense/nu/init.nu' | path exists ) { source ~/.inshellisense/nu/init.nu }
