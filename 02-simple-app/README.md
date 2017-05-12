# Deploying a first container and using the dashboard

Now we will deploy a first container to our cluster, just to get a hang of how it works. From the repository root, use the following command:

```
~/Projects/k8s-workshop$ kubectl apply -f 02-simple-app/deployment/notes-deployment.yml
deployment "notes-app" created
```

Inspect what's running on the cluster by issuing the following command:

```
~/Projects/k8s-workshop$ kubectl get pods
NAME                         READY     STATUS              RESTARTS   AGE
notes-app-3457614599-0f2hh   0/1       ContainerCreating   0          6s
notes-app-3457614599-wml41   0/1       ContainerCreating   0          6s
```

You can see that Kubernetes has started creating the containers; it will automatically pull the images from Docker Hub. After a minute or so, you should have two instances of the marvellous "Markdown Notes" application up and running on your cluster:

```
~/Projects/k8s-workshop$ $ kubectl get pods -owide
NAME                         READY     STATUS    RESTARTS   AGE       IP           NODE
notes-app-3457614599-0f2hh   1/1       Running   0          39s       10.244.1.5   k8s-agent-54c9989d-0
notes-app-3457614599-wml41   1/1       Running   0          39s       10.244.2.3   k8s-agent-54c9989d-1
```

Note the usage of the additional parameter `-owide`; it adds some more information to the output ("wide" output), like the internal IP address of the pod, and on which agent the container runs.

## Accessing the pods

Note that we cannot access the container/pod just yet, as we haven't let created any services or ingresses yet. We'll come to that in a minute, but we can still port forward us into a specific container with the following command. Copy one of the pod names from above, e.g. `notes-app-2134041113-h828f` (this name will be different on your cluster):

```
~/Projects/k8s-workshop$ kubectl port-forward notes-app-2134041113-h828f 8080:80
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

Browse to [localhost:8080](http://localhost:8080), and you will see the start page of the Markdown Notes app. It will not work yet, as the underlying API is missing, but you can still see that the container is indeed running and serving the content inside the cluster from port 80.

Now press Ctrl-C to stop the port forwarding, and issue the following command:

```
~/Projects/k8s-workshop$ kubectl logs notes-app-2134041113-h828f
{
  "authServers": [{
      "name": "GitHub",
      "url": "https://dummy.org/auth-passport/github/api/markdown-notes?client_id=this-is-something-invalid&response_type=token",
      "profileUrl": "https://dummy.org/auth-passport/github/profile",
      "bsStyle": "default"
    }]
}127.0.0.1 - - [10/May/2017:11:05:29 +0000] "GET /static/js/main.ddcb0bdd.js HTTP/1.1" 200 138138 "http://localhost:8080/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/603.1.30 (KHTML, like Gecko) Version/10.1 Safari/603.1.30"
```

This is the log to `stdout` of the container; you will see the access you did, plus some configuration of the container. That configuration is obviously bogus for now, but it's fine, we'll deal with this a little later.

If you don't get any logs from the container, pick the other one. It's internally load balanced, so you can't be sure where the traffic actually goes.

## Playing whack-a-pod

To see what a deployment (and its underlying replica set) does, it's interesting to delete a pod from the running cluster. Run a `kubectl get pods` and copy one of the pod IDs to the clipboard, then do the following:

```
~/Projects/k8s-workshop$ kubectl delete pod notes-app-3457614599-0f2hh
pod "notes-app-3457614599-0f2hh" deleted
```

Now check on the pods (`kubectl get pods`), and you'll see something like this:

```
~/Projects/k8s-workshop$ kubectl get pods
NAME                                     READY     STATUS        RESTARTS   AGE
notes-app-3457614599-0f2hh               1/1       Terminating   0          11m
notes-app-3457614599-k0v46               1/1       Running       0          11m
notes-app-3457614599-lffr6               1/1       Running       0          9s
```

The pod with the ID `notes-app-3457614599-0f2hh` is not running anymore (`Terminated`), but instead a new container `notes-app-3457614599-lffr6` was created automatically to meet the specification we gave Kubernetes: "Please run two instances of the following container".

This is also what happens if e.g. a node goes down and all pods inside it cannot respond anymore.

## Using the Kubernetes Dashboard

Another useful command is `kubectl proxy`, which lets you view the so called "Kubernetes Dashboard" (and, for other use cases, proxy the Kubernetes API to your localhost):

```
~/Projects/k8s-workshop$ kubectl proxy
Starting to serve on 127.0.0.1:8001
```

While you have not yet pressed Ctrl-C, you will now be able to browse the Kubernetes Dashboard at [localhost:8001/ui](http://localhost:8001/ui).

The Dashboard exposes most everything from the cluster, like Deployments, Services, ConfigMaps, Node status, ReplicaSets, Volume Configurations and more. This is a valuable tool, but over time you tend to either use other Dashboarding tools, or to just use `kubectl` from the command line.
