function reload_env
    op run -- true
    # Get secrets and format them as fish environment variables
    op item get --vault dev main --format json | jq -r '.fields | map(select(has("value"))) | map("set -gx " + .label + " \"" + .value + "\"") | join("\n")' >~/.op-env

    chmod 600 ~/.op-env
    source ~/.op-env
    echo "Environment reloaded"
end
