# ---------------------------------------------------------------
# DynamoDB Table: Items
# ---------------------------------------------------------------
# Creates a serverless, auto-scaling DynamoDB table 
# optimized for both item-level and customer-level queries.
#
# NOTE:
# The Cart microservice code is currently hardcoded to connect
# to the AWS region "us-west-2" (DynamoDB endpoint).
# To ensure compatibility without modifying application code,
# we are creating this DynamoDB table specifically in the
# "us-west-2" region using an aliased AWS provider (aws.west2).
# File: DynamoDBConfiguration.java
# GitHub Link: 
# https://github.com/aws-containers/retail-store-sample-app/blob/v1.3.0/src/cart/src/main/java/com/amazon/sample/carts/config/DynamoDBConfiguration.java
# CodeLine: builder.region(Region.US_WEST_2);
# ---------------------------------------------------------------

# DynamoDB Table: Items - us-west-2
resource "aws_dynamodb_table" "items_west2" {
  provider       = aws.west2
  name           = "Items"
  billing_mode   = "PAY_PER_REQUEST"    # On-demand pricing (no capacity planning)
  hash_key       = "id"

# primary key - supports queries - Get item with ID
  attribute {
    name = "id"
    type = "S"
  }

# used for Global Secondary Index (GSI)
  attribute {
    name = "customerId"
    type = "S"
  }

  # Global Secondary Index for customer-based lookups - Get all items belonging to customer
  global_secondary_index {
    name               = "idx_global_customerId"
    hash_key           = "customerId"
    projection_type    = "ALL"
  }

  tags = {
    Name        = "Items"
    Environment = var.environment_name
    Component   = "Cart"
  }
}
