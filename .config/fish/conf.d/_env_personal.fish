if not set -q XDG_BASEDIRS_SET
    set_xdg_basedirs
    set -Ux XDG_BASEDIRS_SET true
end

set -gx EDITOR nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"
set -gx MISE_TRUSTED_CONFIG_PATHS "~/.config/:~/dotfiles/"
set -gx JJ_CONFIG "$XDG_CONFIG_HOME/jj/config.toml"

set -gx TOPIARY_CONFIG_FILE "$XDG_CONFIG_HOME/topiary/languages.ncl"
set -gx TOPIARY_LANGUAGE_DIR "$XDG_CONFIG_HOME/topiary/languages"

set -q MANPATH || set -gx MANPATH ''
for manpath in
    $__fish_data_dir/man \
        /opt/homebrew/share/man \
        /usr/local/share/man \
        /usr/share/man

    test -d $manpath && set -a MANPATH $manpath
end
