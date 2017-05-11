#!/bin/bash

pushd $(dirname $0)

kubectl apply -f backend/backend.yml
kubectl apply -f apim/kong.yml
kubectl apply -f apim/wicked-services.yml
kubectl apply -f apim/wicked-deployments.yml

../template.sh notes/notes-deployment.yml.template
../template.sh ingress/apim-ingress.yml.template

kubectl apply -f notes/notes-deployment.yml
kubectl apply -f ingress/apim-ingress.yml

popd
