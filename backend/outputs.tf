output "state_bucket_name" {
  description = "The name of the S3 bucket used for Terraform state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "lock_table_name" {
  description = "The name of the DynamoDB table used for state locking"
  value       = aws_dynamodb_table.tf_locks.name
}