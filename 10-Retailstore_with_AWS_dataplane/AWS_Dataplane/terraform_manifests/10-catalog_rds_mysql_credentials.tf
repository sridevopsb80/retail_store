# Use existing AWS Secrets Manager Secret (already created manually)
# accessing manually created aws secret manager secret using datasources

data "aws_secretsmanager_secret" "retailstore_secret" {
  name = "retailstore-db-secret-1"
}

data "aws_secretsmanager_secret_version" "retailstore_secret_value" {
  secret_id = data.aws_secretsmanager_secret.retailstore_secret.id
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret_version#argument-reference
# secret string is an attribute of aws_secretsmanager_secret_version datasource. 
# it provides the Decrypted part of the protected secret information that was originally provided as a string in json format
# json decode is used to decode that

locals {
  retailstore_secret_json = jsondecode(data.aws_secretsmanager_secret_version.retailstore_secret_value.secret_string)
}


# --------------------------------------------------------------------
# ⚠️ TEMPORARY DEBUG OUTPUTS (NOT RECOMMENDED FOR PRODUCTION)
# --------------------------------------------------------------------
# These outputs are only for verifying that Terraform correctly fetched
# username and password from AWS Secrets Manager. 
# REMOVE or comment out after validation to avoid exposing credentials.
# --------------------------------------------------------------------

output "debug_retailstore_secret_username" {
  description = "⚠️ For testing only: DB username from Secrets Manager"
  value       = local.retailstore_secret_json.username
  sensitive   = true
}

output "debug_retailstore_secret_password" {
  description = "⚠️ For testing only: DB password from Secrets Manager"
  value       = local.retailstore_secret_json.password
  sensitive   = true
}

# If you want to actually see the values just once (for validation), you can run:
# terraform output -json | jq -r '.debug_retailstore_secret_username.value'
# terraform output -json | jq -r '.debug_retailstore_secret_password.value'

