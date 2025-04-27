resource "aws_dynamodb_table" "this" {
  name         = local.generated_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.merged_tags

  lifecycle {
    prevent_destroy = true
  }
}
