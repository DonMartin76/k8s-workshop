# k8s-workshop

Material for a Kubernetes Workshop

## Creating an `env.sh`

Create a `env.sh` from the [template file](env.sh.template) at the root of this repository and fill in the information needed (Service Principal credentials and so on). The data you need for the first section should have been mailed to you prior to the workshop; if not, contact one of the organizers.

## Further prerequisites

Check the following prerequisites:

* [Installed Azure Command Line 2.0](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
* A usable bash console, e.g. "Terminal" on macOS, "git bash" (if you're still on Win7) or ["Ubuntu bash" for Windows 10](https://msdn.microsoft.com/commandline/wsl/install_guide).
* An ssh identity in `~/.ssh/id_rsa.pub`
* An `openssl` installation (check whether `openssl` in bash gives you a prompt, otherwise install it)
* A GitHub account

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

Additionally, to get the big picture, you should have a look at the presentation which belongs to this workshop (TBA).

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
