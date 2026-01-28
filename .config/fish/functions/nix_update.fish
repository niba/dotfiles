function nix_update
    set -l flake_dir ~/.config/nix

    if test (count $argv) -eq 0
        echo "Updating all flake inputs..."
        nix flake update --flake $flake_dir
    else
        echo "Updating $argv[1]..."
        nix flake update $argv[1] --flake $flake_dir
    end

    nix_rebuild
end
