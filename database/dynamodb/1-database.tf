# Create Table
resource "aws_dynamodb_table" "orders" {
  name           = var.name
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  table_class = "STANDARD"
  hash_key       = "customerId" # Parition Key
  range_key      = "orderId" # Sort key

   # Parition Key
  attribute {
    name = "customerId"
    type = "S"
  }

  # Sort key
  attribute {
    name = "orderId"
    type = "S"
  }
}

# Create Index
resource "aws_dynamodb_table_item" "item_1" {
  table_name = aws_dynamodb_table.orders.name
  hash_key   = aws_dynamodb_table.orders.hash_key
  range_key  = aws_dynamodb_table.orders.range_key

  item = <<ITEM
{
  "customerId": {"S": "customer-1"},
  "orderId": {"S": "Order-100"},
  "price": {"N": "100"},
  "delivered": {"BOOL": true}
}
ITEM
}

resource "aws_dynamodb_table_item" "item_2" {
  table_name = aws_dynamodb_table.orders.name
  hash_key   = aws_dynamodb_table.orders.hash_key
  range_key  = aws_dynamodb_table.orders.range_key

  item = <<ITEM
{
  "customerId": {"S": "customer-1"},
  "orderId": {"S": "Order-50"},
  "price": {"N": "50"},
  "delivered": {"BOOL": true}
}
ITEM
}

resource "aws_dynamodb_table_item" "item_3" {
  table_name = aws_dynamodb_table.orders.name
  hash_key   = aws_dynamodb_table.orders.hash_key
  range_key  = aws_dynamodb_table.orders.range_key

  item = <<ITEM
{
  "customerId": {"S": "customer-2"},
  "orderId": {"S": "Order-50"},
  "price": {"N": "50"},
  "delivered": {"BOOL": false}
}
ITEM
}