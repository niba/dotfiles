function fman
    set query (man -k . | fzf --exact -q "$argv[1]" --prompt='man> ' --preview "echo {} | tr -d '()' | awk '{printf \"%s \", \$2} {print \$1}' | xargs -r man | col -bx | bat -l man -p --color always'" | tr -d '()' | awk '{printf "%s ", $2} {print $1}')
    if test -n "$query"
        echo $query | xargs -r man
    end
end
