fish_add_path ~/.config/scripts

if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

status --is-interactive; and pyenv init --path | source


starship init fish | source
zoxide init fish | source
jj util completion fish | source

## BINDINGS
fish_default_key_bindings -M insert

fish_vi_key_bindings --no-erase insert

# dont close shell when empty (eof)
bind -M normal \cd true
bind \cd true
bind -M insert \cd true
##

# pnpm
set -gx PNPM_HOME /Users/niba/Library/pnpm
fish_add_path $PNPM_HOME
# pnpm end
#
fish_add_path /Users/niba/scripts

# generate secrets
if test ! -f ~/.op-env
    reload_env
end
source ~/.op-env

alias devturbo="/Users/niba/Documents/Projects/forks/turborepo/target/debug/turbo"
