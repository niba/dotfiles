fish_add_path ~/.config/scripts

if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
zoxide init fish | source
jj util completion fish | source
mise activate fish | source

# test -f ~/.inshellisense/fish/init.fish && source ~/.inshellisense/fish/init.fish
# set -Ux CARAPACE_BRIDGES 'fish,inshellisense'
# set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
# carapace _carapace | source

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
    reload_variables
end
source ~/.op-env

