# Common configuration for all Darwin (macOS) hosts
{
  inputs,
  pkgs,
  lib,
  system,
  username,
  hostname,
  ...
}:
{
  # ============================================================================
  # Nix Configuration
  # ============================================================================

  # Determinate Nix handles nix configuration
  nix.enable = false;

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault system;
  };

  # ============================================================================
  # System Configuration
  # ============================================================================

  system = {
    stateVersion = 5;
    primaryUser = username;
  };

  # ============================================================================
  # User Configuration
  # ============================================================================

  users.knownUsers = [ username ];
  users.users.${username} = {
    name = username;
    uid = 501; # Default macOS first user UID
    home = "/Users/${username}";
    shell = pkgs.fish;
  };

  # Enable fish as a valid login shell
  programs.fish.enable = true;

  # Add fish to /etc/shells
  environment.shells = [ pkgs.fish ];

  # ============================================================================
  # System Packages (CLI tools via Nix)
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # Essential CLI
    coreutils
    git
    curl
    wget
    rsync
    tree
    gawk
    gnused
    openssl

    # Search & Navigation
    ripgrep
    fd
    fzf
    zoxide
    ast-grep

    # Modern Unix replacements
    bat # cat
    eza # ls
    dust # du
    difftastic
    diff-so-fancy
    delta # git-delta
    jless

    # File management
    yazi
    clipboard-jh # clipboard

    # Development - General
    gh
    gitleaks
    lazygit
    jujutsu
    jjui
    just
    chezmoi
    codex
    opencode

    # Git extras
    git-quick-stats
    git-who

    # Development - Languages & Runtimes
    #cmake
    #ninja
    #protobuf
    #luarocks

    # Development - Python
    #uv
    azure-cli

    # Editors
    neovim
    vim
    topiary

    # Shell & Terminal
    fish
    nushell
    starship
    tmux
    zellij
    vivid

    # JSON/Data
    jq

    # System & Monitoring
    btop
    htop
    lnav

    # Media
    ffmpeg
    ffmpegthumbnailer
    pandoc

    # Crypto & Security
    #gnupg
    #gpgme
    pam-reattach


    # Misc CLI tools
    stow
    mas # Mac App Store CLI
    mise
    pet # snippet manager

    # macOS window management & bar
    sketchybar
    jankyborders
  ];

  # ============================================================================
  # Fonts (via Nix)
  # ============================================================================

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.monaspace
    source-code-pro
  ];

  # ============================================================================
  # Shell Configuration
  # ============================================================================


  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # ============================================================================
  # Homebrew (GUI apps + special formulas needing taps/args)
  # ============================================================================

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    global.autoUpdate = true;

    taps = lib.mkAfter [
      "acsandmann/tap"
      "dimentium/autoraise"
      "jackielii/tap"
      "mhaeuser/mhaeuser"
    ];

    brews = [
      "acsandmann/tap/rift"
      "jackielii/tap/skhd-zig"


      {
        name = "dimentium/autoraise/autoraise";
        args = [ "with-dalternative_task_switcher" "with-dexperimental_focus_first" ];
      }
    ];

    # GUI applications via Homebrew Cask
    casks = [
      # Browsers
      "arc"
      "brave-browser"
      "chromium"
      "firefox"
      "google-chrome"
      "microsoft-edge"
      "zen"

      # Terminals & Editors
      "cursor"
      "ghostty"
      "iterm2"
      "kitty"
      "neovide-app"
      "visual-studio-code"
      "wezterm"
      "zed"

      # Development Tools
      "docker-desktop"
      "pgadmin4"
      "redis-insight"
      "yaak"

      # Window Management
      "alt-tab"
      "homerow"
      "kindavim"
      "wooshy"

      # Security & Passwords
      "1password"
      "1password-cli"
      "bitwarden"
      "nordvpn"

      # Productivity
      "libreoffice"
      "notion"
      "notion-calendar"
      "obsidian"
      "pdf-expert"
      "raycast"
      "readest"
      "ticktick"

      # Communication
      "discord"
      "microsoft-teams"
      "zoom"

      # Media & Entertainment
      "spotify"
      "tradingview"
      "vlc"

      # System Utilities
      "anybar"
      "the-unarchiver"
      "background-music"
      "battery-toolkit"
      "betterdisplay"
      "cleanshot"
      "helium"
      "jordanbaird-ice"
      "karabiner-elements"
      "logi-options+"

      # Fonts
      "font-fira-code"
      "font-monaspace"
      "font-source-code-pro"
    ];

    # Mac App Store apps (only App Store exclusives)
    masApps = {
      "Klack" = 6446206067;
      "HP Smart" = 1474276998;
      "rCmd" = 1596283165;
    };

    # Manual installs (not in Homebrew or App Store):
    # - Supercharge (Gumroad)
    # - xStation5 (XTB trading platform)
    # - AudezeHQ (Audeze headphone software)
  };

  # ============================================================================
  # Security
  # ============================================================================

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # ============================================================================
  # macOS System Defaults (extracted from your current settings)
  # ============================================================================

  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      autohide-delay = 0.2;
      launchanim = false;
      mineffect = "scale";
      minimize-to-application = true;
      mru-spaces = false; # Don't rearrange spaces based on recent use
      expose-group-apps = true; # Group windows by app in Mission Control
      show-recents = false;
      showhidden = false;
      tilesize = 37;
      largesize = 128; # Magnification size
    };

    # Finder
    finder = {
      FXPreferredViewStyle = "Nlsv"; # List view
      FXDefaultSearchScope = "SCcf"; # Search current folder by default
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowRemovableMediaOnDesktop = true;
    };

    # Screenshot - save to Documents
    screencapture.location = "~/Documents";

    # Menu bar clock
    menuExtraClock = {
      ShowAMPM = true;
      ShowDayOfWeek = true;
      ShowDate = 0; # Don't show date
    };

    # Window Manager
    WindowManager = {
      EnableStandardClickToShowDesktop = false; # Disable click wallpaper to show desktop
      StandardHideWidgets = true;
      HideDesktop = true;
    };

    # Global settings
    NSGlobalDomain = {
      # Appearance
      AppleInterfaceStyle = "Dark"; # Dark mode

      # Keyboard
      ApplePressAndHoldEnabled = false; # Disable press-and-hold for accent characters
      InitialKeyRepeat = 15; # Fast initial key repeat
      KeyRepeat = 2; # Fast key repeat rate
      AppleKeyboardUIMode = 3; # Full keyboard access in dialogs

      # Text correction
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = true;
      NSAutomaticQuoteSubstitutionEnabled = true;
      NSAutomaticDashSubstitutionEnabled = true;

      # Window behavior
      NSWindowShouldDragOnGesture = true; # Ctrl+Cmd+click to drag windows
      NSWindowResizeTime = 0.001; # Instant window resize animation

      # Scrolling & Navigation
      AppleEnableSwipeNavigateWithScrolls = false;

      # File dialogs
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      NSDocumentSaveNewDocumentsToCloud = false;
    };

    # Login
    loginwindow.GuestEnabled = false;

    # Don't quarantine downloaded apps
    LaunchServices.LSQuarantine = false;

    # Control Center - Menu Bar Items
    # true = show in menu bar, false = hide
    controlcenter = {
      AirDrop = false;
      BatteryShowPercentage = false;
      Bluetooth = false;

      # Display = true;
      # FocusModes = true;
      # NowPlaying = true;
      Sound = true;
    };
  };

  # ============================================================================
  # Power Management
  # ============================================================================

  # Power Management
  power.sleep.display = 20;

  # Disable Wake-on-LAN (Wake for network access = Never)
  networking.wakeOnLan.enable = false;

  # Note: Power Nap (powernap) is Intel-only, not applicable to Apple Silicon

  # ============================================================================
  # Custom User Preferences (additional plist settings)
  # ============================================================================

  system.defaults.CustomUserPreferences = {
    # Finder extras
    "com.apple.finder" = {
      _FXSortFoldersFirst = true; # Sort folders before files
      DisableAllAnimations = true;
      FXEnableExtensionChangeWarning = false;
      WarnOnEmptyTrash = false;
    };

    # Avoid .DS_Store on network/USB drives
    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    # Disable personalized ads
    "com.apple.AdLib" = {
      allowApplePersonalizedAdvertising = false;
    };

    # Prevent Photos from opening on device connect
    "com.apple.ImageCapture".disableHotPlug = true;

  };
}

