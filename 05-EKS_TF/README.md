# Creating EKS Cluster 

This section will be used to create an EKS cluster. 
Ensure that S3 is configured as backend and the underlying VPC architecture is already provisioned before creating EKS cluster.

## Steps to Provision manually

```bash
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply
```

## Use shell script

Alternatively, execute scripts/create-cluster.sh script to create VPC and EKS cluster.

## Configure kubectl cli to access EKS cluster

After the EKS Cluster is created, get the "to_configure_kubectl" value from the output. This gives the command which should enable you to connect to your cluster.

![Before configuration](../images/before-configuring-kubectl.png)

![To configure](../images/to-configure-kubectl.png)

```bash
# EKS kubeconfig
aws eks update-kubeconfig --name <cluster_name> --region <aws_region>
```
![After configuration](../images/after-configuring-kubectl.png)

```bash
# List Kubernetes Nodes
kubectl get nodes

# List Kubernetes Pods 
kubectl get pods -n kube-system
```

# Installing EKS Cluster AddOns using Terraform on EKS Cluster

## Following Addons will be added to the EKS Cluster with Terraform:

* AWS Load Balancer Controller (LBC) - automatically provisions and manages Load Balancers (ALB/NLB) when Kubernetes resources such as Ingress and LoadBalancer Service are defined. Refer tf files 13_01 till 13_04.
* Amazon EBS CSI Driver - dynamically provisions Amazon EBS volumes for StatefulSets. Refer tf files 14_01 till 14_03.
* Secrets Store CSI Driver (with ASCP) - mounts AWS Secrets Manager / SSM Parameter Store secrets directly into Pods (with ASCP). Refer tf files 15_01 and 15_02.
* EKS Pod Identity Agent - allows Pods to assume IAM Roles (for secure access to AWS Services). By using IAM Roles, services can be accessed securely without storing credentials locally. Refer tf files 12_01 and 12_02.

## Execution Flow:

* Create VPC Infrastructure (refer Section-04) and EKS Infrastructure using Terraform. Use create_cluster.sh script in scripts folder to create VPC and EKS. 
* Install Addons to EKS.




















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


