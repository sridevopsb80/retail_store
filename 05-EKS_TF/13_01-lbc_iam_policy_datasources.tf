
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