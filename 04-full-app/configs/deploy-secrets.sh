#!/bin/bash

if kubectl get secret apim-secrets &> /dev/null; then
    kubectl delete secret apim-secrets
fi

kubectl create secret generic apim-secrets \
    --from-literal=PORTAL_CONFIG_KEY=2930437a93959ebbb4c92d61dccbc327a20f60a7 \
    --from-literal=GITHUB_CLIENTID=${GITHUB_CLIENTID} \
    --from-literal=GITHUB_CLIENTSECRET=${GITHUB_CLIENTSECRET} \
    --from-literal=PORTAL_AUTH_GITHUB_CLIENTID=${PORTAL_AUTH_GITHUB_CLIENTID} \
    --from-literal=PORTAL_AUTH_GITHUB_CLIENTSECRET=${PORTAL_AUTH_GITHUB_CLIENTSECRET}

