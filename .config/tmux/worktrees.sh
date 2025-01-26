#!/usr/bin/env bash

# Exit on error
set -e

# Get directory from tmux pane argument

current_dir=$(pwd)
echo "dir is $current_dir"
if [ -z "$current_dir" ]; then
  echo "❌ No directory provided"
  read -p "Press Enter to close..."
  exit 1
fi

# Ensure we're in a git repository
if ! git rev-parse --path-format=absolute --git-common-dir >/dev/null 2>&1; then
  echo "❌ Not in a git repository"
  read -p "Press Enter to close..."
  exit 1
fi

# Get git root directory and set worktrees directory next to it
git_root=$(git rev-parse --path-format=absolute --git-common-dir)
worktrees_dir="$git_root/branches"

# Select source branch
source_branch=$(git branch --all |
  grep -v HEAD |
  sed "s/.* //" |
  sed "s#remotes/origin/##" |
  sort -u |
  fzf --height 40% \
    --reverse \
    --prompt="Source Branch > " \
    --preview "git log -n 5 --oneline {}" \
    --preview-window=right:50%)

# Exit if no source branch selected
if [ -z "$source_branch" ]; then
  echo "No source branch selected"
  exit 1
fi

# Update only the selected source branch
echo "📥 Fetching source branch: $source_branch"
git fetch origin "$source_branch:$source_branch" || echo "⚠️  Warning: Couldn't fetch $source_branch"

# Select or create target branch
target_branch=$(git branch --all |
  grep -v HEAD |
  sed "s/.* //" |
  sed "s#remotes/origin/##" |
  sort -u |
  fzf --height 40% \
    --reverse \
    --prompt="Target Branch (Ctrl-x to create new) > " \
    --preview "git log -n 5 --oneline {}" \
    --preview-window=right:50% \
    --print-query \
    --bind "ctrl-x:print-query" |
  tail -1)

# Exit if no target branch selected
if [ -z "$target_branch" ]; then
  echo "No target branch selected"
  exit 1
fi

# Create sanitized directory name
sanitized_target=$(echo "$target_branch" | sed 's/[^a-zA-Z0-9]/_/g')
worktree_path="$worktrees_dir/$sanitized_target"

# Create worktree root folder
mkdir -p "$worktrees_dir"
# Check if target branch exists
if git show-ref --verify --quiet "refs/heads/$target_branch"; then
  # If target branch exists, create worktree with -f flag
  if git worktree add -f "$worktree_path" "$target_branch"; then
    echo "✅ Worktree created at $worktree_path"
    echo "  Using existing branch: $target_branch"
  else
    echo "❌ Failed to create worktree"
    exit 1
  fi
else
  # If target branch doesn't exist, create new one from source
  if git worktree add "$worktree_path" "$source_branch" -b "$target_branch"; then
    echo "✅ Worktree created at $worktree_path"
    echo "  Source branch: $source_branch"
    echo "  Target branch: $target_branch (new)"
  else
    echo "❌ Failed to create worktree"
    exit 1
  fi
fi
# Create tmux session name
root_dir_name=$(basename "$git_root") # This will get "ExecutiveAutomats" from the path
session_name="${root_dir_name}_${sanitized_target}"

# Create new tmux session if it doesn't exist
if ! tmux has-session -t "$session_name" 2>/dev/null; then
  tmux new-session -d -s "$session_name" -c "$worktree_path"
  echo "✅ Created tmux session: $session_name"
else
  echo "⚠️  Tmux session '$session_name' already exists"
fi

# Switch to the new session
if [ -n "$TMUX" ]; then
  tmux switch-client -t "$session_name"
else
  tmux attach-session -t "$session_name"
fi

read -p "Press Enter to close..."
