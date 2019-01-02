#!/bin/bash
set -e
if [ ! -e "$(which helm)" ];
then
    echo "Installing helm"
    apt-get install -y curl
    curl https://storage.googleapis.com/kubernetes-helm/helm-v2.12.1-linux-amd64.tar.gz > helm-v2.12.1-linux-amd64.tar.gz
    tar -xzvf helm-v2.12.1-linux-amd64.tar.gz
    sudo mv linux-amd64/helm /usr/local/bin/helm
    if [ -e "$(which kubectl)" ];
    then
        echo "helm $(helm version -c) installed"
    else
        echo "Something went wrong and helm was not able to get installed"
    fi
else
    echo "helm $(helm version -c) already installed"
fi
