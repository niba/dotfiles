function reload_variables
    op run -- true
    # Get secrets and format them as fish environment variables
    op item get --vault dev main --format json | jq -r '.fields | map(select(has("value"))) | map("set -gx " + .label + " \"" + .value + "\"") | join("\n")' >~/tmp/.op-env

    chmod 600 ~/tmp/.op-env
    source ~/tmp/.op-env
    echo "Environment reloaded"
end
