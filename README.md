# dkube-gke
DKube on GCP Marketplace 

## Quick install with Google Cloud Marketplace

Deploy dkube to Google Kubernetes Engine using Google Cloud Marketplace, by following the [on-screen instructions](https://console.cloud.google.com/marketplace/details/dkube-public/dkube?filter=solution-type:k8s&q=dkube&project=dkube-public).

## Command line instructions

### Prerequisites

#### Set up command-line tools

You'll need the following tools:
- [gcloud](https://cloud.google.com/sdk/gcloud/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [docker](https://docs.docker.com/install/)


Make sure you follow the Linux post-install instruction to enable running docker as non-root

Configure `gcloud` as a Docker credential helper:

```shell
gcloud auth configure-docker
```

#### Create a Google Kubernetes Engine cluster

Create a new cluster from the command-line.

```shell
export CLUSTER=<cluster-name>
export ZONE=<zone>

gcloud container clusters create $CLUSTER --zone $ZONE --image-type ubuntu --machine-type <type> --num-nodes=<number of nodes> 
```

Configure `kubectl` to talk to the new cluster.

```shell
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
```
Assign cluster-admin role to the user
```shell
kubectl create clusterrolebinding <rolebinding name> --clusterrole=cluster-admin --user=<userid>
```


#### Install application crd:
```shell
kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"
```

#### Create namespace:
```shell
kubectl create namespace <application namespace>
```

#### Generate license key 
generate license key  (https://console.cloud.google.com/marketplace/kubernetes/config/dkube-public/dkube?version=1.0&project=dkube-public )

Add namespace to license.yaml

```shell
kubectl apply -f license.yaml 
```
### Deploy Dkube
```shell
export REGISTRY=gcr.io/cloud-marketplace/dkube-public
export APP_NAME=dkube

mpdev /scripts/install   --deployer=$REGISTRY/$APP_NAME/deployer:1.0   --parameters='{"name": "dkube-deployment", "namespace": "dkube", "dkubeOperatorGithubUsername": "ocdkube", "dkubeOperatorGithubToken": "fd5645501e6875c2aa786905b5899734b0cb6b2b", "dkubeOperatorGithubOrganization": "oneconvergence", "dkubeOperatorGithubClientSecret": "0c2ebf0a72fa7daf23aad5730b441d221e9a5512", "dkubeOperatorGithubClientID": "727e542daff6a6dc683a", "reportingSecret": "<name of secret in license.yaml>"}'
 ``` 
## Uninstall the Application

### Using GKE UI

Navigate to `GKE > Applications` in GCP console. From the list of applications, click on the one that you wish to uninstall.

On the new screen, click on the `Delete` button located in the top menu. It will remove
the resources attached to this application.

Namespace created for user is to be cleaned up manually using the below command:
```shell
kubectl delete ns -l heritage=dkube
```
```shell
kubectl delete service alertmanager-operated prometheus-operated nfs-server -n <namespace>
kubectl delete crd alertmanagers.monitoring.coreos.com prometheuses.monitoring.coreos.com prometheusrules.monitoring.coreos.com servicemonitors.monitoring.coreos.com
kubectl delete deploy nfs-server -n <namespace>
```

### Using the command line

#### Prepare the environment

Set your installation name and Kubernetes namespace:

```shell
export APP_INSTANCE_NAME=<app-name>
export NAMESPACE=<namespace>
```

#### Delete the resources
```shell
Kubectl delete application $APP_INSTANCE_NAME -n $NAMESPACE
kubectl delete ns -l heritage=dkube
```
```shell
kubectl delete service alertmanager-operated prometheus-operated nfs-server -n <namespace>
kubectl delete crd alertmanagers.monitoring.coreos.com prometheuses.monitoring.coreos.com prometheusrules.monitoring.coreos.com servicemonitors.monitoring.coreos.com
kubectl delete deploy nfs-server -n <namespace>
```



