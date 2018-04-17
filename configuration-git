#### Step 1: Installing Git

We can install Git without having to add any repositories.

apt-get install git

#### Step 2: Configuring Git
git config --global user.name "John Appleseed"
git config --global user.email "email@example.com"

#### Step 3: SSH and Git

* Check if any SSH key exists

ls -al ~/.ssh

* Generate SSH key in your .ssh directory

- ssh-keygen -t rsa -b 4096 -C "email@example.com"

* Enable SSH-agen

eval "$(ssh-agent -s)"

* Add your SSH key to the SSH agent

ssh-add ~/.ssh/id_rsa

* Add your public key to your GitHub account

 ~/.ssh/id_rsa.pub

*Testing your connection 

ssh -vT git@github.com

