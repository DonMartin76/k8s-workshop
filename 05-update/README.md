# Scaling and updating deployments

One of the most useful features of Kubernetes is the possibility to easily scale and perform rolling updates on deployments, and this is what we'll try out now.

To better see the effects of a rolling update, we'll first scale up the `notes-app` to 10 instanes (not that that actually makes sense, but it's fun).

## Scaling the `notes-app` deployment

Run the following command from the command line:

```
~/Projects/k8s-workshop$ kubectl scale deployment notes-app --replicas=10
deployment "notes-app" scaled
```

Now watch Kubernetes spin up another eight instances on the two machines (it takes around a minute):

```
~/Projects/k8s-workshop$ kubectl get pods -owide
NAME                                     READY     STATUS    RESTARTS   AGE       IP            NODE
auth-passport-2096957781-m05r6           1/1       Running   0          20m       10.244.1.7    k8s-agent-54c9989d-0
ingress-nginx-3622083380-1z58q           1/1       Running   0          55m       10.244.2.5    k8s-agent-54c9989d-1
ingress-nginx-3622083380-3l6q3           1/1       Running   0          55m       10.244.1.6    k8s-agent-54c9989d-0
kong-3704330971-1w2vv                    1/1       Running   0          20m       10.244.2.7    k8s-agent-54c9989d-1
kong-database-3512580923-49sxf           1/1       Running   0          20m       10.244.2.8    k8s-agent-54c9989d-1
nginx-default-backend-4271921850-vk120   1/1       Running   0          56m       10.244.2.4    k8s-agent-54c9989d-1
notes-api-765315739-9jq49                1/1       Running   0          20m       10.244.2.6    k8s-agent-54c9989d-1
notes-app-2395344533-2551r               1/1       Running   0          1m        10.244.1.13   k8s-agent-54c9989d-0
notes-app-2395344533-3z4m5               1/1       Running   0          48s       10.244.1.16   k8s-agent-54c9989d-0
notes-app-2395344533-49qft               1/1       Running   0          1m        10.244.1.14   k8s-agent-54c9989d-0
notes-app-2395344533-6kj3d               1/1       Running   0          39s       10.244.2.21   k8s-agent-54c9989d-1
notes-app-2395344533-dldnz               1/1       Running   0          43s       10.244.2.20   k8s-agent-54c9989d-1
notes-app-2395344533-dx1q4               1/1       Running   0          49s       10.244.2.18   k8s-agent-54c9989d-1
notes-app-2395344533-k9pgs               1/1       Running   0          45s       10.244.2.19   k8s-agent-54c9989d-1
notes-app-2395344533-n621z               1/1       Running   0          38s       10.244.1.17   k8s-agent-54c9989d-0
notes-app-2395344533-w543d               1/1       Running   0          54s       10.244.2.17   k8s-agent-54c9989d-1
notes-app-2395344533-x8k37               1/1       Running   0          53s       10.244.1.15   k8s-agent-54c9989d-0
portal-1113589741-1910n                  1/1       Running   0          20m       10.244.2.10   k8s-agent-54c9989d-1
portal-api-3638759311-3z1cg              1/1       Running   0          20m       10.244.2.9    k8s-agent-54c9989d-1
portal-kong-adapter-95295708-c8cdq       1/1       Running   0          20m       10.244.2.11   k8s-agent-54c9989d-1
```

## Updating the `notes-app` container image

Now we have something to work with. We will now switch out the image that the `notes-app` deployment is using (`donmartin76/markdown-notes-app:v1`) against a new and even more awesome version, `donmartin76/markdown-notes-app:v2` (_Side note_: The only difference is that, on the login page, the title is "Markdown Notes" in `v1`, and "MARKDOWN NOTES" in `v2`).

There are many ways of accomplishing this, and in most cases you would edit/re-template the [deployment yaml file](../04-full-app/notes/notes-deployment.yml.template) and issue a `kubectl apply -f`, but for the sake of this demo, the following command does the same, but from the command line:

```
~/Projects/k8s-workshop$ kubectl set image deployment notes-app notes-app=donmartin76/markdown-notes-app:v2
deployment "notes-app" image updated
```

Now watch Kubernetes do the rolling update of the images by issuing the `kubectl get pods` command to display the pods:

```
~/Projects/k8s-workshop$ kubectl get pods
NAME                                     READY     STATUS        RESTARTS   AGE
auth-passport-2096957781-m05r6           1/1       Running       0          35m
ingress-nginx-3622083380-1z58q           1/1       Running       0          1h
ingress-nginx-3622083380-3l6q3           1/1       Running       0          1h
kong-3704330971-1w2vv                    1/1       Running       0          35m
kong-database-3512580923-49sxf           1/1       Running       0          35m
nginx-default-backend-4271921850-vk120   1/1       Running       0          1h
notes-api-765315739-9jq49                1/1       Running       0          35m
notes-app-2395344533-1jlq9               1/1       Running       0          5m
notes-app-2395344533-42f0j               1/1       Running       0          5m
notes-app-2395344533-bvbj7               1/1       Running       0          5m
notes-app-2395344533-cttcn               1/1       Running       0          5m
notes-app-2395344533-g63hq               1/1       Running       0          5m
notes-app-2395344533-gdsvw               1/1       Terminating   0          4m
notes-app-2395344533-q1fpc               1/1       Running       0          5m
notes-app-2395344533-s00l8               1/1       Running       0          5m
notes-app-2395344533-s5tmc               1/1       Running       0          4m
notes-app-2395344533-v2c4g               1/1       Running       0          5m
notes-app-2553351830-c82kp               0/1       Init:0/1      0          3s
notes-app-2553351830-qkc37               0/1       Init:0/1      0          3s
portal-1113589741-1910n                  1/1       Running       0          35m
portal-api-3638759311-3z1cg              1/1       Running       0          35m
portal-kong-adapter-95295708-c8cdq       1/1       Running       0          35m
```

Kubernetes is terminating the pods one by one, and creates new ones at the same time. Depending on the deployment parameters (in the abovementioned deployment description, look for `maxSurge` and `maxUnavailale`), this is done with just one container at the time, or with multiple ones.

In this case, both `maxUnavailable` and `maxSurge` are set to `1`, which means Kubernetes replaces as fast as it can, while keeping the minimum number of available pods at 9 (10 - `maxUnavailable`), and the count of pods in total under or at 11 (10 + `maxSurge`), which is why in the above example you can see one pod in state `Terminating` and two pods in state `Init:0/1` (10 - 1 + 2 = 11).

After one to two minutes, the entire replacement process should have finished, and the new version of the application should be online (you may need to refresh the browser, it's static files served for the SPA after all, the browser caches most things, so an explicit reload may be needed).

You can also try issuing the following command to see in real time what Kubernetes does in terms of terminating and recreating containers:

```
~/Projects/k8s-workshop$ kubect get pods --watch
```
