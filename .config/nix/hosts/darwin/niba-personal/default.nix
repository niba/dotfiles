# Host-specific configuration for niba-personal (personal MacBook Pro)
{ pkgs, ... }:
{
  # ============================================================================
  # Personal Machine Specific Packages
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # Add personal-specific packages here
  ];

  # ============================================================================
  # Personal Homebrew Apps
  # ============================================================================

  homebrew = {
    casks = [
      # Personal apps
      "spotify"
      "steam"
      "vlc"
      # Add more personal apps here
    ];

    masApps = {
      # Personal Mac App Store apps
      # "App Name" = app_id;
    };
  };

  # ============================================================================
  # Personal Dock Configuration
  # ============================================================================

  system.defaults.dock.persistent-apps = [
    "/Applications/Google Chrome.app"
    "/Applications/Firefox.app"
    "/Applications/Obsidian.app"
    "/Applications/Visual Studio Code.app"
    "/Applications/Spotify.app"
    "/Applications/Ghostty.app"
  ];
}

