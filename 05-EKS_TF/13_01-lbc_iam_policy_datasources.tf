# Files 13-01 till 13-04 automates installation of LBC. 

# 13-01, 13-02, 13-03 automates 08-K8s_Ingress\scripts\10-IAM_roles_policies_PIA_association_fo_AWS_LBC.sh
# 13-04 automates 08-K8s_Ingress\scripts\11-Install_Load Balancer Controller.sh


# Datasource: Get AWS LBC IAM Policy from official doc using http datasource
data "http" "lbc_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

# LBC IAM Policy
/*
output "lbc_iam_policy" {
  value = data.http.lbc_iam_policy.response_body 
}
*/

# output block can be enabled for troubleshooting