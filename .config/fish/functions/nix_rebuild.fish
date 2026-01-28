function nix_rebuild
    sudo darwin-rebuild switch --flake ~/.config/nix#(scutil --get LocalHostName)
end
