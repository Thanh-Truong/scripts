: '
Merge all branches using Octupus merge mode
'
#!/bin/sh
make_temp_folder() {
    TMPWORKDIR=$(basename $(mktemp -d -p /tmp))
    cd /tmp/$TMPWORKDIR
}

pull_octupus() {
    ADD_SECRET='ssh-add /etc/git-secret/ssh'
    GIT_CLONE='rm -rf scripts; git clone --branch master git@github.com:Thanh-Truong/scripts.git --no-checkout'
    GIT_CHECKOUT_MERGE_SCRIPT='cd scripts; git fetch; git checkout origin octupus-merge.sh; cd ..'
    ssh-agent sh -c "$ADD_SECRET; $GIT_CLONE"
    ssh-agent sh -c "$ADD_SECRET; $GIT_CHECKOUT_MERGE_SCRIPT"
}

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

#Removing rubbish upon exit
trap clean_up EXIT

make_temp_folder
pull_octupus
mv scripts/octupus-merge.sh $AIRFLOW__CORE__DAGS_FOLDER/octupus-merge.sh
chmod +x $AIRFLOW__CORE__DAGS_FOLDER/octupus-merge.sh
cd $AIRFLOW__CORE__DAGS_FOLDER
ssh-agent sh -c "$ADD_SECRET; ./octupus-merge.sh"
exit 0