: '
Merge all branches using Octupus merge mode
'
#!/bin/sh

SSH_PRIVATE_KEY=/etc/git-secret/ssh
OCTUPUS_FOLDER=scripts
OCTUPUS_GIT=git@github.com:Thanh-Truong/scripts.git
OCTUPUS_SH=octupus-merge.sh
REPO_FOLDER=octupus-dags
REPO_GIT=git@github.com:TV4/data-airflow-dags.git


make_temp_folder() {
    TMPWORKDIR=$(basename $(mktemp -d -p /tmp))
    cd /tmp/$TMPWORKDIR
    echo "Temp directory:" $TMPWORKDIR
}

setup_git() {
    echo "Setting Git.................."
    eval "$(ssh-agent -s)"
    ssh-add $SSH_PRIVATE_KEY 
}

clone_repo() {
    echo "Cloning repo $1 $2 ..........."
    git clone --branch master $1 $2  
}

pull_octupus() {
    echo "Pulling Octupus ..............."
    rm -rf $OCTUPUS_FOLDER
    clone_repo "$OCTUPUS_GIT" "--no-checkout"
    cd $OCTUPUS_FOLDER
    git fetch && git checkout origin $OCTUPUS_SH
    cd ..
}

pull_repo() {
    echo "Pulling Repo ....................."
    rm -rf $REPO_FOLDER
    clone_repo "$REPO_GIT" "$REPO_FOLDER"    
    mv $OCTUPUS_FOLDER/$OCTUPUS_SH $REPO_FOLDER/$OCTUPUS_SH
}

octupus_merge() {
    cd $REPO_FOLDER
    git config user.email "octupus@bonnierbroadcasting.com"
    git config user.name "Octupus"
    chmod +x $OCTUPUS_SH
    ./$OCTUPUS_SH
    cd ..
}

# Clean up
clean_up(){
    #echo "Cleaning /tmp/$TMPWORKDIR"    
    #cd /tmp
    #rm -rf $TMPWORKDIR
    echo "Cleaning....."
    rm -rf $OCTUPUS_FOLDER
    unset TMPWORKDIR
    unset ADD_SECRET
    unset GIT_CLONE
    unset GIT_CHECKOUT_MERGE_SCRIPT
    unset OCTUPUS_FOLDER
    unset OCTUPUS_GIT
    unset OCTUPUS_SH
    unset REPO_FOLDER
}

#Removing rubbish upon exit
trap clean_up EXIT

#make_temp_folder
rm -rf $OCTUPUS_FOLDER
rm -rf $REPO_FOLDER
setup_git
pull_octupus
pull_repo
octupus_merge
REV_FOLDER=$(find $PWD -type d -iname "rev*" -maxdepth 1) && echo $REV_FOLDER
ln -snf $PWD/$REPO_FOLDER/dev/feature* $REV_FOLDER/dev/
exit 0


#ln -snf /tmp/octupus/data-airflow-dags/dev/* /airflow/dags/data/dev/
#ln -sn /tmp/octupus/data-airflow-dags/dev/* /airflow/dags/rev-1544cf91240a254d7047879972a3cc835f4b207c/dev/
#ln -sn /tmp/octupus/octupus-dags/dev/* /airflow/dags/rev-1544cf91240a254d7047879972a3cc835f4b207c/dev/
#ln -sn /airflow/dags/octupus-dags/dev/* /airflow/dags/rev-1544cf91240a254d7047879972a3cc835f4b207c/dev/