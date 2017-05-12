# Configuring the rest of the application

## Obtain Github credentials for login

To make the login to the application and the API portal work using GitHub credentials, we need to obtain client credentials for GitHub. To make this a little easier, call the following script which will tell you which applications and callback URLs you need to configure:

```
~/Projects/k8s-workshop$ ./04-full-app/github/get-github-data.sh
Open your Github account settings, and register the following applications.
--> https://github.com/settings/applications/new

API Gateway OAuth2 registration
===============================
Application name          : Kubernetes Workshop Authorization Server
Homepage URL              : https://portal.martin.k8s.donmartin76.com
Authorization Callback URL: https://api.martin.k8s.donmartin76.com/auth-passport/github/callback

Values go into GITHUB_CLIENTID and GITHUB_CLIENTSECRET.

API Portal OAuth2 registration
===============================
Application name          : Kubernetes Workshop API Portal
Homepage URL              : https://portal.martin.k8s.donmartin76.com
Authorization Callback URL: https://portal.martin.k8s.donmartin76.com/callback/github

Values go into PORTAL_AUTH_GITHUB_CLIENTID and PORTAL_AUTH_GITHUB_CLIENTSECRET.

Then open your env.sh file and add the obtained client ID and secrets.
After that, please once more do a
  . env.sh
to update the environment variables.
```

The specific URLs will obviously differ for your specific user.

## Deploying the application configuration

In order to configure the rest of the application, we will deploy a number of `ConfigMap` and `Secret` entities to the cluster. Remember we can use both configmaps and secrets to, e.g., inject parameters as environment variables at startup of containers.

This is done with the following two commands (wrapping `kubectl create configmap` and `kubectl create secret generic` commands):

```
~/Projects/k8s-workshop$ ./04-full-app/configs/deploy-configmaps.sh 
configmap "apim-config" created
~/Projects/k8s-workshop$ ./04-full-app/configs/deploy-secrets.sh 
secret "apim-secrets" created
```

Issue the following command to have a look at the configured configmaps in the cluser:

```
~/Projects/k8s-workshop$ kubectl get configmaps
NAME                 DATA      AGE
apim-config          4         1m
ingress-nginx-conf   1         24m
```

To see the actual content of the configmap, use the following command (to output the configmap as `yaml` code):

```
~/Projects/k8s-workshop$ kubectl get configmap apim-config -oyaml
apiVersion: v1
data:
  APP_HOST: notes.martin.k8s.donmartin76.com
  GIT_REPO: github.com/DonMartin76/k8s-workshop-apim-config
  PORTAL_NETWORK_APIHOST: api.martin.k8s.donmartin76.com
  PORTAL_NETWORK_PORTALHOST: portal.martin.k8s.donmartin76.com
kind: ConfigMap
metadata:
  creationTimestamp: 2017-05-12T09:41:49Z
  name: apim-config
  namespace: default
  resourceVersion: "4137"
  selfLink: /api/v1/namespaces/default/configmaps/apim-config
  uid: 389e6111-36f7-11e7-8524-000d3ab691e3
```

Now we can use these configuration settings as parameters inside pod/container specifications.

We're all set and done, and now we'll deploy the rest of the entire application in one go.

## Deploying the rest of the application

Open up the [`deploy.sh`](04-full-app/deploy.sh) and check out what we'll do now. It's a row of different `kubectl` commands which deploy the following things to the cluster:

* The Markdown Notes API Backend
* API Gateway (Kong)
* API Gateway storage (Postgres)
* API Portal and Kong Adapter (wicked.haufe.io)
* Authorization Server for GitHUb
* Ingress definitions for Portal and API Gateway
* An updated configuration for the Markdown Notes SPA App (the one we deployed before)

```
~/Projects/k8s-workshop$ ./04-full-app/deploy.sh
```

Now we can check the progress of the deployment by repeatedly and impatiently hammering out the following command:

```
~/Projects/k8s-workshop$ kubectl get pods -owide
```

Depending on which containers start first (you never know who gets the pulls first), you may see some intermittent `CrashLoopBackoff` or `Error` statuses, especially if e.g. the `portal-api` container does not come up first (it never does).

