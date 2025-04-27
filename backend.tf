terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-20250422249"
    key            = "environments/${terraform.workspace}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}