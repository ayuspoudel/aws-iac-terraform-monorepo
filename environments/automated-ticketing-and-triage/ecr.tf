resource "aws_ecr_repository" "this" {
  name = "automated-ticketing-and-triage"

  image_tag_mutability = "MUTABLE"  # Allow retagging if needed

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = "Automated Ticketing and Triage"
    ManagedBy = "Terraform"
    Environment = "dev"
  }
}
