# Datasources
data "aws_availability_zones" "available" {
  state = "available"
}

# uses terraform slice function to get first 3 availability zones from the list of all available AZs in the region
# https://developer.hashicorp.com/terraform/language/functions/slice 


