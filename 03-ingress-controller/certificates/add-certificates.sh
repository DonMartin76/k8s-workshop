#!/bin/bash

if [ ! -f "env.sh" ]; then
    echo "ERROR: File env.sh not found."
    exit 1
fi

source ./env.sh

for cert in portal api notes; do
    if kubectl get secret ${cert}-tls &> /dev/null; then
        kubectl delete secret ${cert}-tls
    fi
    kubectl create secret tls ${cert}-tls --cert=certificates/${cert}-cert.pem --key=certificates/${cert}-key.pem
done
