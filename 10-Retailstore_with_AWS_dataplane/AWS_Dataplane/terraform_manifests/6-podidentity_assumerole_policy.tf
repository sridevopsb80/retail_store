# Datasource: IAM Trust Policy Document 
# a datasource is used to generate aws iam policy json document for assumerole
# similar to 12_02 in 05-EKS_TF

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"] # allows pods to assume iam role
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}