#!/bin/bash
set -e

function ensure_pip_requirements {
    pip install -r ./requirements.txt
}

function ensure_directory {
    if [ ! -d $1 ]; then
        mkdir $1
    fi
}

function helm_fetch_package {
    helm init --client-only
    if [ ! -d $1/$2 ]; then
        helm fetch stable/$2 --untar --untardir $1
    fi
}

function ensure_installed {
    source ./dependencies/install_$1.sh
}
