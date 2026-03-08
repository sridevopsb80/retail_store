# Create EKS Pod Identity Agent, Install Secrets Store CSI Driver and ASCP using Helm

Ensure that VPC and EKS are already provisioned. Use create_cluster script to provision them if they have not been provisioned already. 

In this section, we are going to deploy Catalog microservice, which:

- contains a deployment that manages the application pods,
- contains a statefulset that manages the DB pods,
- uses AWS Secret Manager to manage secrets,
- does not use persistent storage. 

Later, this will be migrated to AWS RDS MySQL database and EBS.

## Step 1: Create EKS Pod Identity Agent

Pod Identity Agent is deployed as a daemonset. It will run on every node and provide pods running in those nodes with the access they need.

* Go to AWS Console -> EKS -> Clusters -> Get Add ons -> Locate Pod Identity Agent plugin -> choose and leave default options -> click on Create.

* Use kubectl get ds command to verify the agent was installed.

This section will be done manually for verification.

## Step 2: Install Helm locally and add helm repos for CSI Driver and AWS Provider plugin ASCP

[Ensure that Helm CLI is installed.](https://helm.sh/docs/intro/install/)

Run [Helm script to add the repos and to update them](scripts/helm.sh).

Workflow: Pod -> Secrets Store CSI Driver -> AWS Provider Plugin (ASCP) -> AWS Secrets Manager.

Secrets Store CSI Driver - Kubernetes driver that allows pods to mount secrets from external secret stores as volumes.

AWS Secrets and Configuration Provider (ASCP): AWS provider plugin for the CSI driver. CSI driver itself doesn't know how to talk to secret systems.  It needs a provider plugin so that it can fetch secrets from AWS Secrets Manager.

## Step 3: Install the Secrets Store CSI Driver and ASCP using Helm in EKS kube-system namespace 

Run [Script to install CSI driver and ASCP to kube-system namespace in EKS Cluster](scripts/install_csi_driver_and_ascp.sh).

## Step 4: Create IAM Role, Policy and EKS Pod Identity Association

Run [IAM bash script](scripts/iam_role_and_policies.sh). This creates all necessary resources for **Catalog microservice only**.

## Step 5: Create Pod Identity Association

Run [PIA script](scripts/pod_identity_association.sh). 

## Step 6: Connect AWS Secrets Manager with Kubernetes Pods 

We will securely connect AWS Secrets Manager with Catalog microservice pods so that credentials to MySQL DB can be shared. In this zero-trust setup, credentials are not stored in Kubernetes Secrets and are fetched dynamically via ASCP.

## Step 7: Create AWS Secret in Secrets Manager

Run [Connect_AWS_SM_and_Catalog script](scripts/Connect_AWS_SM_and_Catalog.sh). 

- Create the secret with MySQL credentials in AWS Secret Manager, 
- Define a SecretProviderClass that retrieves this secret using EKS Pod Identity,
- Update both the MySQL StatefulSet and Catalog Deployment to mount and use these secrets,
- Retrieve Secret from AWS Secret Manager without storing Kubernetes Secrets in etcd minimizing risk of exposing secrets if the cluster is ever compromised.

## Step 8: Cleanup

Run [Cleanup script](scripts/cleanup_catalog.sh). 

















## Resources needed:

1. IAM role with readonly access to S3
2. Info on the Namespace where the workload is running
3. Service Account

## Steps involved:

### Step 1: Create a Pod and a Service Account 

* We will create a pod (aws cli pod) and deploy it in eks cluster default namespace. This pod will be used to test access to S3 using ```aws s3 list``` command. 

* Use manifest files in kube-manifests folder to create Service Account and AWS CLI Pod.
```bash
kubectl apply -f kube-manifests/01_k8s_service_account.yaml
kubectl apply -f kube-manifests/02_k8s_aws_cli_pod.yaml
```

* Check if pod is up and running. 
```bash
kubectl get pods -n default
```

* Check if Service Account is created.
```bash
kubectl get sa
```

* Check if you have access to S3 from the aws-cli pod
```bash
kubectl exec -it aws-cli -- aws s3 ls
```

* You should notice an error about lack of credentials.
```bash
aws: [ERROR]: An error occurred (NoCredentials): Unable to locate credentials. You can configure credentials by running "aws login".
command terminated with exit code 253
```

### Step 2: Create eks Pod Identity Agent

Pod Identity Agent is deployed as a daemonset. It will run on every node and provide pods running in those nodes with the access they need.

* Go to AWS Console -> EKS -> Clusters -> Get Add ons -> Locate Pod Identity Agent plugin -> choose and leave default options -> click on Create.

* Use kubectl get ds command to verify the agent was installed.

### Step 3: Create IAM Role

* Go to AWS Console -> IAM -> Roles -> Create Role.

* Select Trusted Entity - Choose Trusted entity type as AWS Service -> Choose Service or Use case as EKS and EKS - Pod Identity.

* Add Permissions - Choose AmazonS3ReadOnlyAccess to provide read only access to S3.

* Name the role (EKS-PodIdentity-S3-ReadOnly-Role). Create Role.

### Step 4: Associate IAM Role to EKS Cluster

* Go to AWS Console -> EKS -> Clusters -> Access -> Pod Identity Association -> Click on Create. 

* Pod Identity configuration: IAM Role -> Choose EKS-PodIdentity-S3-ReadOnly-Role. Kubernetes namespace -> default. Kubernetes service account -> aws-cli-sa. Click on Create.

* Go to AWS Console -> EKS -> Clusters -> Access -> Pod Identity Association. Check if the entry has been added.

### Step 5: Recreate pods

Pods do not automatically refresh credentials after Pod Identity Association is added. Delete and recreate pods.
```bash
kubectl delete pod aws-cli -n default
kubectl apply -f kube-manifests/02_k8s_aws_cli_pod.yaml
```

Verify if the pods can list S3 now.
```bash
kubectl exec -it aws-cli -- aws s3 ls
```

### Step 6: Cleanup

* Delete the pod and the Service Account.
```bash
kubectl delete -f kube-manifests/
```

* Remove Pod Identity Association → via EKS Console → Access → Pod Identity Associations.

* Remove IAM role → via IAM Console → Roles EKS-PodIdentity-S3-ReadOnly-Role-101


