#!/usr/bin/env bash

# This is modified session script taken from tmux-fzf
# sort sessions by date
# display current git branch
# display last attached dat
cd "$HOME/.config/tmux/plugins/tmux-fzf/scripts/" || exit

CURRENT_DIR="$(pwd)"
source "$CURRENT_DIR/.envs"

current_session=$(tmux display-message -p | sed -e 's/^\[//' -e 's/\].*//')
sessions=$(tmux list-sessions -F '#S: [#{window_name}] #{pane_current_command} #{session_last_attached} #{pane_current_path}' | grep -v "^$current_session: " | awk '{print $0 " | " $(NF-1)}' | sort -t '|' -k2,2nr | while IFS='|' read -r line last_attached; do
  session_info=$(echo $line | awk '{$NF=""; print $0}')
  last_attached_date=$(date -r "$last_attached" "+%Y-%m-%d %H:%M:%S")

  # Extract the pane_current_path
  pane_path=$(echo $line | awk '{print $NF}')

  # Get the git branch
  branch=$(cd "$pane_path" 2>/dev/null && git symbolic-ref --short HEAD 2>/dev/null)

  # Remove the pane_current_path from the output
  session_info=$(echo $session_info | awk '{$NF=""; print $0}')

  if [ -n "$branch" ]; then
    echo "$session_info [$last_attached_date] ($branch)"
  else
    echo "$session_info [$last_attached_date]"
  fi
done)

FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select an action.'"
if [[ -z "$1" ]]; then
  action=$(printf "switch\nnew\nrename\ndetach\nkill\n[cancel]" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS")
else
  action="$1"
fi

[[ "$action" == "[cancel]" || -z "$action" ]] && exit
if [[ "$action" != "detach" ]]; then
  if [[ "$action" == "new" ]]; then
    tmux split-window -v -p 30 -b -c '#{pane_current_path}' \
      "bash -c 'printf \"Session Name: \" && read session_name && tmux new-session -d -s \"\$session_name\" && tmux switch-client -t \"\$session_name\"'"
    exit
  fi
  if [[ "$action" == "kill" ]]; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select target session(s). Press TAB to mark multiple items.'"
  else
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select target session.'"
  fi
  if [[ "$action" == "switch" ]]; then
    target_origin=$(printf "%s\n[cancel]" "$sessions" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS $TMUX_FZF_PREVIEW_OPTIONS")
  else
    target_origin=$(printf "[current]\n%s\n[cancel]" "$sessions" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS $TMUX_FZF_PREVIEW_OPTIONS")
    target_origin=$(echo "$target_origin" | sed -E "s/\[current\]/$current_session:/")
  fi
else
  tmux_attached_sessions=$(tmux list-sessions | grep 'attached' | grep -o '^[[:alpha:][:digit:]_-]*:' | sed 's/.$//g')
  sessions=$(echo "$sessions" | grep "^$tmux_attached_sessions")
  FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select target session(s). Press TAB to mark multiple items.'"
  target_origin=$(printf "[current]\n%s\n[cancel]" "$sessions" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS $TMUX_FZF_PREVIEW_OPTIONS")
  target_origin=$(echo "$target_origin" | sed -E "s/\[current\]/$current_session:/")
fi
[[ "$target_origin" == "[cancel]" || -z "$target_origin" ]] && exit
target=$(echo "$target_origin" | sed -e 's/:.*$//')
if [[ "$action" == "switch" ]]; then
  tmux switch-client -t "$target"
elif [[ "$action" == "detach" ]]; then
  echo "$target" | xargs -I{} tmux detach -s "{}"
elif [[ "$action" == "kill" ]]; then
  echo "$target" | sort -r | xargs -I{} tmux kill-session -t "{}"
elif [[ "$action" == "rename" ]]; then
  tmux command-prompt -I "rename-session -t \"$target\" "
fi
