# Host-specific configuration for niba-job (work MacBook Pro)
{ pkgs, ... }:
{
  # ============================================================================
  # Work Machine Specific Packages
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # Add work-specific packages here
  ];

  # ============================================================================
  # Work Homebrew Apps
  # ============================================================================

  homebrew = {
    casks = [
      # Work-specific apps
      # Add more work apps here
    ];

    masApps = {
      # Work Mac App Store apps
      # "App Name" = app_id;
    };
  };

  # ============================================================================
  # Work Dock Configuration
  # ============================================================================

  system.defaults.dock.persistent-apps = [
  # Calendar
    "/System/Applications/Calendar.app"
    # Gmail (Chrome App)
    "~/Applications/Chrome Apps/Gmail.app"
    # Microsoft Outlook
    "/Applications/Microsoft Outlook.app"
    # Apple Notes
    "/System/Applications/Notes.app"
    # 1Password
    "/Applications/1Password.app"
    # Kitty
    "/Applications/kitty.app"
    # Ghostty
    "/Applications/Ghostty.app"
    # Cursor
    "/Applications/Cursor.app"
    # VS Code
    "/Applications/Visual Studio Code.app"
    # Microsoft Teams
    "/Applications/Microsoft Teams.app"
    # Discord
    "/Applications/Discord.app"
    # Messenger (Chrome App)
    "~/Applications/Chrome Apps/Messenger.app"
    # Twitter (Chrome App)
    "~/Applications/Chrome Apps/Twitter.app"
    # TradingView
    "/Applications/TradingView.app"
  ];
}

