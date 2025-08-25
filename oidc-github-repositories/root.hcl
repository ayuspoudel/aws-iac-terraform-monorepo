# Root terragrunt.hcl for all GitHub OIDC repos
# Author: Ayush Poudel | Date: Aug 25, 2025

remote_state {
  backend = "s3"

  config = {
    bucket         = "clodstco-terraform-state"            # replace with your S3 bucket
    key            = "oidc-github-repositories/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"                # optional, if you use state locking
    encrypt        = true
  }
}
