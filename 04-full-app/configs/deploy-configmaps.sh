#!/bin/bash

if [ ! -f "env.sh" ]; then
    echo "ERROR: File env.sh not found."
    exit 1
fi

source ./env.sh

if kubectl get configmap apim-config &> /dev/null; then
    kubectl delete configmap apim-config
fi

kubectl create configmap apim-config \
    --from-literal=PORTAL_NETWORK_APIHOST=${PORTAL_NETWORK_APIHOST} \
    --from-literal=PORTAL_NETWORK_PORTALHOST=${PORTAL_NETWORK_PORTALHOST} \
    --from-literal=APP_HOST=${APP_HOST} \
    --from-literal=GIT_REPO="github.com/DonMartin76/k8s-workshop-apim-config"
