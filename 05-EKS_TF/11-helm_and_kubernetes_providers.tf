# Defining Helm and Kubernetes providers

# Datasource: EKS Cluster Auth 
# used to generate a short-lived authentication token for accessing an Amazon EKS cluster

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.main.id
}


# HELM Provider
# https://registry.terraform.io/providers/hashicorp/Helm/latest/docs#credentials-config

# helm provider is used to manage helm in eks cluster directly

provider "helm" {
  kubernetes = {
    host                   = aws_eks_cluster.main.endpoint 
    cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data) 
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
# Inputs obtained from 10-eks_outputs.tf
# aws eks cluster endpoint provides the Kubernetes (EKS) Apiserver endpoint


# Terraform Kubernetes Provider

# yaml files can be deployed using tf
# tf has resource to deploy k8s config map. k8s provider will be used for these resources

provider "kubernetes" {
  host = aws_eks_cluster.main.endpoint 
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.cluster.token
}











