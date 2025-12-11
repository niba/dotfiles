{
  inputs,
  username,
  ...
}:
{
  # Helper function to create Darwin (macOS) configurations
  mkDarwin =
    {
      hostname,
      system ? "aarch64-darwin",
    }:
    let
      # Check if a custom host-specific config exists
      customConfPath = ./../hosts/darwin/${hostname};
      customConf =
        if builtins.pathExists customConfPath then
          (customConfPath + "/default.nix")
        else
          ./../hosts/common/darwin-common.nix;
    in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs system username hostname;
      };
      modules = [
        # Determinate Nix module
        inputs.determinate.darwinModules.default

        # Common Darwin configuration
        ./../hosts/common/darwin-common.nix

        # Host-specific configuration (if exists)
        customConf

        # Homebrew integration via nix-homebrew
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            autoMigrate = true;
            
            mutableTaps = true;
            user = username;
            taps = with inputs; {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
          };
        }

        # Align homebrew.taps with nix-homebrew.taps
        (
          { config, ... }:
          {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
          }
        )

        # Set networking hostname
        { networking.hostName = hostname; }
      ];
    };
}

