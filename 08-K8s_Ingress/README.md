# Implement Ingress in EKS using Amazon Load Balancer Controller (with Pod Identity)


Steps:

* Create a Trust policy file for Load Balancer Controller IAM Role.
* Create and attach AWSLoadBalancerControllerIAMPolicy to IAM Role.
* Create an EKS Pod Identity Association between the IAM Role and AWS LBC ServiceAccount.
* Install the AWS Load Balancer Controller using Helm.

How IAM Policies and IAM Role are connected:

![IAM Policies and IAM Role](../images/LBC_IAM_and_policies.jpg)

LBC Workflow:

![LBC Traffic](../images/LBC_traffic.jpg)

## Pre-requisite: VPC and EKS 

Ensure that VPC and EKS are already provisioned.

- Use [create_cluster](scripts/00-create_cluster.sh) script to provision them if they have not been provisioned already. 
- If you run into "Error locating Chart" error, update the helm repo.

![Error locating Chart](../images/error_locating_chart.jpg)

This should provision the VPC, EKS and the necessary EKS Add-ons.

- After the provisioning, note down the values from Outputs. Run the command from to_configure_kubectl output to make sure cli is connected to EKS cluster. 

![Configure kubectl](../images/to-configure-kubectl.png)

![Check Configuration](../images/after-configuring-kubectl.png)

## Deploy HTTP Ingress and microservices

Run [Deploy http ingress](scripts/12-Deploy_http_ingress.sh) script.

## Deploy HTTPS Ingress and microservices

Steps involved:

- Request a Public Certificate in AWS Certification Manager.
- Validate via DNS: ACM will show CNAME records to create in Route53 → Hosted Zone.
- Get the ARN of the Certificate.
- Update HTTPS Ingress manifest files (both instance mode and ip mode) with the updated ARN.     
```bash
## SSL Settings
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:180789647333:certificate/af739d1d-c527-4a44-a753-464f775dca25
```
- Run [Deploy https ingress](scripts/13-Deploy_https_ingress.sh) script.