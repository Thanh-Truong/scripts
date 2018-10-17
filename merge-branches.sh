: '
Merge all branches using Octupus merge mode
'
#!/bin/sh
function merge_branches() { 
    LIST_BRANCHES=''
    for branch in `git for-each-ref --sort='-committerdate' --format='%(refname)' refs/remotes/origin`;do
        LIST_BRANCHES="$LIST_BRANCHES  $branch"
    done
    echo $LIST_BRANCHES

    # Octupus merge = kinda of cool :D
    git merge $LIST_BRANCHES -m "dummy merge commit"
}

abort()
{
    echo "An error occurred. Aborting..." >&2
    git merge --abort
}

trap 'abort' 0
set -e
merge_branches
trap : 0
