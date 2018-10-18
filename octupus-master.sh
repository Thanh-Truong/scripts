: '
Merge all branches using Octupus merge mode
'
#!/bin/sh
make_temp_folder() {
    TMPWORKDIR=$(basename $(mktemp -d -p /tmp))
    cd /tmp/$TMPWORKDIR
}

setup_git() {
    ADD_SECRET='ssh-add /etc/git-secret/ssh'
    GIT_CLONE='git clone --branch master $1 $2'
    echo "Setting Git..." $GIT_CLONE
}

pull_octupus() {
    echo "Pulling Octupus .... done"
    setup_git "git@github.com:Thanh-Truong/scripts.git" "--no-checkout"
    GIT_CHECKOUT_MERGE_SCRIPT='git fetch; git checkout origin octupus-merge.sh'
    ssh-agent sh -c "$ADD_SECRET; rm -rf scripts; $GIT_CLONE"
    ssh-agent sh -c "$ADD_SECRET; cd scripts; $GIT_CHECKOUT_MERGE_SCRIPT; cd .."
    echo "Pulling Octupus .... done"
}

pull_repo() {
    echo "Pulling Repo .... done"
    setup_git "git@github.com:TV4/data-airflow-dags.git" ""
    ssh-agent sh -c "$ADD_SECRET; rm -rf data-airflow-dags; $GIT_CLONE"
    mv scripts/octupus-merge.sh data-airflow-dags/octupus-merge.sh
    cd data-airflow-dags
    chmod +x octupus-merge.sh
    ssh-agent sh -c "$ADD_SECRET; ./octupus-merge.sh"
    cd ..
    echo "Pulling Repo .... done"
}

# Clean up
clean_up(){
    echo "Cleaning /tmp/$TMPWORKDIR"
    #cd /tmp
    #rm -rf $TMPWORKDIR
    unset TMPWORKDIR
    unset ADD_SECRET
    unset GIT_CLONE
    unset GIT_CHECKOUT_MERGE_SCRIPT
}

#Removing rubbish upon exit
trap clean_up EXIT

make_temp_folder
pull_octupus
pull_repo

#mv scripts/octupus-merge.sh $AIRFLOW__CORE__DAGS_FOLDER/octupus-merge.sh
#chmod +x $AIRFLOW__CORE__DAGS_FOLDER/octupus-merge.sh
#cd $AIRFLOW__CORE__DAGS_FOLDER
#ssh-agent sh -c "$ADD_SECRET; ./octupus-merge.sh"
exit 0