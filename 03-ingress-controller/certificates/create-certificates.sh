#!/bin/bash

if [ ! -f "env.sh" ]; then
    echo "ERROR: File env.sh not found."
    exit 1
fi

source ./env.sh

mkdir -p certificates
$(uname -o)
# Check to see if the operating system is Windows and use Windows escaping
if [ "$(uname -o)" = "Msys" ]; then
    openssl req -x509 -newkey rsa:2048 -keyout certificates/portal-key.pem -out certificates/portal-cert.pem -nodes -subj "//CN=${PORTAL_NETWORK_PORTALHOST}" -days 365
    openssl req -x509 -newkey rsa:2048 -keyout certificates/api-key.pem -out certificates/api-cert.pem -nodes -subj "//CN=${PORTAL_NETWORK_APIHOST}" -days 365
    openssl req -x509 -newkey rsa:2048 -keyout certificates/notes-key.pem -out certificates/notes-cert.pem -nodes -subj "//CN=${APP_HOST}" -days 365
else
    openssl req -x509 -newkey rsa:2048 -keyout certificates/portal-key.pem -out certificates/portal-cert.pem -nodes -subj "/CN=${PORTAL_NETWORK_PORTALHOST}" -days 365
    openssl req -x509 -newkey rsa:2048 -keyout certificates/api-key.pem -out certificates/api-cert.pem -nodes -subj "/CN=${PORTAL_NETWORK_APIHOST}" -days 365
    openssl req -x509 -newkey rsa:2048 -keyout certificates/notes-key.pem -out certificates/notes-cert.pem -nodes -subj "/CN=${APP_HOST}" -days 365
fi
