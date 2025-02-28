if not set -q XDG_BASEDIRS_SET
    set_xdg_basedirs
    set -Ux XDG_BASEDIRS_SET true
end

set -gx EDITOR nvim
set -gx PAGER less
set -gx MANPAGER "nvim +Man!"
set -gx JJ_CONFIG "$XDG_CONFIG_HOME/jj/config.toml"

set -q MANPATH || set -gx MANPATH ''
for manpath in
    $__fish_data_dir/man \
        /opt/homebrew/share/man \
        /usr/local/share/man \
        /usr/share/man

    test -d $manpath && set -a MANPATH $manpath
end