Typical situation after a minute:

```
~/Projects/k8s-workshop$ kubectl get pods -owide
NAME                                     READY     STATUS              RESTARTS   AGE       IP           NODE
auth-passport-2096957781-m05r6           1/1       Running             0          1m        10.244.1.7   k8s-agent-54c9989d-0
ingress-nginx-3622083380-1z58q           1/1       Running             0          36m       10.244.2.5   k8s-agent-54c9989d-1
ingress-nginx-3622083380-3l6q3           1/1       Running             0          36m       10.244.1.6   k8s-agent-54c9989d-0
kong-3704330971-1w2vv                    1/1       Running             0          1m        10.244.2.7   k8s-agent-54c9989d-1
kong-database-3512580923-49sxf           1/1       Running             0          1m        10.244.2.8   k8s-agent-54c9989d-1
nginx-default-backend-4271921850-vk120   1/1       Running             0          37m       10.244.2.4   k8s-agent-54c9989d-1
notes-api-765315739-9jq49                1/1       Running             0          1m        10.244.2.6   k8s-agent-54c9989d-1
notes-app-291768031-7qg3l                0/1       Init:0/1            0          1m        <none>       k8s-agent-54c9989d-1
notes-app-291768031-pq4dh                0/1       Init:0/1            0          1m        10.244.1.8   k8s-agent-54c9989d-0
notes-app-3457614599-0f2hh               1/1       Running             0          44m       10.244.1.5   k8s-agent-54c9989d-0
portal-1113589741-1910n                  0/1       ContainerCreating   0          1m        <none>       k8s-agent-54c9989d-1
portal-api-3638759311-3z1cg              0/1       ContainerCreating   0          1m        <none>       k8s-agent-54c9989d-1
portal-kong-adapter-95295708-c8cdq       0/1       ContainerCreating   0          1m        <none>       k8s-agent-54c9989d-1
```

This is how it should look like after 3-5 minutes:

```
~/Projects/k8s-workshop$ kubectl get pods -owide
NAME                                     READY     STATUS    RESTARTS   AGE       IP            NODE
auth-passport-2096957781-m05r6           1/1       Running   0          3m        10.244.1.7    k8s-agent-54c9989d-0
ingress-nginx-3622083380-1z58q           1/1       Running   0          38m       10.244.2.5    k8s-agent-54c9989d-1
ingress-nginx-3622083380-3l6q3           1/1       Running   0          38m       10.244.1.6    k8s-agent-54c9989d-0
kong-3704330971-1w2vv                    1/1       Running   0          3m        10.244.2.7    k8s-agent-54c9989d-1
kong-database-3512580923-49sxf           1/1       Running   0          3m        10.244.2.8    k8s-agent-54c9989d-1
nginx-default-backend-4271921850-vk120   1/1       Running   0          38m       10.244.2.4    k8s-agent-54c9989d-1
notes-api-765315739-9jq49                1/1       Running   0          3m        10.244.2.6    k8s-agent-54c9989d-1
notes-app-291768031-7qg3l                1/1       Running   0          3m        10.244.2.12   k8s-agent-54c9989d-1
notes-app-291768031-pq4dh                1/1       Running   0          3m        10.244.1.8    k8s-agent-54c9989d-0
portal-1113589741-1910n                  1/1       Running   0          3m        10.244.2.10   k8s-agent-54c9989d-1
portal-api-3638759311-3z1cg              1/1       Running   0          3m        10.244.2.9    k8s-agent-54c9989d-1
portal-kong-adapter-95295708-c8cdq       1/1       Running   0          3m        10.244.2.11   k8s-agent-54c9989d-1
```

## Testing the app

You should now be able to open up the "Markdown Notes" application with your browser:

```
~/Projects/k8s-workshop$ open https://notes.${YOUR_NAME}.${DNS_ZONE}
```

The application works best with Chrome, it's not been extensively tested on other browsers (but should also work in Safari and Firefox, Edge/IE has not been tested at all).
