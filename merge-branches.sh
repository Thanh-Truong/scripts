: '
Merge all branches using Octupus merge mode
'
#!/bin/sh

TMPWORKDIR=$(basename $(mktemp -d -p /tmp))
cd /tmp/$TMPWORKDIR

ADD_SECRET='ssh-add /etc/git-secret/ssh'
GIT_CLONE='rm -rf scripts; git clone --branch master git@github.com:Thanh-Truong/scripts.git --no-checkout'
GIT_CHECKOUT_MERGE_SCRIPT='cd scripts; git fetch; git checkout origin merge-branches.sh; cd ..'

# Pulling the Octupus script 'merge-branches.sh'
ssh-agent sh -c "$ADD_SECRET; $GIT_CLONE"
ssh-agent sh -c "$ADD_SECRET; $GIT_CHECKOUT_MERGE_SCRIPT"

chmod +x merge-branches.sh

# Clean up
clean_up(){
    cd /tmp
    rm -rf $TMPWORKDIR
    unset TMPWORKDIR
    unset ADD_SECRET
    unset GIT_CLONE
    unset GIT_CHECKOUT_MERGE_SCRIPT
}

merge_branches() { 
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

trap cleanup EXIT