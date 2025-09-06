export const MASTER_APPS = [
  "kitty",
  "Code"
]

# only for lsp autocompletion
# let displays = {}
# let spaces = {}

def get-single-display-config [] {
  {


  }
}

def get-multi-display-config [] {
  let spaces = {
    mac: "mac",
    dev_job_main: "dev_job_main",
    dev_job_helper: "dev_job_helper",
    dev_personal_main: "dev_personal_main",
    dev_personal_helper: "dev_personal_helper",
    other: "other",
    trash: "trash",
  }

  let displays = {
    main: "main",
    mac: "mac",
    small: "small",
  }

  {
    displays: [$displays.main, $displays.small, $displays.mac],
    devs: [
      [$spaces.dev_job_main, $spaces.dev_job_helper],
      [$spaces.dev_personal_main, $spaces.dev_personal_helper]
    ],
    spaces: {
      ($displays.main): [$spaces.dev_job_main, $spaces.dev_personal_main, $spaces.other],
      # we need at least two spaces on each display to make scratchpad windows work without moving relocating the window
      ($displays.mac): [$spaces.mac, $spaces.trash],
      ($displays.small): [$spaces.dev_job_helper, $spaces.dev_personal_helper],
    },
    apps: {
      ($spaces.mac): ["Microsoft Teams", "Discord", 
        { app: "Zen", title: "Picture-in-Picture", grid: "4:4:2:0:2:2" scratchpad: "videos" }, 
        # { app: "Arc", subrole:"AXSystemDialog", grid: "4:4:2:0:2:2" scratchpad: "videos"} 
      ]
      ($spaces.dev_job_main): [{ app: "kitty", title: "job"}, "Code", "Chrome$", { app: "Cursor", title: ".*xplus.*" }]
      ($spaces.dev_job_helper): [{ app: "Zen", title: "Work$" }] # "Arc$", 
      ($spaces.dev_personal_main): [{ app: "kitty", title: "personal" }, { app: "Cursor" }]
      ($spaces.dev_personal_helper): [{ app: "Zen", title: "Personal$" }, { app: "Readest", grid: "1:5:0:0:2:1", manage: "off" } ]
      ($spaces.other): ["Notion$", "Obsidian", "TradingView", "xStation5", "pgAdmin 4", "Postman", "Docker Desktop", "TickTick"]
    },
    rules: [
      { app: "Spotify", scratchpad: "music", grid: "10:10:1:1:8:8" }
      { app: "Notes", scratchpad: "notes", grid: "10:10:1:1:8:8" }
      # { app: "Raycast", title: "AI Chat", scratchpad: "ai", grid: "10:10:1:1:8:8" }
    ],
    unmanaged_apps: [
      "^System Preferences$",
      "^System Settings$", 
      "Shortcuts",
      "^Finder$",
      "Activity Monitor",
      "^Raycast$",
      "Calendar",
      "Calculator$",
      "Mouseless$",
      "League of Legends$",
      "Steam Helper",
      "1Password",
      # { app: "^(Arc)$" subrole: "^AXSystemDialog$" }
    ],
    layouts: {
      # default is stack
      smart: { 
        ($spaces.dev_job_main): {
          masters: ["kitty", "code"]
        }, 
        ($spaces.dev_personal_main): {
          masters: []
        } 
      },
      bsp: [],
    },
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

