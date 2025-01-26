function reload_fish
    # Source all files in conf.d
    for file in ~/.config/fish/conf.d/*.fish
        source $file
    end

    # Source all files in functions
    for file in ~/.config/fish/functions/*.fish
        source $file
    end

    # Source the main config file
    source ~/.config/fish/config.fish

    echo "Fish configuration reloaded."
end
