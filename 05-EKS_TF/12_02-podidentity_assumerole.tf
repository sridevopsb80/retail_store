# Datasource: IAM Policy Document 
# a datasource is used to generate aws iam policy json document for assumerole
# same as 06-Catalog_AWS_SM_EBS\iam-policy-json-files\trust-policy.json

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}