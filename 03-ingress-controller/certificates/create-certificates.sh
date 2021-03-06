#!/bin/bash

if [ ! -f "env.sh" ]; then
    echo "ERROR: File env.sh not found."
    exit 1
fi

source ./env.sh

mkdir -p certificates
uname -o
# Check to see if the operating system is Windows and use Windows escaping

for d in portal api notes; do
  echo $d
  openssl genrsa -out certificates/$d-key.pem 2048
  commonName=${APP_HOST}
  if [[ $d == portal ]]; then commonName="${PORTAL_NETWORK_PORTALHOST}"; fi
  if [[ $d == api ]]; then commonName="${PORTAL_NETWORK_APIHOST}"; fi
  if [[ $(uname -o) == Msys ]]; then
    # This is a mindblowingly stupid syntax, see
    # https://stackoverflow.com/questions/31506158/running-openssl-from-a-bash-script-on-windows-subject-does-not-start-with
    openssl req -new -sha256 -key certificates/$d-key.pem -out certificates/$d.csr -subj "//C=DE\ST=Baden-Wuerttemberg\L=Freiburg\CN=${commonName}"
  else
    openssl req -new -sha256 -key certificates/$d-key.pem -out certificates/$d.csr -subj "/C=DE/ST=Baden-Wuerttemberg/L=Freiburg/CN=${commonName}"
  fi
  openssl req -x509 -sha256 -days 730 -key certificates/$d-key.pem -in certificates/$d.csr -out certificates/$d-cert.pem
  openssl req -in certificates/$d.csr -text -noout | grep -i "Signature.*SHA256" && echo "All is well" || echo "This certificate will stop working in 2017! You must update OpenSSL to generate a widely-compatible certificate"
done
