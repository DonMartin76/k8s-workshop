#!/bin/bash

if [ ! -f "env.sh" ]; then
    echo "ERROR: File env.sh not found."
    exit 1
fi

source ./env.sh

echo "Open your Github account settings, and register the following applications."
echo "--> https://github.com/settings/applications/new"
echo ""
echo "API Gateway OAuth2 registration"
echo "==============================="
echo "Application name          : Kubernetes Workshop Authorization Server"
echo "Homepage URL              : https://portal.${YOUR_NAME}.${DNS_ZONE}"
echo "Authorization Callback URL: https://api.${YOUR_NAME}.${DNS_ZONE}/auth-passport/github/callback"
echo ""
echo "Values go into GITHUB_CLIENTID and GITHUB_CLIENTSECRET."
echo ""
echo "API Portal OAuth2 registration"
echo "==============================="
echo "Application name          : Kubernetes Workshop API Portal"
echo "Homepage URL              : https://portal.${YOUR_NAME}.${DNS_ZONE}"
echo "Authorization Callback URL: https://portal.${YOUR_NAME}.${DNS_ZONE}/callback/github"
echo ""
echo "Values go into PORTAL_AUTH_GITHUB_CLIENTID and PORTAL_AUTH_GITHUB_CLIENTSECRET."
echo ""
echo "Then open your env.sh file and add the obtained client ID and secrets."
echo "After that, please once more do a"
echo "  . env.sh"
echo "to update the environment variables."
echo ""
echo ""
echo "The script will open the GitHub app registration page in 10 seconds."
sleep 10
echo "Running open https://github.com/settings/applications/new"
open https://github.com/settings/applications/new
