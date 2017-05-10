#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <ip of load balancer>"
    exit 1
fi

echo "INFO: Setting up A records to point to $1"

for endpoint in portal api notes; do
    az network dns record-set a delete \
        --name ${endpoint}.${YOUR_NAME} \
        --resource-group ${DNS_RESOURCE_GROUP} \
        --zone-name ${DNS_ZONE} \
        --yes
    az network dns record-set a add-record \
        --record-set-name ${endpoint}.${YOUR_NAME} \
        --resource-group ${DNS_RESOURCE_GROUP} \
        --zone-name ${DNS_ZONE} \
        --ipv4-address $1
done
