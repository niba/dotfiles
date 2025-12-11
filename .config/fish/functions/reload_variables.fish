function reload_variables
    op run -- true
    op item get --vault dev main --format json | jq -r '.fields | map(select(has("value"))) | map("set -gx " + .label + " \"" + .value + "\"") | join("\n")' >~/.op-env

    chmod 600 ~/.op-env
    source ~/.op-env
    echo "Env variables reloaded"
end
