# Configuring an Ingress Controller

The Ingress Controller in a Kubernetes Cluster does just what the name says: It controls the ingress, the path in, of the cluster. There is no single ingress controller implementation of Kubernetes; Kubernetes just defines an interface _how an ingress controller should behave_, the rest is an implementation detail.

Any ingress controller will open up the cluster at a single place, usually on one or two ports on all nodes, which are in turn load balanced using the cloud provider's native means; on Azure this means the Azure Load Balancer, and ACS is of course automatically configured in a way that services with the type `LoadBalancer` automatically provisions an Azure Load Balancer.

So let's do this. We will now deploy an `nginx` derived Ingress Controller, which is one of the most usual ingress controllers used in the Kubernetes Community. Others are implemented on top of HAproxy, or traefic.

## Deploying a default backend

Every ingress controller usually needs a default backend, which typically just serves a `404 Not Found` for anything which cannot be mapped to something specific. For this example, we use a lightweight container from Google:

```
~/Projects/k8s-workshop$ kubectl apply -f 03-ingress-controller/ingress-controller/default-backend.yml 
service "nginx-default-backend" created
deployment "nginx-default-backend" created
```

## Deploying the Ingress Controller

After that, we deploy the actual Ingress Controller and its service definition:

```
~/Projects/k8s-workshop$ kubectl apply -f 03-ingress-controller/ingress-controller/ingress-controller.yml 
configmap "ingress-nginx-conf" created
service "ingress-nginx" created
deployment "ingress-nginx" created
```

You see here that a couple of different things is deployed to the cluster. The most important things here are the deployment `ingress-nginx` and the service `ingress-nginx`; the service is defined as type `LoadBalancer`, and now Azure will provision a load balancer automatically for the cluster.

This will take a while, and we can check the status of the provisioning by issuing the following command:

```
~/Projects/k8s-workshop$ kubectl get service ingress-nginx
NAME            CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx   10.0.142.120   <pending>     80:30080/TCP,443:30443/TCP   1m
```

After a while (typically 2-3 minutes), the public IP of the load balancer surfaces:

```
~/Projects/k8s-workshop$ kubectl get service ingress-nginx
NAME            CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
ingress-nginx   10.0.142.120   13.74.33.9    80:30080/TCP,443:30443/TCP   4m
```

## Creating certificates

In preparation for the next steps, let's create some self signed certificates we will use for SSL termination of the end points we need for our application. These are needed to be able to define which certificate will be used by which end point when wiring the VHOSTs to the ingress controller.

First, create self signed certificates using the following script

```
~/Projects/k8s-workshop$ ./03-ingress-controller/certificates/create-certificates.sh
...
```

Then add them as "Secrets" to the Kubernetes cluster, so that we can refer to them later on:

```
~/Projects/k8s-workshop$ ./03-ingress-controller/certificates/add-certificates.sh 
secret "portal-tls" created
secret "api-tls" created
secret "notes-tls" created
```

## Set up DNS entries for the VHOSTs

We will now create real DNS entries for the end points we want our cluster to serve on:

* `notes.<your name>.k8s.donmartin76.com`: The actual application we want to serve
* `api.<your name>.k8s.donmartin76.com`: The API Gateway's end point
* `portal.<your name>.k8s.donmartin.com`: The API Portal of wicked.haufe.io

This can be done using the `az network dns` command suite, and is wrapped up in the following shell script. Copy the IP address and enter it as a parameter to the `create-dns-entries.sh` script:

```
~/Projects/k8s-workshop$ $ ./03-ingress-controller/dns/create-dns-entries.sh <load balancer ip>
INFO: Setting up A records to point to 13.74.33.9
...
```

These will be used as VHOST definitions in the ingress resources for the different services. Verify that one of the DNS entries works, by issuing a ping to it:

```
~/Projects/k8s-workshop$ echo $PORTAL_NETWORK_APIHOST
api.martin.k8s.donmartin76.com
~/Projects/k8s-workshop$ ping $PORTAL_NETWORK_APIHOST
PING api.martin.k8s.donmartin76.com (13.74.33.9): 56 data bytes
Request timeout for icmp_seq 0
Request timeout for icmp_seq 1
^C
```

Please note that it's perfectly normal that the ping is not responded; the Azure Load Balancer doesn't do that.

## Create a service and an ingress resource for the "notes" app

We can now wire our first container to a VHOST, using an ingress resource. But first we must create a service which selects the container we created for the notes app; this in turn can be used to wire a VHOST via an ingresss resource to the service. First, let's create the service:

```
~/Projects/k8s-workshop$ kubectl apply -f 03-ingress-controller/service/notes-service.yml
service "notes-app" created
```

This effectively creates an internal name and IP address inside the cluster, which can be used to access the containers carrying the correct service labels via a service IP, in a load balanced way. Kubernetes handles the load balancing internally, completely automatic. The only thing we need to do now is to point the ingress controller to this service IP, and that's where the Ingress resource comes in - it defines which VHOST (and TLS certificate) goes to which service.

## Configuring the ingress

Above, you defined special DNS entries for **your** cluster, and thus we need to take in exactly those DNS names into the ingress definition, so that we have the exact right Host definitions in them. In order to achieve that, we must use some templating mechanism to get the values into the ingress definition. This is one of the few places where configmaps will not work in Kubernetes, so we have to do it with our own templating:

```
~/Projects/k8s-workshop$ ./template.sh 03-ingress-controller/ingress/notes-ingress.yml.template
Templating 03-ingress-controller/ingress/notes-ingress.yml.template to 03-ingress-controller/ingress/notes-ingress.yml...
```

Check out what the templating mechanism created, verify that the `hosts` entry is set correctly:

```
~/Projects/k8s-workshop$ cat 03-ingress-controller/ingress/notes-ingress.yml
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: notes
spec:
  tls:
  - hosts:
    - notes.martin.k8s.donmartin76.com
    secretName: notes-tls

  rules:
  - host: notes.martin.k8s.donmartin76.com
    http:
      paths:
      - path:
        backend:
          serviceName: notes-app
          servicePort: 80
```

Now apply the ingress resource, so that the ingress controller can create the route:

```
~/Projects/k8s-workshop$ kubectl apply -f 03-ingress-controller/ingress/notes-ingress.yml
```

That's it for now. You can now use your own DNS entry to view the notes app being served from the cluster, via the ingress controller, from the correct DNS entry:

```
~/Projects/k8s-workshop$ open https://$APP_HOST
```

**Note**: You will have to accept the self-signed certificate to make this work.

# Addendum

### How to script retrieving the IP of the load balancer

When scripting completely, the following command can help retrieving the IP address of the ingress load balancer:

```
~/Projects/k8s-workshop$ kubectl get service ingress-nginx -ojsonpath="{.status.loadBalancer.ingress[0].ip}"
13.74.33.9
```

This can be used in bash scripts like this:

```
loadbalancerIP=$(kubectl get service ingress-nginx -ojsonpath="{.status.loadBalancer.ingress[0].ip}")
```
