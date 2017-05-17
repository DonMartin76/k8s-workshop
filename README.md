# Haufe Kubernetes Lab/Workshop

This repository contains material for a Kubernetes Workshop/Lab, hopefully just about enough for until lunch (3-4 hours).

## Prerequisites

Check the following prerequisites:

* You should be familiar with containers and docker, even if it's not a true prerequisite. But it does help.
* Basic familiarity with the [Azure Portal](https://portal.azure.com); make sure you are able to log in using your `<login>@haufe.com` ID
* [Installed Azure Command Line 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli); in case you already had it install, please run a `az component update`
* A usable bash console, e.g. "Terminal" on macOS, "git bash" (if you're still on Win7) or ["Ubuntu bash" for Windows 10](https://msdn.microsoft.com/commandline/wsl/install_guide).
* An ssh identity in `~/.ssh/id_rsa[.pub]`
* An `openssl` installation (check whether `openssl` in bash gives you a prompt, otherwise install it)
* A GitHub account (we need this to provision OAuth2 credentials)

## Creating an `env.sh`

After you have received the credentials from the organizers (the service principal definition), create a `env.sh` from the [template file](env.sh.template) at the root of this repository and fill in the information needed (Service Principal credentials and so on). The data you need for the first section should have been sent to you just prior to the workshop via Rocket.Chat; if not, contact one of the organizers.

## Clone this repository before you start

You will need all the things inside this repository, so please clone the repository onto your local machine. Throughout the entire workshop/lab, it's assumed that the repository is placed in `~/Projects/k8s-workshop`, so wherever you see commands which need to be issued from the command line, this is the directory you should have `cd`:d into.

```
~/Projects$ git clone https://github.com/DonMartin76/k8s-workshop
Cloning into "k8s-workshop"...
~/Projects$ cd k8s-workshop
~/Projects/k8s-workshop$ # Happy labbing!
```

## Following along

Go through the workshop/lab description in the order of the steps; each step usually needs what's created in the previous step(s), so skipping steps will most probably not work. Like, at all.

Additionally, to get the big picture, you should have a look at the [presentation which belongs to this workshop](kubernetes-workshop-20170517-v1.pdf).

So, start here:

* [Provision the cluster](01-provision)
* [Deploy a simple application](02-simple-app)
* [On Ingress Controllers and stuff](03-ingress-controller)
* [Deploying the entire application](04-full-app)
* [Updating a deployment (rolling updates)](05-update)
* [Cleaning up after yourself](06-cleanup)
* [Appendix - Useful Kubernetes commands](07-appendix)

HAVE FUN!

Please feedback into the issues of this repository, so that I can improve for the next time.
