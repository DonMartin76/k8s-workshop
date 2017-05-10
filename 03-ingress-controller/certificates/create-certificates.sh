#!/bin/bash

mkdir -p certificates

openssl req -x509 -newkey rsa:2048 -keyout certificates/portal-key.pem -out certificates/portal-cert.pem -nodes -subj "/CN=${PORTAL_NETWORK_PORTALHOST}" -days 365
openssl req -x509 -newkey rsa:2048 -keyout certificates/api-key.pem -out certificates/api-cert.pem -nodes -subj "/CN=${PORTAL_NETWORK_APIHOST}" -days 365
openssl req -x509 -newkey rsa:2048 -keyout certificates/notes-key.pem -out certificates/notes-cert.pem -nodes -subj "/CN=${APP_HOST}" -days 365

