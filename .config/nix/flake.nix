{
  description = "Niba's nix-darwin configuration for macOS";

  # ============================================================================
  # Flake Inputs
  # ============================================================================

  inputs = {
    # Nixpkgs (stable)
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

    # nix-darwin
    nix-darwin = {
      url = "https://flakehub.com/f/nix-darwin/nix-darwin/0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Determinate Nix
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew integration
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  # ============================================================================
  # Flake Outputs
  # ============================================================================

  outputs =
    { self, ... }@inputs:
    let
      # ========================================================================
      # Configuration
      # ========================================================================

      # Your username (same on all machines)
      username = "niba";

      # Default system (Apple Silicon)
      defaultSystem = "aarch64-darwin";

      # Import library helpers
      libx = import ./lib { inherit inputs username; };

    in
    {
      # ========================================================================
      # Darwin Configurations
      # ========================================================================

      darwinConfigurations = {
        # Personal MacBook Pro
        niba-personal = libx.mkDarwin {
          hostname = "niba-personal";
          system = defaultSystem;
        };

        # Work MacBook Pro
        niba-job = libx.mkDarwin {
          hostname = "niba-job";
          system = defaultSystem;
        };
      };

      # ========================================================================
      # Development Shell
      # ========================================================================

      devShells.${defaultSystem}.default =
        let
          pkgs = import inputs.nixpkgs { system = defaultSystem; };
        in
        pkgs.mkShellNoCC {
          packages = with pkgs; [
            # Apply configuration script
            (writeShellApplication {
              name = "apply";
              runtimeInputs = [ inputs.nix-darwin.packages.${defaultSystem}.darwin-rebuild ];
              text = ''
                # Get hostname argument or default to niba-job
                HOST="''${1:-niba-job}"
                FLAKE_REF=".#$HOST"
                echo "🚀 Applying nix-darwin configuration for: $HOST"
                sudo darwin-rebuild switch --flake "$FLAKE_REF"
                echo "✅ Configuration applied successfully!"
              '';
            })

            # Formatter
            self.formatter.${defaultSystem}
          ];
        };

      # ========================================================================
      # Formatter
      # ========================================================================

      formatter.${defaultSystem} = inputs.nixpkgs.legacyPackages.${defaultSystem}.nixfmt-rfc-style;
    };
}
