# Create EKS Pod Identity Agent, Install Secrets Store CSI Driver and ASCP using Helm

In this section, we are going to deploy Catalog microservice, which:

- contains a deployment that manages the application pods,
- contains a statefulset that manages the DB pods,
- uses AWS Secret Manager to manage secrets,
- does not use persistent storage. 

Later, this will be migrated to AWS RDS MySQL database and EBS.

## Pre-requisite: VPC and EKS 

Ensure that VPC and EKS are already provisioned. Use create_cluster script to provision them if they have not been provisioned already. Run the command from to_configure_kubectl output to make sure cli is connected to EKS cluster. 

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

Run [IAM bash script](scripts/iam_role_and_policies_for_catalog.sh). This creates all necessary resources for **Catalog microservice only**.

## Step 5: Create Pod Identity Association

Run [PIA script](scripts/pod_identity_association.sh). 

## Step 6: Connect AWS Secrets Manager with Kubernetes Pods 

We will securely connect AWS Secrets Manager with Catalog microservice pods so that credentials to MySQL DB can be shared. In this zero-trust setup, credentials are not stored in Kubernetes Secrets and are fetched dynamically via ASCP.

Run [Connect_AWS_SM_and_Catalog script](scripts/Connect_AWS_SM_and_Catalog.sh). 

- Create the secret with MySQL credentials in AWS Secret Manager, 
- Define a SecretProviderClass that retrieves this secret using EKS Pod Identity,
- Update both the MySQL StatefulSet and Catalog Deployment to mount and use these secrets,
- Retrieve Secret from AWS Secret Manager without storing Kubernetes Secrets in etcd minimizing risk of exposing secrets if the cluster is ever compromised.

## Step 8: Cleanup

Run [Cleanup script](scripts/cleanup_catalog.sh). 

