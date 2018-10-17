: '
Merge all branches using Octupus merge mode
'
#!/bin/sh

TMPWORKDIR=$(basename $(mktemp -d -p /tmp))
cd /tmp/$TMPWORKDIR

ADD_SECRET='ssh-add /etc/git-secret/ssh'
GIT_CLONE='rm -rf scripts; git clone --branch master git@github.com:Thanh-Truong/scripts.git --no-checkout'
GIT_CHECKOUT_MERGE_SCRIPT='cd scripts; git fetch; git checkout origin octupus-merge.sh; cd ..'

# Pulling the Octupus script 'merge-branches.sh'
ssh-agent sh -c "$ADD_SECRET; $GIT_CLONE"
ssh-agent sh -c "$ADD_SECRET; $GIT_CHECKOUT_MERGE_SCRIPT"

chmod +x octupus-merge.sh

# Clean up
clean_up(){
    echo "Cleaning $TMPWORKDIR"
    cd /tmp
    rm -rf $TMPWORKDIR
    unset TMPWORKDIR
    unset ADD_SECRET
    unset GIT_CLONE
    unset GIT_CHECKOUT_MERGE_SCRIPT
}

trap clean_up EXIT