#!/bin/bash
set -e
if [ ! -e "$(which pip)" ];
then
    echo "Installing pip"
    PYTHON_VERSION=$(python --version 2>&1 | cut -d " " -f 2)
    if [[ "Ubuntu" =~ .*(Debian.*|.*Ubuntu).* ]]; 
    then
        if [[ "$PYTHON_VERSION" =~ ^2 ]];
        then
            sudo apt-get install -y python-pip
        else
            sudo apt-get install -y python3-pip
        fi

    else
        sudo yum install -y epel-release
        if [[ "$PYTHON_VERSION" =~ ^2 ]];
        then
            sudo yum install -y python-pip
        else
            sudo apt-get install python34-pip
        fi
    fi
    if [ -e "$(which pip)" ];
    then
        echo "pip $(pip -V) installed"
    else
        echo "Something went wrong and pip was not able to get installed"
    fi
else
    echo "pip $(pip -V) already installed"
fi
