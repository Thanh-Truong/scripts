: '
Merge all branches using Octupus merge mode
'
#!/bin/sh
make_temp_folder() {
    TMPWORKDIR=$(basename $(mktemp -d -p /tmp))
    cd /tmp/$TMPWORKDIR
    echo "Temp directory:" $TMPWORKDIR
}

setup_git() {
    echo "Setting Git.................."
    eval "$(ssh-agent -s)"
    ssh-add /etc/git-secret/ssh
}

clone_repo() {
    echo "Cloning repo $1 $2 ..........."
    git clone --branch master $1 $2  
}

pull_octupus() {
    echo "Pulling Octupus ..............."
    rm -rf scripts
    clone_repo "git@github.com:Thanh-Truong/scripts.git" "--no-checkout"
    git fetch && git checkout origin octupus-merge.sh
}

pull_repo() {
    echo "Pulling Repo ....................."
    rm -rf data-airflow-dags
    clone_repo "git@github.com:TV4/data-airflow-dags.git" ""    
    mv scripts/octupus-merge.sh data-airflow-dags/octupus-merge.sh
    cd data-airflow-dags
    chmod +x octupus-merge.sh
    ./octupus-merge.sh
    cd ..
}

# Clean up
clean_up(){
    #echo "Cleaning /tmp/$TMPWORKDIR"    
    #cd /tmp
    #rm -rf $TMPWORKDIR
    echo "Cleaning....."
    unset TMPWORKDIR
    unset ADD_SECRET
    unset GIT_CLONE
    unset GIT_CHECKOUT_MERGE_SCRIPT
}

#Removing rubbish upon exit
trap clean_up EXIT

#make_temp_folder
setup_git
pull_octupus
pull_repo

#mv scripts/octupus-merge.sh $AIRFLOW__CORE__DAGS_FOLDER/octupus-merge.sh
#chmod +x $AIRFLOW__CORE__DAGS_FOLDER/octupus-merge.sh
#cd $AIRFLOW__CORE__DAGS_FOLDER
#ssh-agent sh -c "$ADD_SECRET; ./octupus-merge.sh"
exit 0