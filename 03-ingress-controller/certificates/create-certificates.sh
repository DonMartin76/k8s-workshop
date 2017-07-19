#!/bin/bash

if [ ! -f "env.sh" ]; then
    echo "ERROR: File env.sh not found."
    exit 1
fi

source ./env.sh

mkdir -p certificates
$(uname -o)
# Check to see if the operating system is Windows and use Windows escaping

for d in portal api notes; do
  echo $d
  openssl genrsa -out $d-key.pem 2048
  commonName=${APP_HOST}
  if [[ $d == portal ]]; then commonName="${PORTAL_NETWORK_PORTALHOST}"; fi
  if [[ $d == gateway ]]; then commonName="${PORTAL_NETWORK_APIHOST}"; fi
  openssl req -new -sha256 -key $d-key.pem -out $d.csr -subj "/C=DE/ST=Baden-Wuerttemberg/L=Freiburg/CN=${commonName}"
  openssl req -x509 -sha256 -days 730 -key $d-key.pem -in $d.csr -out $d-cert.pem
  openssl req -in $d.csr -text -noout | grep -i "Signature.*SHA256" && echo "All is well" || echo "This certificate will stop working in 2017! You must update OpenSSL to generate a widely-compatible certificate"
done


# if [ "$(uname -o)" = "Msys" ]; then
#     openssl req -x509 -newkey rsa:2048 -keyout certificates/portal-key.pem -out certificates/portal-cert.pem -nodes -subj "//CN=${PORTAL_NETWORK_PORTALHOST},//subjectAltName=${PORTAL_NETWORK_PORTALHOST}" -days 365
#     openssl req -x509 -newkey rsa:2048 -keyout certificates/api-key.pem -out certificates/api-cert.pem -nodes -subj "//CN=${PORTAL_NETWORK_APIHOST},//subjectAltName=${PORTAL_NETWORK_APIHOST}" -days 365
#     openssl req -x509 -newkey rsa:2048 -keyout certificates/notes-key.pem -out certificates/notes-cert.pem -nodes -subj "//CN=${APP_HOST},//subjectAltName=${APP_HOST}" -days 365
# else
#     openssl req -x509 -newkey rsa:2048 -keyout certificates/portal-key.pem -out certificates/portal-cert.pem -nodes -subj "/CN=${PORTAL_NETWORK_PORTALHOST},/subjectAltName=${PORTAL_NETWORK_PORTALHOST}" -days 365
#     openssl req -x509 -newkey rsa:2048 -keyout certificates/api-key.pem -out certificates/api-cert.pem -nodes -subj "/CN=${PORTAL_NETWORK_APIHOST},/subjectAltName=${PORTAL_NETWORK_APIHOST}" -days 365
#     openssl req -x509 -newkey rsa:2048 -keyout certificates/notes-key.pem -out certificates/notes-cert.pem -nodes -subj "/CN=${APP_HOST},/subjectAltName=${APP_HOST}" -days 365
# fi
