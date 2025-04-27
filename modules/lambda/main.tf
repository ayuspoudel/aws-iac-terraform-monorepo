resource "aws_lambda_function" "this" {
  function_name = local.function_name
  runtime       = var.function_runtime
  handler       = var.function_handler
  # filename      = var.function_source_path
  role          = var.lambda_role_arn  # Assume you pass the IAM Role ARN separately (I'll explain this below)
  image_uri     = var.image_uri
  tags = local.all_tags
}
