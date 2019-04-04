# dkube-gke
DKube on GCP Marketplace 

## Quick install with Google Cloud Marketplace

Deploy dkube to Google Kubernetes Engine using Google Cloud Marketplace, by following the [on-screen instructions](https://console.cloud.google.com/marketplace/details/dkube-public/dkube?filter=solution-type:k8s&q=dkube&project=dkube-public).

## Command line instructions

### Prerequisites

#### Set up command-line tools

You'll need the following tools in your development environment:
- [gcloud](https://cloud.google.com/sdk/gcloud/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [Helm](https://github.com/kubernetes/helm/blob/master/docs/install.md)
- [docker](https://docs.docker.com/install/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

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
```shell
kubectl create clusterrolebinding <rolebinding name> --clusterrole=cluster-admin --user=<userid>
```

### Pull google's dev container
docker pull gcr.io/cloud-marketplace-tools/k8s/dev
Extract the helper script for running the dev tools. This command creates an executable mpdev in your user bin directory. (Note: there isn't already the bin directory in your home directory, you'll need to create it and add it to $PATH, or log out and log back in for it to be automatically added to $PATH.)
BIN_FILE="$HOME/bin/mpdev"
docker run \
  gcr.io/cloud-marketplace-tools/k8s/dev \
  cat /scripts/dev > "$BIN_FILE"
chmod +x "$BIN_FILE"

### Install application crd:
kubectl apply -f "https://raw.githubusercontent.com/GoogleCloudPlatform/marketplace-k8s-app-tools/master/crd/app-crd.yaml"

### Create namespace:
kubectl create namespace dkube

### Generate license key 
generate license key froom https://console.cloud.google.com/marketplace/kubernetes/config/dkube-public/dkube?version=1.0&project=dkube-public 


kubectl apply -f license.yaml 

## Deploy Dkube

export REGISTRY=gcr.io/cloud-marketplace/dkube-public
export APP_NAME=dkube

mpdev /scripts/install   --deployer=$REGISTRY/$APP_NAME/deployer:1.0   --parameters='{"name": "dkube-deployment", "namespace": "dkube", "dkubeOperatorGithubUsername": "ocdkube", "dkubeOperatorGithubToken": "fd5645501e6875c2aa786905b5899734b0cb6b2b", "dkubeOperatorGithubOrganization": "oneconvergence", "dkubeOperatorGithubClientSecret": "0c2ebf0a72fa7daf23aad5730b441d221e9a5512", "dkubeOperatorGithubClientID": "727e542daff6a6dc683a", "reportingSecret": "<name of secret in license.yaml>"}'
  
# Uninstall the Application

## Using GKE UI

Navigate to `GKE > Applications` in GCP console. From the list of applications, click on the one that you wish to uninstall.

On the new screen, click on the `Delete` button located in the top menu. It will remove
the resources attached to this application.

Namespace created for user is to be cleaned up manually using the below command:
kubectl delete ns -l heritage=dkube

## Using the command line

### Prepare the environment

Set your installation name and Kubernetes namespace:

```shell
export APP_INSTANCE_NAME=<app-name>
export NAMESPACE=<namespace>
```

### Delete the resources
Kubectl delete application $APP_INSTANCE_NAME -n $NAMESPACE
kubectl delete ns -l heritage=dkube





