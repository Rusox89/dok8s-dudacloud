#!/bin/bash
set -e
source utils/functions.sh

PACKAGE=traefik
RELEASE_NAME=traefik
NAMESPACE=traefik
DEF_DIR=definitions
CHART_DIR=charts

ensure_installed helm
ensure_installed kubectl 
ensure_installed python
ensure_installed pip

python -m pip install -r ./requirements.txt

ensure_directory $CHART_DIR
ensure_directory $DEF_DIR
helm_fetch_package $CHART_DIR $PACKAGE

helm template $CHART_DIR/$PACKAGE $PACKAGE \
    --name $RELEASE_NAME \
    --namespace $NAMESPACE \
    --set dashboard.enabled=true \
    --set rbac.enable=true \
    --set dashboard.domain=traefik.yourdomain.com \
    --set ssl.enabled=true \
    --set accessLogs.enabled=true \
    --set metrics.prometheus.enabled=true \
    | tee $DEF_DIR/$PACKAGE.yaml

./utils/add_namespace.py -i $DEF_DIR/$PACKAGE.yaml -o $DEF_DIR/$PACKAGE.yaml -n $NAMESPACE
./utils/add_namespace.py -i statics/traefik-ingress-controller-service-account.yaml -o $DEF_DIR/$PACKAGE-ingress-controller-service-account.yaml -n $NAMESPACE
./utils/add_service_account.py -i $DEF_DIR/$PACKAGE.yaml -o $DEF_DIR/$PACKAGE.yaml -s traefik-ingress-controller
sed -i "s/namespace: kube-system/namespace: $NAMESPACE/" $DEF_DIR/$PACKAGE-ingress-controller-service-account.yaml
set +e
kubectl create ns $PACKAGE  # May already exists so we allow it to fail
set -e
kubectl apply -f $DEF_DIR/$PACKAGE.yaml
kubectl apply -f $DEF_DIR/$PACKAGE-ingress-controller-service-account.yaml
