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
      ($displays.mac): [$spaces.mac],
      ($displays.small): [$spaces.dev_job_helper, $spaces.dev_personal_helper],
    },
    apps: {
      ($spaces.mac): ["Microsoft Teams", "Discord", { app: "Zen", title: "Picture-in-Picture", grid: "6:6:4:0:2:2" scratchpad: "videos" } ]
      ($spaces.dev_job_main): [{ app: "kitty", title: "work"}, "Code", "Chrome$"]
      ($spaces.dev_job_helper): ["Arc$", { app: "Zen", title: "Work$" }]
      ($spaces.dev_personal_main): [{ app: "kitty", title: "private" }]
      ($spaces.dev_personal_helper): [{ app: "Zen", title: "Personal$" }]
      ($spaces.other): ["Notion$", "Obsidian"]
      ($spaces.trash): []
    },
    unmanaged_apps: [
      "^System Preferences$",
      "^System Settings$", 
      "^Finder$",
      "Activity Monitor",
      "^Raycast$",
      "Calendar",
      "Calculator$",
      "Mouseless$",
      "League of Legends$",
      "Steam Helper",
      "1Password",
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

