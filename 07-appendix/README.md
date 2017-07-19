# Useful `kubectl` commands

## Checking node status

Basic information on the Kubernetes nodes:

```
kubectl get nodes -owide
```

More information on the nodes:

```
kubectl describe nodes
```

## Checking node load

Check memory and CPU usage on node level:

```
kubectl top nodes
```

Check memory and CPU usage on pod level:

```
kubectl top pods
```

## Getting logs from a pod

```
kubectl logs [--follow] <pod id>
```

## Executing a command inside a pod

This command is really useful for getting inside a container for debugging connectivity or similar things:

```
kubectl exec [-i] [-t] <pod id> -- <command>
```

If you need to work interactively, specify `-it`, see second example below.

**Example**:

```
~/Projects/k8s-workshop$ kubectl exec notes-api-765315739-9jq49 -- ls -la /
total 60
drwxr-xr-x    1 root     root          4096 May 12 09:53 .
drwxr-xr-x    1 root     root          4096 May 12 09:53 ..
-rwxr-xr-x    1 root     root             0 May 12 09:53 .dockerenv
drwxr-xr-x    2 root     root          4096 May 12 09:53 bin
drwxr-xr-x    5 root     root           380 May 12 09:53 dev
drwxr-xr-x    1 root     root          4096 May 12 09:53 etc
drwxr-xr-x    3 root     root          4096 May 12 09:53 home
drwxr-xr-x    5 root     root          4096 May 12 09:53 lib
lrwxrwxrwx    1 root     root            12 Mar  3 11:20 linuxrc -> /bin/busybox
drwxr-xr-x    5 root     root          4096 May 12 09:53 media
drwxr-xr-x    2 root     root          4096 Mar  3 11:20 mnt
dr-xr-xr-x  298 root     root             0 May 12 09:53 proc
drwx------    4 root     root          4096 May 12 09:53 root
drwxr-xr-x    2 root     root          4096 Mar  3 11:20 run
drwxr-xr-x    2 root     root          4096 May 12 09:53 sbin
drwxr-xr-x    2 root     root          4096 Mar  3 11:20 srv
dr-xr-xr-x   13 root     root             0 May 12 09:53 sys
drwxrwxrwt    3 root     root          4096 May 12 09:53 tmp
drwxr-xr-x    1 root     root          4096 May 11 12:16 usr
drwxr-xr-x    1 root     root          4096 May 12 09:53 var
```

The most useful example for this is actually obtaining a shell in the container:

```
~/Projects/k8s-workshop$ kubectl exec -it portal-api-3638759311-3z1cg -- bash
root@portal-api-3638759311-3z1cg:/usr/src/app#
```

## Restarting a pod

If a pod belongs to a deployment, the simplest way to hard restart a container is to just delete the pod:

```
kubectl delete pod <pod id>
```

The deployment/replica set will immediately see that there is a pod missing in the spec and spin up another instance.

## Display the Kubernetes Dashboard

The following command proxies the Kubernetes API and Dashboard to your localhost at `127.0.0.1:8001`:

```
~/Projects/k8s-workshop$ kubectl proxy
```

The dashboard can be viewed at [http://127.0.0.1:8001/ui](http://127.0.0.1:8001/ui). That little `/ui` bit is important, otherwise Kubernetes will just give you the middle finger.

## Display latest events

The following command shows the latest events (pod scheduling and so on) which occurred on the cluster:

```
~/Projects/k8s-workshop$ kubectl get events
```

This can be useful to see whether there are restarting pods, and/or which pods are currently misbehaving (and thus being killed and restarted).
