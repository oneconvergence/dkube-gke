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
#### Prerequisites for using Role-Based Access Control
You must grant your user the ability to create roles in Kubernetes by running the following command.
```shell
kubectl create clusterrolebinding <rolebinding name> \
               --clusterrole=cluster-admin \
               --user=$(gcloud config get-value account)
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

#### Clone the repository

```shell
git clone https://github.com/oneconvergence/dkube-gke.git
```

#### Pull deployer image

```shell
docker pull gcr.io/cloud-marketplace/dkube-public/dkube/deployer:1.1
```
#### Set parameters

```shell
# set the application instance name
export APP_INSTANCE_NAME=<application instance name>

# set the Kubernetes namespace the application was originally installed
export NAMESPACE=<namespace>

# set dkube Operator Username
export USERNAME=<username>

# set dkube Operator Password
export PASSWORD=<password>

# set Storage class name
export STORAGE_CLASS=standard

# set Reporting secret name (Name of the secret created using licene.yaml)
export REPORTING_SECRET=<reporting secret name>
```
#### Run installer script
```shell
cd dkube-gke

sudo scripts/mpdev scripts/install --deployer=gcr.io/cloud-marketplace/dkube-public/dkube/deployer:1.1 --parameters='{"name": "'$APP_INSTANCE_NAME'", "namespace": "'$NAMESPACE'", "dkubeUsername": "'$USERNAME'", "dkubePassword": "'$PASSWORD'", "reportingSecret": "'$REPORTING_SECRET'", "storageClass": "'$STORAGE_CLASS'"}'
 ``` 
## Uninstall the Application

### Using GKE UI

Navigate to `GKE > Applications` in GCP console. From the list of applications, click on the one that you wish to uninstall.

On the new screen, click on the `Delete` button located in the top menu. It will remove
the resources attached to this application.


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
```




