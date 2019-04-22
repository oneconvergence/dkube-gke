# DKube-gke
DKube on GCP Marketplace 

## Quick Install with Google Cloud Marketplace

Deploy DKube to Google Kubernetes Engine using the Google Cloud Marketplace, by following the guidelines below at the [deployment screen](https://console.cloud.google.com/marketplace/details/dkube-public/dkube?filter=solution-type:k8s&q=dkube&project=dkube-public).

## Installation Flow

### Initial Screen

Select "Configure" to start installation procedure.

![](gcp-Marketplace/gcp-Configure.png)

This will take you to the "New DKube Deployment" screen.

### Deployment Screen

* Select "Click to Deploy on GKE"

The following table explains the selections.

Selection | Input
--------- | ------
Cluster  | Choose "GKE Cluster" (do not change)
Namespace | Choose "Create a Namespace"
New Namespace Name | Choose a unique name
App Instance Name | Choose a unique name to identify it
Cluster Admin Service Account | Choose "Create a new service account"
DKube User | Choose the user name for initial login
DKube Password | Choose the password for initial login
Service Account | Do not change

Select "Deploy"

This will bring up the Application Starting, then Application Details Screen

### Application Details Screen

The application will run for several minutes.  The progress can be reviewed by selecting the refresh button at the top of the screen.

![](gcp-Marketplace/gcp-Refresh.png)

An error indication will appear during the installation saying "Some components have errors".  These errors should resolve themselves as the installation progresses.  After a few minutes, the installation will display success.

![](gcp-Marketplace/gcp-Success.png)

If the installation does not show success after 10 minutes, do the cleanup routine (described below) and install again.

### Accessing DKube

Still to be filled in...

### Deleting the Application

After the user is finished using DKube, the application should be deleted to free up resources for a new installation.  This is done from the Application screen.  Select the application to be deleted, and select the Delete button.

![](gcp-Marketplace/gcp-Delete.png)

### Namespace Cleanup

After deleting the application, the namespace needs to be deleted as well.  This is initiated from the Cluster screen.  Find the cluster name used in the installation, and connect to it.

![](gcp-Marketplace/gcp-Cluster.png)

Select "Run in Cloud Shell"

![](gcp-Marketplace/gcp-Connect.png)

Get a list of the namespaces using kubectl command "kubectl get ns".  Find the namespace in the list and delete it by running "kubectl delete ns [xxx]".

![](gcp-Marketplace/gcp-Cleanup.png)





