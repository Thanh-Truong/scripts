: '
Merge all branches using Octupus merge mode
'
#!/bin/sh

read_including_branches() {
    READ_BRANCHES=""
    for line in $(cat octupus.config); do
        READ_BRANCHES="$line,$READ_BRANCHES"
    done
    echo "Before array: " "$READ_BRANCHES"
    INCLUDING_BRANCHES=$READ_BRANCHES
    echo $INCLUDING_BRANCHES
}

merge_branches() { 
    LIST_BRANCHES=''
    for full_branch in `git for-each-ref --sort='-committerdate' --format='%(refname)' refs/remotes/origin`;do
        short_branch=${full_branch:20:${#full_branch}}
        for included_branch in $INCLUDING_BRANCHES; do
            #echo "Full:" $full_branch " Short: " $short_branch " Included: " $included_branch
            if [[ $included_branch == *$short_branch* ]]; then
                #echo "Hit"
                LIST_BRANCHES="$LIST_BRANCHES  $full_branch"
            fi
        done
    done
    echo $LIST_BRANCHES

    # Octupus merge = kinda of cool :D
    git merge $LIST_BRANCHES -m 'octupus commit'
}

abort()
{
    echo "An error occurred. Aborting..." >&2
    git merge --abort
}

trap 'abort' 0
set -e
read_including_branches
merge_branches "$1"
trap : 0