#!/bin/bash
DOCTL_VER=1.12.2
if [ ! -e "$(which doctl)" ];
then
    echo "Installing doctl"
    apt-get install -y curl
    curl -OL https://github.com/digitalocean/doctl/releases/download/v$DOCTL_VER/doctl-$DOCTL_VER-linux-amd64.tar.gz
    tar -xzvf doctl-$DOCTL_VER-linux-amd64.tar.gz
    sudo mv doctl /usr/local/bin/doctl
    if [ -e "$(which doctl)" ];
    then
        echo "doctl already installed"
    else
        echo "Something went wrong and doctl was not able to get installed"
    fi
else
    echo "doctl already installed"
fi
