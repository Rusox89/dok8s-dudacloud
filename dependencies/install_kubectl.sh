#!/bin/bash
# Kubernetes instructions on how to install kubecl https://kubernetes.io/docs/tasks/tools/install-kubectl/
if [ ! -e "$(which kubectl)" ];
then
    echo "Installing kubectl"
    if [[ "Ubuntu" =~ .*(Debian.*|.*Ubuntu).* ]]; 
    then
        sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg curl
        curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
        sudo apt-get update
        sudo apt-get install -y kubectl
    else
        cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
        yum install -y kubectl
    fi
    if [ -e "$(which kubectl)" ];
    then
        echo "kubectl $(kubectl version --client=true) already installed"
    else
        echo "Something went wrong and kubectl was not able to get installed"
    fi
else
    echo "kubectl $(kubectl version --client=true) already installed"
fi
