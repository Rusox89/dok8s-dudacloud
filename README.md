# DOK8s infrastructure (WIP)
This project is intended to offer to the reader a ready to work minimal infrastructure to be hosted on Digital Ocean

## Requirements
When executing this script it will download doctl and use it to create a cluster, for this purpose you will need to
log in into your Digital Ocean account and create a write enabled token that you will provide to doctl

## Usage

### Installing all
```
$ ./install.sh
```

### Installing the cluster on Digital Ocean
```
$ ./create_cluster.sh
```

And follow the instructions, at the end you will get a kubectl config file on the same directory as this script

### Installing Traefik

```
$ ./install_traefik.sh
```
