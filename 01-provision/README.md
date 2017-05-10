# Provision a cluster on Azure Container Service

If you haven't already, please create a `env.sh` from the [template file](../env.sh.template) at the root of this repository and fill in the information needed (Service Principal credentials and so on).

Further prerequisites:

* [Installed Azure Command Line 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* A usable bash console, e.g. "Terminal" on macOS, "git bash" (if you're still on Win7) or ["Ubuntu bash" for Windows 10](https://msdn.microsoft.com/commandline/wsl/install_guide).
* An ssh identity in `~/.ssh/id_rsa.pub`

## Provisioning the cluster

Run the following commands from the root of this repository:

```
~/Projects/k8s-workshop$ . env.sh
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

That last thing will take quite a while. If you want, point your browser to https://portal.azure.com, log in using your corporate username and password; the subscription will have been added to your account (and will be removed after the workshop).

There you will be able to see your newly create resource group, and the resources which the ACS provisioning script creates for the Kubernetes cluster, like the Agent and Master VMs, a VNET, and a couple of load balancers.

## Installing `kubectl`

To be able to talk to the Kubernetes cluster, you will need to install the `kubectl` command line tool.

### On macOS - Using homebrew

The easiest way to install `kubectl` on macOS is using Homebrew:

```
$ brew install kubectl
```

### On macOS or Windows - using `az`

As an alternative, the `az` command line tool also provides a way to install the command line utility:

```
~/Projects/k8s-workshop$ az acs kubernetes install-cli
```

## Retrieving the `kubeconfig`

To be able to use `kubectl`, the CLI tool needs to know where the cluster resides, and with which credentials it can talk to it. ACS puts a valid `kubeconfig` file on the master node(s), at `/home/<admin user>/.kube/config`, with our above configuration at `/home/azureuser/.kube/config`.

For convenience, the `az` tool provides the following command to copy the file from there:

```
~/Projects/k8s-workshop$ az acs kubernetes get-credentials --resource-group ${YOUR_NAME} \
    --name ${YOUR_NAME} \
    --file ./kubeconfig
~/Projects/k8s-workshop$ export KUBECONFIG=`pwd`/kubeconfig
```

Now you will have a local `kubeconfig` file which contains the credentias and URL to talk to the Kubernetes cluster, and with the env variable `KUBECONFIG` you let `kubectl` use this exact file. Otherwise, `kubectl` would search in `~/.kube/config`, but it's often more convenient to explicitly specify which `kubeconfig` file you want to use.

## Verify cluster connectivity

Now you should be able to verify that you can connect to the cluster using `kubectl`:

```
~/Projects/k8s-workshop$ kubectl get nodes
NAME                    STATUS                     AGE       VERSION
k8s-agent-54721596-0    Ready                      9m        v1.5.3
k8s-agent-54721596-1    Ready                      9m        v1.5.3
k8s-master-54721596-0   Ready,SchedulingDisabled   9m        v1.5.3
```

Woo!
