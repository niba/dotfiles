export const MASTER_APPS = [
  "kitty"
  "Code"
]

const unmanaged_apps = [
  "^System Preferences$"
  "^System Settings$"
  "Shortcuts"
  "^Finder$"
  "Activity Monitor"
  "^Raycast$"
  "Calendar"
  "Calculator$"
  "Mouseless$"
  "League of Legends$"
  "Steam Helper"
  "1Password"
  {app: "Arc" title: ""}
]

# only for lsp autocompletion
# let displays = {}
# let spaces = {}

def get-single-display-config [] {
  let spaces = {
    utils: "utils"
    dev_job: "dev_job"
    dev_personal: "dev_personal"
    other: "other"
  }

  let displays = {
    mac: "mac"
  }

  {
    displays: [$displays.mac]
    devs: [
      [$spaces.dev_job]
      [$spaces.dev_personal]
    ]
    spaces: {
      ($displays.mac): [$spaces.dev_job $spaces.dev_personal $spaces.utils $spaces.other]
    }
    apps: {
      ($spaces.utils): [
        "Microsoft Teams"
        "Discord"
        "Messenger"
      ]

      ($spaces.dev_job): [{app: "kitty" title: "job"} "Chrome$" {app: "Cursor" title: ".*xplus.*"} {app: "Code" title: ".*xplus.*"} {app: "Zen" title: "Work$"}]
      ($spaces.dev_personal): [{app: "kitty" title: "personal"} {app: "Cursor" "title!": ".*xplus.*"} {app: "Code" "title!": ".*xplus.*"} {app: "Zen" title: "Personal$"} {app: "Readest" grid: "1:5:0:0:2:1" manage: "off"} {app: "Reader" grid: "1:5:0:0:2:1" manage: "off"}]
      ($spaces.other): ["Notion$" "Obsidian" "TradingView" "xStation5" "pgAdmin 4" "Postman" "Docker Desktop" "TickTick"]
    }
    special: {
      arc_windows: [$spaces.dev_job $spaces.dev_personal]
      arc_pip: {
        grid: "6:6:4:1:1:1"
        scratchpad: "videos"
      }
    }
    rules: [
      {app: "Zen" title: "Picture-in-Picture" grid: "5:5:4:0:1:1" scratchpad: "videos"}
      {app: "Spotify" scratchpad: "music" grid: "10:10:1:1:8:8"}
      {app: "Notes" scratchpad: "notes" grid: "10:10:1:1:8:8"}
    ]
    unmanaged_apps: $unmanaged_apps
    layouts: {
      # default is stack
      smart: {
        ($spaces.dev_job): {
          masters: ["kitty" "code"]
        }
        ($spaces.dev_personal): {
          masters: []
        }
      }
      bsp: []
    }
  }
}

def get-multi-display-config [] {
  let spaces = {
    mac: "mac"
    dev_job_main: "dev_job_main"
    dev_job_helper: "dev_job_helper"
    dev_personal_main: "dev_personal_main"
    dev_personal_helper: "dev_personal_helper"
    other: "other"
    trash: "trash"
  }

  let displays = {
    main: "main"
    mac: "mac"
    small: "small"
  }

  {
    displays: [$displays.main $displays.small $displays.mac]
    devs: [
      [$spaces.dev_job_main $spaces.dev_job_helper]
      [$spaces.dev_personal_main $spaces.dev_personal_helper]
    ]
    spaces: {
      ($displays.main): [$spaces.dev_job_main $spaces.dev_personal_main $spaces.other]
      # we need at least two spaces on each display to make scratchpad windows work without moving relocating the window
      ($displays.mac): [$spaces.mac $spaces.trash]
      ($displays.small): [$spaces.dev_job_helper $spaces.dev_personal_helper]
    }
    apps: {
      ($spaces.mac): [
        "Microsoft Teams"
        "Discord"
        {app: "Zen" title: "Picture-in-Picture" grid: "6:6:2:0:2:2" scratchpad: "videos"}
      ]
      ($spaces.dev_job_main): [{app: "kitty" title: "job"} {app: "Code" title: ".*xplus.*"} "Chrome$" {app: "Cursor" title: ".*xplus.*"}]
      ($spaces.dev_job_helper): [{app: "Zen" title: "Work$"}] # "Arc$", 
      ($spaces.dev_personal_main): [{app: "kitty" title: "personal"} {app: "Cursor" "title!": ".*xplus.*"} {app: "Code" "title!": ".*xplus.*"}]
      ($spaces.dev_personal_helper): [
        {app: "Zen" title: "Personal$"}
        {app: "Readest" grid: "1:5:0:0:2:1" manage: "off"}
        {app: "Reader" grid: "1:5:0:0:2:1" manage: "off"}
      ]
      ($spaces.other): ["Notion$" "Obsidian" "TradingView" "xStation5" "pgAdmin 4" "Postman" "Docker Desktop" "TickTick"]
    }
    special: {
      arc_windows: [$spaces.dev_job_helper $spaces.dev_personal_helper]
      arc_pip: {
        grid: "6:6:2:0:2:2"
        scratchpad: "videos"
        space: $spaces.mac
      }
    }
    rules: [
      {app: "Spotify" scratchpad: "music" grid: "10:10:1:1:8:8"}
      {app: "Notes" scratchpad: "notes" grid: "10:10:1:1:8:8"}
    ]
    unmanaged_apps: $unmanaged_apps
    layouts: {
      # default is stack
      smart: {
        ($spaces.dev_job_main): {
          masters: ["kitty" "code"]
        }
        ($spaces.dev_personal_main): {
          masters: []
        }
      }
      bsp: []
    }
  }
}

# Multi display config
export def get-config [] {
  let displays_count = (yabai -m query --displays | from json | length)

  if $displays_count == 1 {
    get-single-display-config
  } else {
    get-multi-display-config
  }
}
