#!/bin/bash
set -e
if [ ! -e "$(which python)" ];
then
    echo "Installing python"
    if [[ "Ubuntu" =~ .*(Debian.*|.*Ubuntu).* ]]; 
    then
        sudo apt-get update && sudo apt-get install -y python
    else
        yum install -y python
    fi
    if [ -e "$(which python)" ];
    then
        echo "python $(python --version 2>&1) installed"
    else
        echo "Something went wrong and python was not able to get installed"
    fi
else
    echo "python $(python --version 2>&1) already installed"
fi
