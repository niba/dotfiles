function nvim
    # Determine if the current directory is inside a git repository
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        # Get the root directory of the Git repository
        set git_root (git rev-parse --git-dir | sed 's/\/worktrees\/.*//')

        # Get the current branch name
        set git_branch (git rev-parse --abbrev-ref HEAD)

        # Define the directory where you want to store your ShaDa files
        set shada_dir ~/.local/share/nvim/shada/project

        # Create the shada directory if it doesn't exist
        if not test -d $shada_dir
            mkdir -p $shada_dir
        end

        set normalized_path (string replace -r '[^a-zA-Z0-9]' '_' -- $git_root)
        set hashed_path (printf '%s' $normalized_path | shasum -a 256 | cut -d' ' -f1)

        # Normalize and hash the branch name
        set normalized_branch (string replace -r '[^a-zA-Z0-9]' '_' -- $git_branch)
        set hashed_branch (printf '%s' $normalized_branch | shasum -a 256 | cut -d' ' -f1)

        # Combine hashed path and branch for the ShaDa file name
        set shada_file $shada_dir/{$hashed_path}_{$hashed_branch}.shada

        # Start nvim with the project-specific shada file
        command nvim -i $shada_file $argv
    else
        # Start nvim normally if not in a git repository
        command nvim $argv
    end
end
