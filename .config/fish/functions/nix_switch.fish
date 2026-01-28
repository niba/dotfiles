function nix_switch
    sudo darwin-rebuild switch --flake ~/.config/nix#(scutil --get LocalHostName)
end
