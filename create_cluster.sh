#!/bin/bash
set -exE
DOCTL_VER=1.12.2
DIGITALOCEAN_ENABLE_BETA=1

function download_doctl {
    # If not already downloaded, dowload and untar
    if [ ! -f doctl-$1-linux-amd64.tar.gz ]; then
        curl -OL https://github.com/digitalocean/doctl/releases/download/v$1/doctl-$1-linux-amd64.tar.gz
    fi
}

function unpack_doctl {
    # If not already unpacked, unpack
    if [ ! -f doctl ]; then
        tar -xzvf doctl-$1-linux-amd64.tar.gz
    fi
}

function initialize_doctl {
    # Initialize doctl if not already initialized
    if [ ! ~/.config/doctl/config.yaml ]; then
        ./doctl auth init
    fi
}

function decide {
    MESSAGE=$1
    OUTPUT=$2
    OLD_IFS=$IFS
    IFS=$'\n'
    OUTPUT_ARR=($(echo "$OUTPUT" | awk 'NR >=2 {print $0}'))
    choose $MESSAGE OUTPUT_ARR
    CHOICE=$(echo "$OUTPUT" | awk 'NR == '$REPLY+1' {print $1}')
    IFS=$OLD_IFS
    echo $CHOICE
}


function choose {
	PROMPT=$1
    local -n OPTIONS=$2

	PS3="$PROMPT "
	select choice in "${OPTIONS[@]}" "Cancel"; do 

		case "$REPLY" in

		$(( ${#OPTIONS[@]}+1 )) ) exit 1; break;;
		*) if [ $REPLY -gt ${#OPTIONS[@]} ]; then echo "Invalid option. Try another one." && continue; else break; fi;;

		esac

	done 
}

function main {
    download_doctl $1
    unpack_doctl $1
    initialize_doctl
    REGIONS=$(./doctl kubernetes options regions)
    VERSIONS=$(./doctl kubernetes options versions)
    SIZES=$(./doctl kubernetes options sizes)

    REGION=$(decide "Choose a region " "$REGIONS")
    VERSION=$(decide "Choose a version " "$VERSIONS")
    SIZE=$(decide "Choose a size " "$SIZES")

    DEFAULT_COUNT=3

    TAGS=""
    DEFAULT_NAME="Infra-K8s"

    echo "Give it a name ($DEFAULT_NAME) "
    read NAME
    if [ -z $NAME ]; then
        NAME=$DEFAULT_NAME
    fi

    while :
    do
        echo "How many workers do you wish to deploy? ($DEFAULT_COUNT) "
        read COUNT
        if [[ -n ${COUNT//[1-9]/} ]]; then
            echo "Invalid amount try again"
            continue;
        fi
        break;
    done
    if [ -z $COUNT ]; then
        COUNT=$DEFAULT_COUNT
    fi

    echo "Input any comma delimited tags you wish to apply "
    echo "*Warning Tagging is currently broken or their side, feel free to skip this step"
    read TAGS

    ARGS_ARR=( \
        "--region $REGION" \
        "--size $SIZE" \
        "--version $VERSION" \
        "--count $COUNT" \
    )
    
    for TAG in $(echo "$TAGS" | cut -d "," -f 1- --output-delimiter ' ');
    do
        echo $TAG
        ARGS_ARR+=("--tag $TAG")
    done;

    
    ./doctl kubernetes cluster create $NAME --wait ${ARGS_ARR[*]}
    ./doctl kubernetes cluster kubeconfig show $NAME > $NAME-kubeconfig.yaml

    while :
    do
        echo "Do you want to install the config file? (y/n)"
        read ANSWER
        if [[ -z ${ANSWER//[y]/} ]]; then
            cp -f ./$NAME-kubeconfig.yaml ~/.kube/config
            break;
        fi
        if [[ -z ${ANSWER//[n]/} ]]; then
            break;
        fi
        echo "Invalid option use 'y' or 'n'"
    done
}

main $DOCTL_VER
