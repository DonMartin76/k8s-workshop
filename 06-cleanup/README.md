# Closing remarks and cleanup

I hope you enjoyed this crash course in using Kubernetes for DevOps processes. We have reached the end of this course, and now it's time to be a good employer and clean up the mess we made.

You have two possibilities:

* Using the [Azure Portal](https://portal.azure.com)
* Using the `az` command line

## Using the Portal

Follow these steps:

* Open the [Azure Portal](https://portal.azure.com) and log in using your `@haufe.com` login id (it will redirect to ADFS, use your usual AD password)
* Open "Resource Groups"
* Check the filtering, make sure you display the "Cloud Day - Kubernetes Workshop" subscription
* Find your own resource group (it has your first name as a name)
* Click the resource group
* Click "Delete" (or "Löschen" depending on your language setting)
* Confirm the deletion by entering the name of the resource group
* Click "Delete"

Thanks!

## Using the `az` command line

Given that you are already logged in (which you did in the beginning of this workshop), you can do all of the above in one single command:

```
~/Projects/k8s-workshop$ az group delete --name ${YOUR_NAME} --no-wait --yes
```

This will asynchronously delete the entire resource group, but will not wait until it has completed before it comes back.
