# Provision a cluster on Azure Container Service

Make sure you fulfill the prerequisites described on the main [README](../README.md).

## Provisioning the cluster

Run the following commands from the root of this repository to prime your environment variables and log in to Azure via the command line.

Load the environment variables into your terminal session:

```
~/Projects/k8s-workshop$ . env.sh
```

Then log in to Azure using the `az` command line:

```
~/Projects/k8s-workshop$ az login --service-principal -u $SP_APPID -p $SP_PASSWORD -t $SP_TENANT
...
~/Projects/k8s-workshop$ az account set --subscription $SP_SUBSCRIPTION
```

Now you're logged in in the local bash with the given Azure Service Principal. We will now create a resource group to play with and then provision the Kubernetes cluster:

```
~/Projects/k8s-workshop$ az group create --name $YOUR_NAME --location northeurope
...
~/Projects/k8s-workshop$ az acs create --orchestrator-type kubernetes \
    --service-principal $SP_APPID \
    --client-secret $SP_PASSWORD \
    --name $YOUR_NAME \
    --resource-group $YOUR_NAME \
    --location northeurope \
    --admin-username azureuser \
    --agent-count 2 \
    --master-count 1 \
    --agent-vm-size Standard_DS3_v2
```

That last thing will take quite a while (several minutes, up to ten). If you want, point your browser to https://portal.azure.com, log in using your corporate username and password; the subscription will have been added to your account (and will be removed after the workshop).

There you will be able to see your newly create resource group, and the resources which the ACS provisioning script creates for the Kubernetes cluster, like the Agent and Master VMs, a VNET, and a couple of load balancers.

Meanwhile, install the command line utility:

## Installing `kubectl`

To be able to talk to the Kubernetes cluster, you will need to install the `kubectl` command line tool.

### On macOS - Using homebrew

The easiest way to install `kubectl` on macOS is using Homebrew:

```
$ brew install kubectl
```

### On macOS or Windows - using `az`

As an alternative, the `az` command line tool also provides a way to install the command line utility. **IMPORTANT for Windows**: Run the following command in a "Command Line" run as **Administrator**! Otherwise it will not work. I.e., it will **not** work from the git bash shell.

```
~/Projects/k8s-workshop$ az acs kubernetes install-cli
```

### Windows - the hard way

In case the above does not work, e.g. it might work but you can't call `kubectl` from git bash, do the following:

In git bash, download the `kubectl.exe` binary directly to the current directory:

```
$ curl -O https://storage.googleapis.com/kubernetes-release/release/v1.7.1/bin/windows/amd64/kubectl.exe
```

Then copy `kubectl.exe` to somewhere in your path; this may be `~/bin` or somewhere else. This may require some fiddling.

## Retrieving the `kubeconfig`

After the cluster has been provisioned successfully (I hope we don't run into ARM throttling here, this is going to be interesting).

To be able to use `kubectl`, the CLI tool needs to know where the cluster resides, and with which credentials it can talk to it. ACS puts a valid `kubeconfig` file on the master node(s), at `/home/<admin user>/.kube/config`, with our above configuration at `/home/azureuser/.kube/config`.

For convenience, the `az` tool provides the following command to copy the file from there:

```
~/Projects/k8s-workshop$ az acs kubernetes get-credentials --resource-group ${YOUR_NAME} \
    --name ${YOUR_NAME} \
    --file ./kubeconfig
```

Now you will have a local `kubeconfig` file which contains the credentials and URL to talk to the Kubernetes cluster. If you check the `env.sh` file you will find an environment variable `KUBECONFIG` which already points to this file; this means `kubectl` will use this configuration file. Otherwise, `kubectl` would search in `~/.kube/config`, but it's often more convenient to explicitly specify which `kubeconfig` file you want to use.

## Verify cluster connectivity

Now you should be able to verify that you can connect to the cluster using `kubectl`:

```
~/Projects/k8s-workshop$ kubectl get nodes
NAME                    STATUS                     AGE       VERSION
k8s-agent-54721596-0    Ready                      9m        v1.6.6
k8s-agent-54721596-1    Ready                      9m        v1.6.6
k8s-master-54721596-0   Ready,SchedulingDisabled   9m        v1.6.6
```

Woohoo!
