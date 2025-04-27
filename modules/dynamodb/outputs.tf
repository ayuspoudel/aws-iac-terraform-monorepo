output "table_name" {
  description = "The name of the DynamoDB table created."
  value       = aws_dynamodb_table.this.name
}

output "table_id" {
  description = "The ID/ARN of the DynamoDB table created."
  value       = aws_dynamodb_table.this.id
}
